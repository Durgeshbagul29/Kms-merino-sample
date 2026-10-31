// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/admin/admin_functions.dart';
import 'package:kmsmerino/views/screens/admin/kaizens/admin_kaizendetails.dart';
import 'package:kmsmerino/views/common/no_data_widget.dart';
import 'package:kmsmerino/views/base/padding_widget.dart';
import 'package:kmsmerino/views/common/report/report_status_card.dart';
import 'package:kmsmerino/views/common/report/report_card.dart';

class KaizenReport extends StatefulWidget {
  // final String type;
  final int status;
  final String fromdate, todate;
  const KaizenReport(this.status, this.fromdate, this.todate, {super.key});

  @override
  State<KaizenReport> createState() => _KaizenReportState();
}

class _KaizenReportState extends State<KaizenReport>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    debugPrint("KaizenReport initState called");
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    super.initState();
    debugPrint("KaizenReport initState completed");
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
          "Kaizen Reports",
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
              future: getKaizenReport(
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
                    // dynamic kaizens = snapshot.data['kaizens'];
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
                                                      downloadKaizenExcel(
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
                                          ),
                                          ReportStatusCard(
                                            title: "Pending",
                                            count: response['data']['pending']
                                                .toString(),
                                            icon: Icons.pending,
                                            borderColor: Colors.amber.shade300,
                                          ),
                                          ReportStatusCard(
                                            title: "Not Start",
                                            count: response['data']['notstart']
                                                .toString(),
                                            icon: Icons.play_circle_outline,
                                            borderColor: Colors.grey.shade500,
                                          ),
                                          ReportStatusCard(
                                            title: "In Progress",
                                            count:
                                                response['data']['inprogress']
                                                    .toString(),
                                            icon: Icons.hourglass_empty,
                                            borderColor: Colors.purple.shade300,
                                          ),
                                          ReportStatusCard(
                                            title: "Rejected",
                                            count: response['data']['rejected']
                                                .toString(),
                                            icon: Icons.cancel,
                                            borderColor: Colors.red.shade300,
                                          ),
                                          ReportStatusCard(
                                            title: "Verified",
                                            count: response['data']['verified']
                                                .toString(),
                                            icon: Icons.verified,
                                            borderColor: Colors.green.shade300,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Expanded(
                                      child: response['data']['kaizens'] != null && response['data']['kaizens'].isNotEmpty
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
                                            child: ListView.builder(
                                              itemCount: response['data']['kaizens']
                                                  .length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                dynamic kaizens =
                                                    response['data']['kaizens'] ??
                                                    '';
                                                return ReportCard(
                                                  employeeName:
                                                      kaizens[index]['Employee Name'] ??
                                                      '',
                                                  id: kaizens[index]['Kaizen ID'],
                                                  joiningDate:
                                                      kaizens[index]['Joining Date'],
                                                  problem:
                                                      kaizens[index]['Problem'],
                                                  status: kaizens[index]['Status'],
                                                  statusColor: _getStatusColor(
                                                    kaizens[index]['Status'],
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminKaizenDetails(
                                                              kaizens[index]['Id'],
                                                              KaizenReport(
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
                                            ),
                                          )
                                        : NoDataWidget(
                                            title: 'No reports found',
                                            subtitle: 'No Kaizen reports match your selected filters.',
                                            icon: Icons.lightbulb_outline,
                                          ),
                                    ),
                                  ],
                                )
                              : NoDataWidget(
                                  title: 'No Data Available',
                                  subtitle: 'No Kaizen reports available for selected filters.',
                                  icon: Icons.bar_chart,
                                )
                        : NoDataWidget(
                            title: 'Loading Failed',
                            subtitle: response['message'] ?? 'Failed to load Kaizen reports',
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
}
