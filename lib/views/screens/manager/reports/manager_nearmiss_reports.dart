// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/manager/manager_functions.dart';
import 'package:kmsmerino/views/common/no_data_widget.dart';
import 'package:kmsmerino/views/base/padding_widget.dart';
import 'package:kmsmerino/views/common/report/report_status_card.dart';
import 'package:kmsmerino/views/common/report/report_card.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';

import '../nearmiss/manager_nearmissdetails.dart';

class ManagerNearmissReport extends StatefulWidget {
  final int status;
  final String fromdate, todate;
  const ManagerNearmissReport(
    this.status,
    this.fromdate,
    this.todate, {
    super.key,
  });

  @override
  State<ManagerNearmissReport> createState() => _ManagerNearmissReportState();
}

class _ManagerNearmissReportState extends State<ManagerNearmissReport>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    debugPrint("ManagerNearmissReport initState called");
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    super.initState();
    debugPrint("ManagerNearmissReport initState completed");
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
        child: dashboardWidget(),
    );
  }

  Widget dashboardWidget() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Manager Nearmiss Reports",
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
      ),
      body: PaddingWidget(
        FutureBuilder<dynamic>(
          future: _getManagerNearmissReport(
            context,
            widget.status,
            widget.fromdate,
            widget.todate,
          ),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                return NoDataWidget(
                  title: 'Loading Failed',
                  subtitle: snapshot.error.toString(),
                  icon: Icons.error_outline,
                );
              } else if (snapshot.hasData) {
                dynamic response = snapshot.data;
                return response['success'] == true
                    ? response['data'] != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              12.0,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withValues(alpha: 0.3,
                                                ),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              onTap: () {
                                                _downloadNearmissExcel(
                                                  context,
                                                  widget.status,
                                                  widget.fromdate,
                                                  widget.todate,
                                                );
                                              },
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 12.0,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.download,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          "Download Excel Report",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Spacer(),
                                    // Container(
                                    //   height: 45,
                                    //   decoration: BoxDecoration(
                                    //     color: Theme.of(
                                    //       context,
                                    //     ).primaryColor,
                                    //     borderRadius: BorderRadius.circular(
                                    //       12.0,
                                    //     ),
                                    //     boxShadow: [
                                    //       BoxShadow(
                                    //         color: Colors.grey.withValues(alpha: //           0.3,
                                    //         ),
                                    //         spreadRadius: 1,
                                    //         blurRadius: 5,
                                    //         offset: Offset(0, 2),
                                    //       ),
                                    //     ],
                                    //   ),
                                    //   child: Material(
                                    //     color: Colors.transparent,
                                    //     child: InkWell(
                                    //       borderRadius:
                                    //           BorderRadius.circular(12.0),
                                    //       onTap: () {
                                    //         Navigator.push(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 NearmissArchieve(),
                                    //           ),
                                    //         );
                                    //       },
                                    //       child: Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.center,
                                    //         children: const [
                                    //           Padding(
                                    //             padding:
                                    //                 EdgeInsets.symmetric(
                                    //                   horizontal: 12.0,
                                    //                 ),
                                    //             child: Text(
                                    //               "All Archive",
                                    //               style: TextStyle(
                                    //                 color: Colors.white,
                                    //                 fontWeight:
                                    //                     FontWeight.w500,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),

                                SizedBox(height: 20),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      ReportStatusCard(
                                        title: "Total",
                                        count:
                                            response['data']['total']
                                                ?.toString() ??
                                            '0',
                                        icon: Icons.check_circle_outline,
                                        borderColor: Colors.blue.shade300,
                                        boxHeight: 120,
                                      ),
                                      ReportStatusCard(
                                        title: "Pending",
                                        count:
                                            response['data']['pending']
                                                ?.toString() ??
                                            '0',
                                        icon: Icons.pending,
                                        borderColor: Colors.orange.shade300,
                                        boxHeight: 120,
                                      ),
                                      ReportStatusCard(
                                        title: "Implemented & Close",
                                        count:
                                            response['data']['implemented']
                                                ?.toString() ??
                                            '0',
                                        icon: Icons.verified,
                                        borderColor: Colors.green.shade300,
                                        boxHeight: 120,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                  child:
                                      response['data']['nearmiss'] != null &&
                                          response['data']['nearmiss']
                                              .isNotEmpty
                                      ? ListView.builder(
                                          itemCount:
                                              response['data']['nearmiss']
                                                  .length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            dynamic nearmisses =
                                                response['data']['nearmiss'];
                                            return ReportCard(
                                              employeeName:
                                                  nearmisses[index]['empname'] ??
                                                  '',
                                              id: nearmisses[index]['nearmiss_id'],
                                              joiningDate:
                                                  nearmisses[index]['sys_date'],
                                              problem:
                                                  nearmisses[index]['incident'],
                                              status:
                                                  nearmisses[index]['status'] ==
                                                      0
                                                  ? 'Pending'
                                                  : 'Implemented & Close',
                                              statusColor: _getStatusColor(
                                                nearmisses[index]['status'] == 0
                                                    ? 'Pending'
                                                    : 'Implemented & Close',
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ManagerNearmissDetails(
                                                          nearmisses[index]['id'],
                                                        ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        )
                                      : NoDataWidget(
                                          title: 'No reports found',
                                          subtitle:
                                              'No Nearmiss reports match your selected filters.',
                                          icon: Icons.warning_amber_rounded,
                                        ),
                                ),
                              ],
                            )
                          : NoDataWidget(
                              title: 'No Data Available',
                              subtitle:
                                  'There are no reports available for the selected criteria.',
                              icon: Icons.analytics_outlined,
                            )
                    : NoDataWidget(
                        title: 'Loading Failed',
                        subtitle:
                            response['message'] ??
                            'Failed to load nearmiss reports',
                        icon: Icons.error_outline,
                      );
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Loading Reports...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading Reports...\nPlease wait',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Pending') {
      return Colors.orange.shade300;
    } else if (status == 'Implemented & Close') {
      return Colors.green.shade300;
    } else if (status == 'Open') {
      return Colors.red.shade300;
    } else {
      return Colors.grey.shade300;
    }
  }

  // Helper methods to call manager-specific functions
  Future<dynamic> _getManagerNearmissReport(
    BuildContext context,
    int status,
    String fromdate,
    String todate,
  ) async {
    final managerId = await getLoggedInUserId(); // Get manager ID
    return await getNearmissReport(
      context,
      status,
      fromdate,
      todate,
      managerId,
    );
  }

  Future<void> _downloadNearmissExcel(
    BuildContext context,
    int status,
    String fromdate,
    String todate,
  ) async {
    final managerId = await getLoggedInUserId(); // Get manager ID
    await downloadNearmissExcel(context, status, fromdate, todate, managerId);
  }

  Future<int> getLoggedInUserId() async {
    // Get the actual logged in user ID
    return await LoggedInUser.getUserId();
  }
}
