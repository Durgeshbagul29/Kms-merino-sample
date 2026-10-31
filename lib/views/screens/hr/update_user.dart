// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:kmsmerino/views/screens/hr/hr_functions.dart';

class UpdateUser extends StatefulWidget {
  final Map userdata;
  final Widget filename;
  const UpdateUser(this.userdata, this.filename, {super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  String username = '', empname = '', email = '', dept = '', mobile = '',
      status = 'Active', type = 'User';
  int groupG = 1;
  int selectedDeptId = 0; // Store selected department ID
  bool _isDeptLoading = true;
  List<Map<String, dynamic>> departments = []; // Store departments from API
  List<String> deptNames = [
    'Select Department',
  ]; // Store department names for dropdown

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animationController.forward();
    if (widget.userdata['status'] == 1) {
      status = 'Active';
      groupG = 1;
    } else {
      status = 'Deactive';
      groupG = 2;
    }
    dept = widget.userdata['deptname'] ?? 'Select Department';
    type = widget.userdata['user_role_id'] == 1 ? 'Admin' : 'User';
    super.initState();
    _loadDepartments();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Future<String> getDepts() async {
  //   final token = await LoggedInUser.getToken();
  //   final response= await get(
  //     Uri.parse("${ApiConfig.baseUrl}/api/get_depts"),
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json",
  //       'Authorization' : 'Bearer '+token,
  //     },
  //   );
  //   var responsebody = json.decode(response.body);

  //   setState(() {
  //     // deptList.add('Select Department');
  //     deptList = responsebody['data'];
  //     dept = widget.userdata['dept'] ?? responsebody['data'][0]['name'];
  //     // responsebody['data'].forEach((element) {
  //     //   deptList.add(element['name']);
  //     // });
  //   });

  //   debugPrint(responsebody['data']);
  //   return "Sucess";
  // }

  Future<void> _loadDepartments() async {
    try {
      setState(() {
        _isDeptLoading = true;
      });
  
      List<Map<String, dynamic>> depts = await getAllDepartments();
      setState(() {
        departments = depts;
        deptNames = ['Select Department'];
        for (var dept in departments) {
          deptNames.add(dept['name']);
        }
        // Set initial department value if it exists in the loaded departments
        if (widget.userdata['deptname'] != null) {
          // Check if the department from userdata exists in our loaded departments
          int matchedIndex = departments.indexWhere(
            (d) => d['name'] == widget.userdata['deptname'],
          );
          if (matchedIndex != -1) {
            // Department exists in the loaded list
            dept = departments[matchedIndex]['name'];
            selectedDeptId = departments[matchedIndex]['id'];
          } else {
            // Department doesn't exist in loaded list, but we should still show it
            // Add it to the deptNames list temporarily so it displays
            dept = widget.userdata['deptname'];
            if (!deptNames.contains(dept)) {
              deptNames.add(dept);
            }
            selectedDeptId = 0; // Since it's not in our loaded departments
          }
        }
        _isDeptLoading = false;
      });
    } catch (e) {
      setState(() {
        _isDeptLoading = false;
      });
      debugPrint('Error loading departments: $e');
    }
  }
  
  void changedDropDownItem(String? selectedValue) {
    setState(() {
      dept = selectedValue!;
      
      // Find the corresponding department ID
      if (selectedValue != 'Select Department') {
        int selectedIndex = departments.indexWhere(
          (d) => d['name'] == selectedValue,
        );
        if (selectedIndex != -1) {
          selectedDeptId = departments[selectedIndex]['id'];
        }
      } else {
        selectedDeptId = 0;
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
            title: Text(type == 'Admin' ? 'Update Admin Details' : 'Update User Details',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.white)),
            // Fixed back button - pop instead of push
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context)),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          type == 'Admin' ? 'Update Admin' : 'Update User',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          type == 'Admin' ? 'Modify admin information below' : 'Modify user information below',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Status Selection with Tab Design
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        // Tab-like selection for status with smooth transitions
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double containerWidth = constraints.maxWidth;
                              double tabWidth = (containerWidth - 8) / 2; // Subtract padding and divide by 2
                              return Stack(
                                children: [
                                  // Animated container for the selected tab indicator
                                  AnimatedPositioned(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    top: 4,
                                    left: (groupG == 1) ? 4 : tabWidth + 4,
                                    width: tabWidth,
                                    height: 42,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              groupG = 1;
                                              status = 'Active';
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: AnimatedDefaultTextStyle(
                                                duration: Duration(milliseconds: 200),
                                                curve: Curves.easeInOut,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: groupG == 1
                                                      ? Colors.white
                                                      : Colors.grey[700],
                                                ),
                                                child: Text(
                                                  'Active',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              groupG = 2;
                                              status = 'Deactive';
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: AnimatedDefaultTextStyle(
                                                duration: Duration(milliseconds: 200),
                                                curve: Curves.easeInOut,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: groupG == 2
                                                      ? Colors.white
                                                      : Colors.grey[700],
                                                ),
                                                child: Text(
                                                  'Inactive',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Form Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username Field
                          Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                RegExp nameRegex = RegExp(r'^[a-zA-Z0-9]*$');
                                if (value!.isEmpty) {
                                  return "Username can't be empty.";
                                } else if (value.length < 2) {
                                  return "Username must be more than one character.";
                                } else if (!nameRegex.hasMatch(value)) {
                                  return "Please Enter Characters and Numbers Only";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Icon(Icons.person,
                                      color: Theme.of(context).primaryColor),
                                ),
                                hintText: 'Enter username',
                                hintStyle: TextStyle(
                                    color: Colors.grey[400], fontSize: 15),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red.shade300, width: 2),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red.shade300, width: 2),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  username = val;
                                });
                              },
                              initialValue: widget.userdata['username'],
                            ),
                          ),
                          SizedBox(height: 20),
        
                          // Employee Name Field
                          Text(
                            'Employee Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                RegExp nameRegex = RegExp(r'^[a-zA-Z ]*$');
                                if (value!.isEmpty) {
                                  return "Employee Name can't be empty.";
                                } else if (value.length < 2) {
                                  return "Employee must be more than one character.";
                                } else if (!nameRegex.hasMatch(value)) {
                                  return "Please Enter Characters Only";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Icon(Icons.badge,
                                      color: Theme.of(context).primaryColor),
                                ),
                                hintText: 'Enter employee name',
                                hintStyle: TextStyle(
                                    color: Colors.grey[400], fontSize: 15),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red.shade300, width: 2),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red.shade300, width: 2),
                                ),
                              ),
                              initialValue: widget.userdata['name'],
                              onChanged: (val) {
                                setState(() {
                                  empname = val;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 20),
        
                          // Mobile Number Field
                          Text(
                            'Mobile Number',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isNotEmpty && value.length != 10) {
                                  return "Mobile number must have 10 digits.";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                hintText: 'Enter mobile number',
                                hintStyle: TextStyle(
                                    color: Colors.grey[400], fontSize: 15),
                                filled: true,
                                fillColor: Colors.grey[50],
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Icon(Icons.call,
                                      color: Theme.of(context).primaryColor),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red.shade300, width: 2),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red.shade300, width: 2),
                                ),
                              ),
                              initialValue: widget.userdata['mobile'],
                              onChanged: (val) {
                                setState(() {
                                  mobile = val;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 20),
        
                          // Email Field
                          Text(
                            'Email Address',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                RegExp regex = RegExp(
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                                if (value!.isNotEmpty &&
                                    !regex.hasMatch(value)) {
                                  return "Please Enter Valid Email";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                hintText: 'Enter email address',
                                hintStyle: TextStyle(
                                    color: Colors.grey[400], fontSize: 15),
                                filled: true,
                                fillColor: Colors.grey[50],
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Icon(Icons.email,
                                      color: Theme.of(context).primaryColor),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red.shade300, width: 2),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red.shade300, width: 2),
                                ),
                              ),
                              initialValue: widget.userdata['email'],
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 20),
        
                          // Department Dropdown with API integration
                          Text(
                            'Department*',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          
                          _isDeptLoading
                              ? Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.blue.shade200),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text("Loading departments..."),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 56,
                                  padding: EdgeInsets.only(top: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: Colors.grey[50],
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButtonFormField<String>(
                                        validator: (value) {
                                          if (value == null || value.isEmpty || value == 'Select Department') {
                                            return 'Please select a department';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          hintText: 'Select Department',
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400], fontSize: 15),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.red.shade300, width: 2),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.red.shade300, width: 2),
                                          ),
                                        ),
                                        isExpanded: true,
                                        style: TextStyle(
                                            color: Colors.black87, fontSize: 15),
                                        initialValue: dept,
                                        isDense: true,
                                        onChanged: changedDropDownItem,
                                        items: deptNames.map((item) {
                                          return DropdownMenuItem(
                                            value: item.toString(),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 16),
                                              child: Text(item,
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 15)),
                                            ),
                                          );
                                        }).toList(),
                                        icon: Padding(
                                          padding: EdgeInsets.only(right: 16),
                                          child: Icon(Icons.arrow_drop_down,
                                              color: Theme.of(context).primaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 30),
        
                          // Update Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Additional validation for department since DropdownButtonFormField might not catch all cases
                                  if (dept == 'Select Department' || dept.isEmpty) {
                                    CustomLoader.hide();
                                    dialogBoxForFailure(context,
                                        'Please select a department',
                                        'Department is required');
                                    return;
                                  }
                                  
                                  CustomLoader.show(context,
                                      progressIndicator: CircularProgressIndicator(
                                          backgroundColor:
                                              Theme.of(context).primaryColor),
                                      loaderText: Text(
                                        "\nUpdating Details...",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            decoration: TextDecoration.none),
                                        textAlign: TextAlign.center,
                                      ));
                                  debugPrint("in change_password function");
                                  // login(username,password);
        
                                  final token =
                                      await LoggedInUser.getToken();
                                  // final adminid = await LoggedInUser.getUserId();
        
                                  final response = await post(
                                    Uri.parse(
                                        "${ApiConfig.baseUrl}/api/update_useroradmin"),
                                    headers: {
                                      "Accept": "application/json",
                                      'Content-Type': 'application/json',
                                      'Authorization': 'Bearer $token',
                                    },
                                    body: json.encode({
                                      'userid': widget.userdata['id'],
                                      'status': status,
                                      'username': username.isEmpty
                                          ? widget.userdata['username']
                                          : username,
                                      'empname': empname.isEmpty
                                          ? widget.userdata['name']
                                          : empname,
                                      'mobile': mobile.isEmpty
                                          ? widget.userdata['mobile']
                                          : mobile,
                                      'email': email.isEmpty
                                          ? widget.userdata['email']
                                          : email,
                                      'department_id': selectedDeptId == 0
                                          ? ''
                                          : selectedDeptId.toString(),
                                    }),
                                    // encoding: Encoding.getByName("utf-8")
                                  );
                                  debugPrint(response.body.toString());
        
                                  var responsebody = json.decode(response.body);
                                  // var responsebody = response.body;
                                  debugPrint("\n Response from api:\n$responsebody");
                                  if (responsebody['success'] == true) {
                                    CustomLoader.hide();
                                    dialogBoxForSuccess(context,
                                        '$type Updated Successfully',
                                        widget.filename);
                                    debugPrint("password changed");
                                  } else {
                                    CustomLoader.hide();
                                    dialogBoxForFailure(context,
                                        'Something Went Wrong',
                                        'Data Not Updated');
                                    debugPrint("password not changed");
                                  }
                                } else {
                                  CustomLoader.hide();
                                  // dialogBoxForFailure(context,'Please fill valid details','');
                                }
                              },
                              child: Text(
                                type == 'Admin' ? 'Update Admin' : 'Update User',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
