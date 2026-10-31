// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/manager/manager_functions.dart';
import 'package:kmsmerino/views/common/no_data_widget.dart';
import 'package:kmsmerino/views/base/padding_widget.dart';
import 'package:kmsmerino/views/common/report/report_status_card.dart';
import 'package:kmsmerino/views/common/report/report_card.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';

import '../kaizen/manager_kaizendetails.dart';

class ManagerKaizenReport extends StatefulWidget {
  final int status;
  final String fromdate, todate;
  const ManagerKaizenReport(this.status, this.fromdate, this.todate, {super.key});

  @override
  State<ManagerKaizenReport> createState() => _ManagerKaizenReportState();
}

class _ManagerKaizenReportState extends State<ManagerKaizenReport>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    debugPrint("ManagerKaizenReport initState called");
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    super.initState();
    debugPrint("ManagerKaizenReport initState completed");
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
          "Manager Kaizen Reports",
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
      body:
          // SingleChildScrollView(
          // child:Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          //   decoration: BoxDecoration(color: Colors.white),
          // child:
          PaddingWidget(
            FutureBuilder<dynamic>(
              future: _getManagerKaizenReport(
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
                    bool success = response['success'] ?? false;
                    bool hasData = response['data'] != null;

                    if (!success) {
                      return NoDataWidget(
                        title: 'Loading Failed',
                        subtitle:
                            response['message'] ?? 'Failed to load reports',
                        icon: Icons.error_outline,
                      );
                    }

                    if (!hasData) {
                      return NoDataWidget(
                        title: 'No Data Available',
                        subtitle:
                            'There are no reports available for the selected criteria.',
                        icon: Icons.analytics_outlined,
                      );
                    }

                    return Column(
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
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withValues(alpha: 0.3),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12.0),
                                      onTap: () {
                                         _downloadKaizenExcel(
                                           context,
                                           widget.status,
                                           widget.fromdate,
                                           widget.todate,
                                         );
                                       },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
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
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                count: response['data']['total'].toString(),
                                icon: Icons.check_circle_outline,
                                borderColor: Colors.blue.shade300,
                              ),
                              ReportStatusCard(
                                title: "Pending",
                                count: response['data']['pending'].toString(),
                                icon: Icons.pending,
                                borderColor: Colors.amber.shade300,
                              ),
                              ReportStatusCard(
                                title: "Not Start",
                                count: response['data']['notstart'].toString(),
                                icon: Icons.play_circle_outline,
                                borderColor: Colors.grey.shade500,
                              ),
                              ReportStatusCard(
                                title: "In Progress",
                                count: response['data']['inprogress']
                                    .toString(),
                                icon: Icons.hourglass_empty,
                                borderColor: Colors.purple.shade300,
                              ),
                              ReportStatusCard(
                                title: "Rejected",
                                count: response['data']['rejected'].toString(),
                                icon: Icons.cancel,
                                borderColor: Colors.red.shade300,
                              ),
                              ReportStatusCard(
                                title: "Verified",
                                count: response['data']['verified'].toString(),
                                icon: Icons.verified,
                                borderColor: Colors.green.shade300,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child:
                              response['data']['kaizens'] != null &&
                                  response['data']['kaizens'].isNotEmpty
                              ? ListView.builder(
                                  itemCount: response['data']['kaizens'].length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    dynamic kaizens =
                                        response['data']['kaizens'];
                                    return ReportCard(
                                      employeeName:
                                          kaizens[index]['Employee Name'],
                                      id: kaizens[index]['Kaizen ID'],
                                      joiningDate:
                                          kaizens[index]['Joining Date'],
                                      problem: kaizens[index]['Problem'],
                                      status: kaizens[index]['Status'],
                                      statusColor: _getStatusColor(
                                        kaizens[index]['Status'],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ManagerKaizenDetails(
                                                  kaizens[index]['Id'],
                                                  ManagerKaizenReport(
                                                    widget.status,
                                                    widget.fromdate,
                                                    widget.todate,
                                                  ),
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
                                      'No Kaizens match your selected filters.',
                                  icon: Icons.lightbulb_outline,
                                ),
                        ),
                      ],
                    );
                  }
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
                        snapshot.connectionState == ConnectionState.waiting
                            ? 'Loading Reports...\nPlease wait'
                            : 'Loading Reports...',
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
    } else if (status == 'Approved (Not Start)') {
      return Colors.blue.shade300;
    } else if (status == 'Approved (In Progess)') {
      return Colors.blue.shade600;
    } else if (status == 'Rejected') {
      return Colors.red.shade300;
    } else if (status == 'Verified') {
      return Colors.green.shade300;
    } else {
      return Colors.grey.shade300;
    }
  }

  // Helper methods to call manager-specific functions
  Future<dynamic> _getManagerKaizenReport(
    BuildContext context,
    int status,
    String fromdate,
    String todate,
  ) async {
    return await getKaizenReport(context, status, fromdate, todate);
  }

  Future<void> _downloadKaizenExcel(
    BuildContext context,
    int status,
    String fromdate,
    String todate,
  ) async {
    final managerId = await getLoggedInUserId(); // Get manager ID
    await downloadKaizenExcel(context, status, fromdate, todate, managerId);
  }

  Future<int> getLoggedInUserId() async {
    // Get the actual logged in user ID
    return await LoggedInUser.getUserId();
  }
}
