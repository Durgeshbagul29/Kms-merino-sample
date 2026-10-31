// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/common/kaizen/kaizen_card.dart';
import 'package:kmsmerino/views/common/kaizen/kaizen_no_data_widget.dart';
import 'package:kmsmerino/views/screens/admin/admin_functions.dart';
import 'package:kmsmerino/views/screens/admin/kaizens/admin_kaizendetails.dart';
import 'package:kmsmerino/views/base/animated_dots_loader.dart';
import 'package:kmsmerino/views/base/error_message.dart';

class AdminViewKaizen extends StatefulWidget {
  final String type;
  const AdminViewKaizen(this.type, {super.key});

  @override
  State<AdminViewKaizen> createState() => _AdminViewKaizenState();
}

class _AdminViewKaizenState extends State<AdminViewKaizen> {
  @override
  void initState() {
    super.initState();
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
      backgroundColor: Color(0xFFEFF3F9),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          _getTitleFromType(widget.type),
          style: TextStyle(
            color: Colors.white,
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
        future: getAdminViewKaizen(widget.type),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              return errorWidgetDesign(context, snapshot.error.toString());
            } else if (snapshot.hasData) {
              // dynamic kaizens = snapshot.data['kaizens'];
              dynamic response = snapshot.data;
              return response['success'] == true
                  ? response['data'] != null && response['data']['kaizens'] != null && response['data']['kaizens'].length > 0
                        ? ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: response['data']['kaizens'].length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              // Get status color and text
                              Color statusColor;
                              String statusText;

                              if (response['data']['kaizens'][index]['status'] ==
                                  0) {
                                statusColor = Colors.orange;
                                statusText = 'Pending';
                              } else if (response['data']['kaizens'][index]['status'] ==
                                  2) {
                                statusColor = Colors.red;
                                statusText = 'Rejected';
                              } else if (response['data']['kaizens'][index]['status'] ==
                                  3) {
                                statusColor = Colors.green;
                                statusText = 'Verified';
                              } else if (response['data']['kaizens'][index]['status'] ==
                                      1 &&
                                  (response['data']['kaizens'][index]['end'] ==
                                          0 ||
                                      response['data']['kaizens'][index]['start'] ==
                                          1) &&
                                  response['data']['kaizens'][index]['k_status'] ==
                                      0) {
                                statusColor = Colors.blue;
                                statusText = 'Approved (Not Start)';
                              } else if (response['data']['kaizens'][index]['status'] ==
                                      1 &&
                                  (response['data']['kaizens'][index]['start'] ==
                                          1 ||
                                      response['data']['kaizens'][index]['end'] ==
                                          0) &&
                                  response['data']['kaizens'][index]['k_status'] ==
                                      1) {
                                statusColor = Theme.of(context).primaryColor;
                                statusText = 'Approved (In Progress)';
                              } else {
                                statusColor = Colors.grey;
                                statusText = 'No Status';
                              }

                              // Add type information to the kaizen data
                              Map<String, dynamic> kaizenWithInfo = Map.from(response['data']['kaizens'][index]);
                              kaizenWithInfo['type'] = widget.type;

                              return KaizenCard(
                                kaizen: kaizenWithInfo,
                                statusColor: statusColor,
                                statusText: statusText,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminKaizenDetails(
                                        response['data']['kaizens'][index]['id'],
                                        AdminViewKaizen(widget.type),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : KaizenNoDataWidget(type: widget.type)
                  : KaizenNoDataWidget(type: widget.type);
            }
          }
          return Center(
            child: AnimatedDotsLoader(
              text: "Loading",
              color: Theme.of(context).primaryColor,
            ),
          );
          // return connectedToWifi != true ? checkConnectionWidget(context) : snapshot.data == false ? Login() : HomePage();
        },
      ),
    );
  }

  String _getTitleFromType(String type) {
    switch (type) {
      case "Pending":
        return "Pending Kaizens";
      case "Approved":
        return "Approved Kaizens";
      case "Productivity":
        return "Productivity Kaizens";
      case "Quality":
        return "Quality Kaizens";
      case "Cost":
        return "Cost Kaizens";
      case "Delivery":
        return "Delivery Kaizens";
      case "Safety":
        return "Safety Kaizens";
      case "Others":
        return "Other Kaizens";
      default:
        return "All Kaizens";
    }
  }
}
