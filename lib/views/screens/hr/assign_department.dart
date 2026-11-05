// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/base/animated_dots_loader.dart';
import 'package:kmsmerino/views/screens/hr/hr_functions.dart';
import 'package:kmsmerino/utils/common_toast.dart';

class AssignDepartment extends StatefulWidget {
  final Map<String, dynamic> manager;
  final Widget parentScreen;

  const AssignDepartment({
    super.key,
    required this.manager,
    required this.parentScreen,
  });

  @override
  State<AssignDepartment> createState() => _AssignDepartmentState();
}

class _AssignDepartmentState extends State<AssignDepartment> {
  List<Map<String, dynamic>> _departments = [];
  List<int> _selectedDepartmentIds = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Print manager ID
      debugPrint('Manager ID: ${widget.manager['id']}');
      debugPrint('Manager Name: ${widget.manager['name']}');
      debugPrint('Manager Department ID: ${widget.manager['department_id'] ?? widget.manager['department']}');
      debugPrint('Manager Department Name: ${widget.manager['department']}');

      
      // Load all departments
      List<Map<String, dynamic>> departments = await getAllDepartments();
      
      // Load manager's current departments from the manager data
      List<int> currentDeptIds = [];
      
      // Check if manager already has departments assigned
      if (widget.manager['departments'] != null) {
        List<dynamic> managerDepts = widget.manager['departments'];
        currentDeptIds = managerDepts.map<int>((dept) => dept['id'] as int).toList();
        debugPrint('Manager\'s Current Department IDs: $currentDeptIds');
      } else if (widget.manager['assigned_departments'] != null) {
        // Parse comma separated string and match with loaded departments
        String assignedDeptsStr = widget.manager['assigned_departments'].toString();
        List<String> assignedNames = assignedDeptsStr.split(',').map((e) => e.trim()).toList();
        
        for (var dept in departments) {
          if (assignedNames.contains(dept['name'])) {
            currentDeptIds.add(dept['id']);
          }
        }
        debugPrint('Manager\'s Assigned Departments from string: $currentDeptIds');
      } else {
        // Fallback to department field if departments array is not available
        var deptId = widget.manager['department'];
        if (deptId != null) {
          currentDeptIds = [deptId is int ? deptId : int.parse(deptId.toString())];
          debugPrint('Using fallback department ID: $currentDeptIds');
        }
      }
      
      // Ensure at least the manager's own department is selected by default
      if (currentDeptIds.isEmpty && widget.manager['department'] != null) {
        int deptId = widget.manager['department'] is int 
            ? widget.manager['department'] 
            : int.parse(widget.manager['department'].toString());
        if (departments.any((dept) => dept['id'] == deptId)) {
          currentDeptIds.add(deptId);
          debugPrint('Auto-selected manager\'s own department: $deptId');
        }
      }
      
      setState(() {
        _departments = departments;
        _selectedDepartmentIds = currentDeptIds;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      CommonToast.error('Error loading departments: $e', title: 'Loading Error');
    }
  }

  Future<void> _saveAssignments() async {
    if (_selectedDepartmentIds.isEmpty) {
      CommonToast.warning('Please select at least one department', title: 'Selection Required');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      Map<String, dynamic> response = await assignDepartmentsToManager(
        managerId: widget.manager['id'],
        departmentIds: _selectedDepartmentIds,
      );

      if (response['success'] == true) {
        CommonToast.success('Departments assigned successfully!');
        
        // Navigate back to parent screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.parentScreen),
          (Route<dynamic> route) => false,
        );
      } else {
        CommonToast.error(response['message'] ?? 'Failed to assign departments');
      }
    } catch (e) {
      CommonToast.error('Error: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _toggleDepartmentSelection(int departmentId) {
    setState(() {
      if (_selectedDepartmentIds.contains(departmentId)) {
        _selectedDepartmentIds.remove(departmentId);
      } else {
        _selectedDepartmentIds.add(departmentId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              'Assign Departments',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: _isLoading
                ? Center(
                    child: AnimatedDotsLoader(
                      text: 'Loading Departments...',
                      color: Theme.of(context).primaryColor,
                      size: 10.0,
                    ),
                  )
                : Column(
                    children: [
                      // Header section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.business,
                                color: Colors.blue.shade700,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.manager['name'] ?? 'Manager',
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${_selectedDepartmentIds.length} departments selected',
                                    style: TextStyle(
                                      color: Colors.blue.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if ((widget.manager['departments'] != null &&
                                          (widget.manager['departments'] as List).isNotEmpty) ||
                                      (widget.manager['assigned_departments'] != null &&
                                          widget.manager['assigned_departments']
                                              .toString()
                                              .isNotEmpty))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Currently assigned: ${widget.manager['departments'] != null ? (widget.manager['departments'] as List).map((d) => d['name']).join(', ') : widget.manager['assigned_departments']}',
                                        style: TextStyle(
                                          color: Colors.green.shade600,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Departments list
                      Expanded(
                        child: _departments.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.business_outlined,
                                      size: 60,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "No Departments Available",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "There are currently no departments in the system",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: _departments.length,
                                itemBuilder: (context, index) {
                                  final department = _departments[index];
                                  final isSelected = _selectedDepartmentIds
                                      .contains(department['id']);

                                  bool isAlreadyAssigned = false;
                                  if (widget.manager['departments'] != null) {
                                    isAlreadyAssigned = (widget.manager['departments']
                                            as List)
                                        .any((d) => d['id'] == department['id']);
                                  } else if (widget.manager['assigned_departments'] !=
                                      null) {
                                    isAlreadyAssigned = widget
                                        .manager['assigned_departments']
                                        .toString()
                                        .split(',')
                                        .map((e) => e.trim())
                                        .contains(department['name']);
                                  }

                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.blue.shade300
                                            : Colors.grey.shade200,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withValues(alpha: 0.1),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(16),
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.blue.withValues(alpha: 0.1)
                                              : Colors.grey.withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            isSelected
                                                ? Icons.check_circle
                                                : Icons.business,
                                            color: isSelected
                                                ? Colors.blue
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              department['name'] ?? 'Unnamed Department',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                          if (isSelected && isAlreadyAssigned)
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: Colors.green.shade300),
                                              ),
                                              child: Text(
                                                'Assigned',
                                                style: TextStyle(
                                                  color: Colors.green.shade700,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      subtitle: department['description'] != null
                                          ? Text(
                                              department['description'],
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          : null,
                                      trailing: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey.shade400,
                                            width: 2,
                                          ),
                                          color: isSelected
                                              ? Theme.of(context).primaryColor
                                              : Colors.transparent,
                                        ),
                                        child: isSelected
                                            ? Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      onTap: () {
                                        _toggleDepartmentSelection(department['id']);
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),

                      // Save button
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 16),
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : _saveAssignments,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: _isSaving 
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Icon(Icons.save, size: 20),
                          label: Text(
                            _isSaving 
                                ? 'Saving...' 
                                : 'Save Assignments (${_selectedDepartmentIds.length})',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
