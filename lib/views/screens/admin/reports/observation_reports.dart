// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/admin/admin_functions.dart';
import 'package:kmsmerino/views/screens/admin/observation/admin_obsdetails.dart';
import 'package:kmsmerino/views/common/no_data_widget.dart';
import 'package:kmsmerino/views/base/padding_widget.dart';
import 'package:kmsmerino/views/common/report/report_status_card.dart';
import 'package:kmsmerino/views/common/report/report_card.dart';

class ObservationReport extends StatefulWidget {
  // final String type;
  final int status;
  final String fromdate, todate;
  const ObservationReport(this.status, this.fromdate, this.todate, {super.key});

  @override
  State<ObservationReport> createState() => _ObservationReportState();
}

class _ObservationReportState extends State<ObservationReport>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    debugPrint("ObservationReport initState called");
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    super.initState();
    debugPrint("ObservationReport initState completed");
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
          "Observation Reports",
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
              future: getObservationReport(
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
                    // dynamic kaizens = snapshot.data['observation'];
                    dynamic response = snapshot.data;
                    return response['success'] == true
                        ? response['data'] != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(primary:Colors.blue[900],),
                                        //   child: Text('Excel Report',style: TextStyle(color: Colors.white, fontSize: 10),)),
                                        Stack(
                                          children: [
                                            Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withValues(alpha: 0.3),
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
                                                      BorderRadius.circular(
                                                        12.0,
                                                      ),
                                                  onTap: () {
                                                     downloadObservationExcel(
                                                       context,
                                                       widget.status,
                                                       widget.fromdate,
                                                       widget.todate,
                                                     );
                                                   },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          12.0,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
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
                                            count:
                                                response['data']['implemented']
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
                                      child: response['data']['observation'] != null && response['data']['observation'].isNotEmpty
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
                                            child: ListView.builder(
                                              itemCount:
                                                  response['data']['observation']
                                                      .length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                dynamic observations =
                                                    response['data']['observation'];
                                                return ReportCard(
                                                  employeeName:
                                                      observations[index]['empname'] ??
                                                      '',
                                                  id:
                                                      observations[index]['observation_id'] ??
                                                      '',
                                                  joiningDate:
                                                      observations[index]['sys_date'],
                                                  problem:
                                                      observations[index]['observation'],
                                                  status:
                                                      observations[index]['status'] ==
                                                          0
                                                      ? 'Pending'
                                                      : 'Implemented & Close',
                                                  statusColor: _getStatusColor(
                                                    observations[index]['status'] ==
                                                            0
                                                        ? 'Pending'
                                                        : 'Implemented & Close',
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminObservationDetails(
                                                              observations[index]['id'],
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
                                            subtitle: 'No Observation reports match your selected filters.',
                                            icon: Icons.visibility_outlined,
                                          ),
                                    ),
                                  ],
                                )
                              : NoDataWidget(
                                  title: 'No Data Available',
                                  subtitle: 'No Observation reports available for selected filters.',
                                  icon: Icons.history,
                                )
                        : NoDataWidget(
                            title: 'Loading Failed',
                            subtitle: response['message'] ?? 'Failed to load Observation reports',
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
                        'Loading Reports...',
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
