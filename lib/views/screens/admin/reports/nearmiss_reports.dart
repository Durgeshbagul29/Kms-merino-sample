// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/admin/admin_functions.dart';
import 'package:kmsmerino/views/screens/admin/nearmiss/admin_nearmissdetails.dart';
import 'package:kmsmerino/views/common/no_data_widget.dart';
import 'package:kmsmerino/views/base/padding_widget.dart';
import 'package:kmsmerino/views/common/report/report_status_card.dart';
import 'package:kmsmerino/views/common/report/report_card.dart';

class NearmissReport extends StatefulWidget {
  // final String type;
  final int status;
  final String fromdate, todate;
  const NearmissReport(this.status, this.fromdate, this.todate, {super.key});

  @override
  State<NearmissReport> createState() => _NearmissReportState();
}

class _NearmissReportState extends State<NearmissReport>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    debugPrint("NearmissReport initState called");
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    super.initState();
    debugPrint("NearmissReport initState completed");
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
          "Nearmiss Reports",
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
          future: getNearmissReport(
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
                // dynamic kaizens = snapshot.data['nearmiss'];
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
                                                  downloadNearmissExcel(
                                                    context,
                                                    widget.status,
                                                    widget.fromdate,
                                                    widget.todate,
                                                  );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  12.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.download,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      "Download Excel Report",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
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
                                        count: response['data']['total']
                                            .toString(),
                                        icon: Icons.check_circle_outline,
                                        borderColor: Colors.blue.shade300,
                                        boxHeight: 120,
                                      ),
                                      ReportStatusCard(
                                        title: "Pending",
                                        count: response['data']['pending']
                                            .toString(),
                                        icon: Icons.pending,
                                        borderColor: Colors.orange.shade300,
                                        boxHeight: 120,
                                      ),
                                      ReportStatusCard(
                                        title: "Implemented & Close",
                                        count: response['data']['implemented']
                                            .toString(),
                                        icon: Icons.verified,
                                        borderColor: Colors.green.shade300,
                                        boxHeight: 120,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 20),

                                Expanded(
                                  child: response['data']['nearmiss'] != null && response['data']['nearmiss'].isNotEmpty
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: ListView.builder(
                                          itemCount:
                                              response['data']['nearmiss'].length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            dynamic nearmisses =
                                                response['data']['nearmiss'] ?? '';
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
                                                  nearmisses[index]['status'] == 0
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
                                                        AdminNearmissDetails(
                                                          nearmisses[index]['id'],
                                                        ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    : NoDataWidget(
                                        title: 'No reports found',
                                        subtitle: 'No Nearmiss reports match your criteria.',
                                        icon: Icons.warning_amber_rounded,
                                      ),
                                ),
                              ],
                            )
                          : NoDataWidget(
                              title: 'No Data Available',
                              subtitle: 'No Nearmiss reports available for selected filters.',
                              icon: Icons.history,
                            )
                    : NoDataWidget(
                        title: 'Loading Failed',
                        subtitle: response['message'] ?? 'Failed to load Nearmiss reports',
                        icon: Icons.error_outline,
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
    } else {
      return Colors.grey.shade300;
    }
  }
}
