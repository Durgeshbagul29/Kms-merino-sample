// ignore_for_file: prefer_const_constructors, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmsmerino/views/screens/manager/reports/manager_accident_reports.dart';
import 'package:kmsmerino/views/screens/manager/reports/manager_ethics_reports.dart';
import 'package:kmsmerino/views/screens/manager/reports/manager_kaizen_reports.dart';
import 'package:kmsmerino/views/screens/manager/reports/manager_nearmiss_reports.dart';
import 'package:kmsmerino/views/screens/manager/reports/manager_observation_reports.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:kmsmerino/helper/network_connectivity_manager.dart';


class ManagerReportForm extends StatefulWidget {
  final String type;
  const ManagerReportForm(this.type, {super.key});

  @override
  State<ManagerReportForm> createState() => _ManagerReportFormState();
}

class _ManagerReportFormState extends State<ManagerReportForm>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String statusStr = "All";
  // int status = 0;
  List<String> ethicsList = ['All', 'Pending', 'Seen'];
  List<String> safetyList = ['All', 'Pending', 'Implement & Close'];
  List<String> kaizenList = [
    'All',
    'Pending',
    'Rejected',
    'Approved',
    'Verified',
  ];
  DateTime startDate = DateTime.now(), endDate = DateTime.now();
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    // _dropDownMenuItems = getDropDownMenuItems();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: Scaffold(
        backgroundColor: Color(0xFFEFF3F9),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            '${widget.type} Report',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(color: Color(0xFFEFF3F9)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Header section with title and description
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.picture_as_pdf,
                                color: Colors.blue.shade700,
                                size: 28,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Generate ${widget.type} Report',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Select the filters below to generate your report',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Main form section
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Status Dropdown
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        SizedBox(height: 10.0),

                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: statusStr == 'All'
                                  ? Colors.grey.shade400
                                  : Colors.blue.shade700,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: statusStr,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.blue.shade700,
                                  size: 28,
                                ),
                                iconSize: 24,
                                elevation: 4,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                                underline: Container(),
                                onChanged: (val) {
                                  setState(() {
                                    statusStr = val.toString();
                                  });
                                },
                                items: _getStatusList().map((String cname) {
                                  return DropdownMenuItem<String>(
                                    value: cname,
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getStatusIcon(cname),
                                          color: _getStatusColor(cname),
                                          size: 20,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          cname,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30.0),

                        // Date Pickers Section
                        Text(
                          'Date Range',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        SizedBox(height: 15.0),

                        // From Date
                        _buildDatePicker(
                          label: 'From Date',
                          date: startDate,
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null && picked != startDate) {
                              setState(() {
                                startDate = picked;
                                // Ensure end date is not before start date
                                if (endDate.isBefore(startDate)) {
                                  endDate = startDate;
                                }
                              });
                            }
                          },
                        ),

                        SizedBox(height: 20.0),

                        // To Date
                        _buildDatePicker(
                          label: 'To Date',
                          date: endDate,
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: startDate,
                              lastDate: DateTime.now(),
                            );
                            if (picked != null && picked != endDate) {
                              // Check if the date range exceeds 1 year
                              DateTime oneYearAfterStart = DateTime(startDate.year + 1, startDate.month, startDate.day);
                              if (picked.isAfter(oneYearAfterStart)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select a date range within 1 year'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                                return;
                              }
                              setState(() {
                                endDate = picked;
                              });
                            }
                          },
                        ),

                        SizedBox(height: 20),

                        // Submit Button
                        Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade700,
                                Colors.blue.shade900,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.3),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Validate date range
                                Duration difference = endDate.difference(startDate);
                                int daysDifference = difference.inDays;
                                
                                if (daysDifference > 365) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please select a date range within 1 year'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  return;
                                }
                                
                                if (endDate.isBefore(startDate)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('End date cannot be before start date'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  return;
                                }
                                
                                // Check network connectivity before proceeding
                                final networkManager = NetworkManager.instance;
                                final isConnected = await networkManager.checkConnectivityAndShowError();

                                if (!isConnected) {
                                  return; // Don't proceed with report generation if offline
                                }
                                
                                _handleSubmit();
                              } else {
                                dialogBoxForFailure(
                                  context,
                                  'Please fill valid details',
                                  '',
                                );
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Generate Report',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getStatusList() {
    if (widget.type == 'Accident' ||
        widget.type == 'Nearmiss' ||
        widget.type == 'Observation') {
      return safetyList;
    } else if (widget.type == 'Kaizen') {
      return kaizenList;
    } else {
      return ethicsList;
    }
  }

  IconData _getStatusIcon(String status) {
    if (status == 'All') {
      return Icons.view_list;
    } else if (status == 'Pending') {
      return Icons.pending_actions;
    } else if (status == 'Seen' ||
        status == 'Approved' ||
        status == 'Verified') {
      return Icons.check_circle;
    } else if (status == 'Rejected') {
      return Icons.cancel;
    } else if (status == 'Implement & Close') {
      return Icons.done_all;
    } else {
      return Icons.list_alt;
    }
  }

  Color _getStatusColor(String status) {
    if (status == 'All') {
      return Colors.grey.shade600;
    } else if (status == 'Pending') {
      return Colors.orange.shade600;
    } else if (status == 'Seen' ||
        status == 'Approved' ||
        status == 'Verified') {
      return Colors.green.shade600;
    } else if (status == 'Rejected') {
      return Colors.red.shade600;
    } else if (status == 'Implement & Close') {
      return Colors.blue.shade600;
    } else {
      return Colors.grey.shade600;
    }
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime date,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Text(
                  DateFormat.yMMMd().format(date),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (widget.type == 'Accident') {
      int status = 0;
      if (statusStr == 'Pending') {
        status = 0;
      } else if (statusStr == 'Implement & Close') {
        status = 1;
      } else {
        status = 2;
      }

      String fromdate = DateFormat("yyyy-MM-dd").format(startDate);
      String todate = DateFormat("yyyy-MM-dd").format(endDate);
      debugPrint(status.toString());
      debugPrint(fromdate);
      debugPrint(todate);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManagerAccidentReport(status, fromdate, todate),
        ),
      );
    } else if (widget.type == 'Nearmiss') {
      int status = 0;
      if (statusStr == 'Pending') {
        status = 0;
      } else if (statusStr == 'Implement & Close') {
        status = 1;
      } else {
        status = 2;
      }
      debugPrint(status.toString());
      String fromdate = DateFormat("yyyy-MM-dd").format(startDate);
      String todate = DateFormat("yyyy-MM-dd").format(endDate);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManagerNearmissReport(status, fromdate, todate),
        ),
      );
    } else if (widget.type == 'Observation') {
      int status = 0;
      if (statusStr == 'Pending') {
        status = 0;
      } else if (statusStr == 'Implement & Close') {
        status = 1;
      } else {
        status = 2;
      }
      debugPrint(status.toString());
      String fromdate = DateFormat("yyyy-MM-dd").format(startDate);
      String todate = DateFormat("yyyy-MM-dd").format(endDate);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManagerObservationReport(status, fromdate, todate),
        ),
      );
    } else if (widget.type == 'Kaizen') {
      int status = 0;
      if (statusStr == 'Pending') {
        status = 0;
      } else if (statusStr == 'Approved') {
        status = 1;
      } else if (statusStr == 'Rejected') {
        status = 2;
      } else if (statusStr == 'Verified') {
        status = 3;
      } else if (statusStr == 'All') {
        status = 4;
      }
      debugPrint(status.toString());
      String fromdate = DateFormat("yyyy-MM-dd").format(startDate);
      String todate = DateFormat("yyyy-MM-dd").format(endDate);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManagerKaizenReport(status, fromdate, todate),
        ),
      );
    } else if (widget.type == 'Ethics') {
      int status = 0;
      if (statusStr == 'Pending') {
        status = 0;
      } else if (statusStr == 'Seen') {
        status = 1;
      } else {
        status = 2;
      }
      debugPrint(status.toString());
      String fromdate = DateFormat("yyyy-MM-dd").format(startDate);
      String todate = DateFormat("yyyy-MM-dd").format(endDate);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManagerEthicsReport(status, fromdate, todate),
        ),
      );
    }
  }
}
