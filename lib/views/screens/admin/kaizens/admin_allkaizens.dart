// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/common/kaizen/kaizen_card.dart';
import 'package:kmsmerino/views/common/kaizen/kaizen_no_data_widget.dart';
import 'package:kmsmerino/views/screens/admin/admin_functions.dart';
import 'package:kmsmerino/views/screens/admin/kaizens/admin_kaizendetails.dart';
import 'package:kmsmerino/views/base/animated_dots_loader.dart';
import 'package:kmsmerino/views/base/error_message.dart';

class AdminAllKaizens extends StatefulWidget {
  const AdminAllKaizens({super.key});

  @override
  State<AdminAllKaizens> createState() => _AdminAllKaizensState();
}

class _AdminAllKaizensState extends State<AdminAllKaizens>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationController.forward();
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
        child: dashboardWidget(),
    );
  }

  Widget dashboardWidget() {
    return SafeArea(
      top: false,
      child: Scaffold(
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
          future: getAdminAllKaizens(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                return errorWidgetDesign(context, snapshot.error.toString());
              } else if (snapshot.hasData) {
                // dynamic kaizens = snapshot.data['kaizens'];
                dynamic response = snapshot.data;
                return response['success'] == true
                    ? response['data'] != null &&
                              response['data']['kaizens'] != null &&
                              response['data']['kaizens'].length > 0
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

                                // Create animation for each card
                                Animation<double> cardAnimation =
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                        parent: _animationController,
                                        curve: Interval(
                                          (1.0 /
                                                  response['data']['kaizens']
                                                      .length) *
                                              index,
                                          1.0,
                                          curve: Curves.easeOut,
                                        ),
                                      ),
                                    );

                                return AnimatedBuilder(
                                  animation: cardAnimation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                        0,
                                        30 * (1.0 - cardAnimation.value),
                                      ),
                                      child: Opacity(
                                        opacity: cardAnimation.value,
                                        child: KaizenCard(
                                          kaizen:
                                              response['data']['kaizens'][index],
                                          statusColor: statusColor,
                                          statusText: statusText,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminKaizenDetails(
                                                      response['data']['kaizens'][index]['id'],
                                                      AdminAllKaizens(),
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : KaizenNoDataWidget(type: 'All')
                    : errorWidgetDesign(
                        context,
                        response['message'] ?? "Something went wrong",
                      );
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
      ),
    );
  }
}
