// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/director/director_functions.dart';
import 'package:kmsmerino/views/screens/director/kaizen/director_kaizendetails.dart';
import 'package:kmsmerino/views/base/animated_dots_loader.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/common/kaizen/kaizen_card.dart';
import 'package:kmsmerino/views/common/no_data_widget.dart';

class DirectorAllKaizens extends StatefulWidget {
  const DirectorAllKaizens({super.key});

  @override
  State<DirectorAllKaizens> createState() => _DirectorAllKaizensState();
}

class _DirectorAllKaizensState extends State<DirectorAllKaizens> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: dashboardWidget(),
    );
  }

  Widget dashboardWidget() {
    return Scaffold(
      backgroundColor: Color(0xFFEFF3F9),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          'All Kaizens',
          style: TextStyle(
            color: Colors.white, // White text
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<dynamic>(
        future: getViewDirectorAllKaizens(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return errorWidgetDesign(context, snapshot.error.toString());
            } else if (snapshot.hasData) {
              dynamic response = snapshot.data;
              return response['success'] == true
                  ? (response['data'] != null && response['data'].isNotEmpty)
                        ? ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: response['data'].length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              // Get status color and text
                              Color statusColor;
                              String statusText;

                              if (response['data'][index]['status'] == 0) {
                                statusColor = Colors.orange;
                                statusText = 'Pending';
                              } else if (response['data'][index]['status'] ==
                                  2) {
                                statusColor = Colors.red;
                                statusText = 'Rejected';
                              } else if (response['data'][index]['status'] ==
                                  3) {
                                statusColor = Colors.green;
                                statusText = 'Verified';
                              } else if (response['data'][index]['status'] ==
                                      1 &&
                                  (response['data'][index]['end'] == 0 ||
                                      response['data'][index]['start'] == 1) &&
                                  response['data'][index]['k_status'] == 0) {
                                statusColor = Colors.blue;
                                statusText = 'Approved (Not Start)';
                              } else if (response['data'][index]['status'] ==
                                      1 &&
                                  (response['data'][index]['start'] == 1 ||
                                      response['data'][index]['end'] == 0) &&
                                  response['data'][index]['k_status'] == 1) {
                                statusColor = Theme.of(context).primaryColor;
                                statusText = 'Approved (In Progress)';
                              } else {
                                statusColor = Colors.grey;
                                statusText = 'No Status';
                              }

                              // Add type information to the kaizen data
                              Map<String, dynamic> kaizenWithInfo = Map.from(
                                response['data'][index],
                              );
                              kaizenWithInfo['type'] = 'All';

                              return KaizenCard(
                                kaizen: kaizenWithInfo,
                                statusColor: statusColor,
                                statusText: statusText,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DirectorKaizenDetails(
                                            response['data'][index]['id'],
                                            DirectorAllKaizens(),
                                          ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : NoDataWidget(
                            title: 'No Kaizens Available',
                            subtitle:
                                'There are currently no Kaizens reported in the system to display.',
                            icon: Icons.lightbulb_outline,
                          )
                  : dataNotAvailableWidgetDesign(context);
            }
          }
          return Center(
            child: AnimatedDotsLoader(
              text: "Loading",
              color: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }
}
