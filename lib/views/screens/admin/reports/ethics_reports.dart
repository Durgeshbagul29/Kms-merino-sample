// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/admin/admin_functions.dart';
import 'package:kmsmerino/views/common/no_data_widget.dart';
import 'package:kmsmerino/views/base/padding_widget.dart';
import 'package:kmsmerino/views/common/report/report_status_card.dart';
import 'package:kmsmerino/views/common/report/report_card.dart';

class EthicsReport extends StatefulWidget {
  final int status;
  final String fromdate, todate;
  const EthicsReport(this.status, this.fromdate, this.todate, {super.key});

  @override
  State<EthicsReport> createState() => _EthicsReportState();
}

class _EthicsReportState extends State<EthicsReport>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    debugPrint("EthicsReport initState called");
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    super.initState();
    debugPrint("EthicsReport initState completed");
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
          "Ethics Reports",
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
              future: getEthicsReport(
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
                    // dynamic complaints = snapshot.data['complaints'];
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
                                                      downloadEthicsExcel(
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
                                            count:
                                                response['data']['total']
                                                    ?.toString() ??
                                                '0',
                                            icon: Icons.check_circle_outline,
                                            borderColor: Colors.blue.shade300,
                                          ),
                                          ReportStatusCard(
                                            title: "Pending",
                                            count:
                                                response['data']['pending']
                                                    ?.toString() ??
                                                '0',
                                            icon: Icons.pending,
                                            borderColor: Colors.orange.shade300,
                                          ),
                                          ReportStatusCard(
                                            title: "Seen",
                                            count:
                                                response['data']['seen']
                                                    ?.toString() ??
                                                '0',
                                            icon: Icons.visibility,
                                            borderColor: Colors.green.shade300,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 20),

                                    Expanded(
                                      child:
                                          response['data']['complaints'] !=
                                                  null &&
                                              response['data']['complaints']
                                                  .isNotEmpty
                                          ? ListView.builder(
                                              // separatorBuilder: (context,i) => Divider(color: Colors.black,),
                                              itemCount:
                                                  response['data']['complaints']
                                                      .length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                var complaints =
                                                    response['data']['complaints'];
                                                return ReportCard(
                                                  employeeName:
                                                      complaints[index]['empname'] ??
                                                      '',
                                                  id:
                                                      complaints[index]['complaint_id'] ??
                                                      '',
                                                  joiningDate:
                                                      complaints[index]['date'] ??
                                                      'N/A',
                                                  problem:
                                                      complaints[index]['complaint'] ??
                                                      'No complaint description',
                                                  status:
                                                      complaints[index]['status'] ==
                                                          0
                                                      ? 'Pending'
                                                      : 'Seen',
                                                  statusColor: _getStatusColor(
                                                    complaints[index]['status'] ==
                                                            0
                                                        ? 'Pending'
                                                        : 'Seen',
                                                  ),
                                                  onTap: () {
                                                    if (complaints[index]['status'] ==
                                                        0) {
                                                      reviewComplaintByAdmin(
                                                        context,
                                                        complaints[index]['id'],
                                                      );
                                                    } else {
                                                      // dialogBoxForSuccess(context,'Complaint Already Reviewed',EthicsReport(widget.status,widget.fromdate,widget.todate));
                                                    }
                                                  },
                                                );
                                              },
                                            )
                                          : NoDataWidget(
                                              title: 'No reports found',
                                              subtitle:
                                                  'No ethics complaints match your selected filters.',
                                              icon: Icons.gavel,
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
                                'Failed to load ethics reports',
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
                // return connectedToWifi != true ? checkConnectionWidget(context) : snapshot.data == false ? Login() : HomePage();
              },
            ),
          ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Pending') {
      return Colors.orange.shade300;
    } else if (status == 'Seen' || status == 'Implemented & Close') {
      return Colors.green.shade300;
    } else {
      return Colors.grey.shade300;
    }
  }
}
