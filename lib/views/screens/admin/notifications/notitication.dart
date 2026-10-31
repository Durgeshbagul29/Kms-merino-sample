// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kmsmerino/views/screens/admin/admin_functions.dart';
import 'package:kmsmerino/views/screens/admin/notifications/add_broadcast.dart';
import 'package:kmsmerino/views/screens/admin/notifications/bn_details.dart';
import 'package:kmsmerino/views/base/error_message.dart';

class AdminNotification extends StatefulWidget {
  const AdminNotification({super.key});

  @override
  State<AdminNotification> createState() => _AdminBroadcastState();
}

class _AdminBroadcastState extends State<AdminNotification>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late TabController tabController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    tabController.dispose();
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Enhanced Tab Bar with Smooth Transitions
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blue.shade700,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              // Remove the bottom divider line
              dividerColor: Colors.transparent,
              // Add smooth animation
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: const <Widget>[
                Tab(text: "Kaizens"),
                Tab(text: "Broadcast"),
              ],
            ),
          ),

          SizedBox(height: 10),

          Expanded(
            child: TabBarView(
              controller: tabController,
              // Add smooth page transition animation
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                // Kaizen Notifications Tab
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: FutureBuilder<dynamic>(
                    future: getAdminKaizenNotifications(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          debugPrint(snapshot.error.toString());
                          return errorWidgetDesign(
                            context,
                            snapshot.error.toString(),
                          );
                        } else if (snapshot.hasData) {
                          dynamic response = snapshot.data;
                          return response['success'] == true
                              ? response['data'] != null
                                    ? response['data'].length != 0
                                          ? ListView.builder(
                                              itemCount:
                                                  response['data'].length,
                                              itemBuilder: (context, index) {
                                                String message =
                                                    response['data'][index]["message"];
                                                var str = message.split("by");
                                                return _buildNotificationCard(
                                                  title:
                                                      "Emp ID: ${response['data'][index]['uname']}",
                                                  subtitle: str[0],
                                                  time:
                                                      response['data'][index]["created_at"],
                                                  isRead:
                                                      response['data'][index]["status"] ==
                                                      1,
                                                  onTap: () {
                                                    if (response['data'][index]["status"] ==
                                                        0) {
                                                      reviewKaizenNotification(
                                                        context,
                                                        response['data'][index]["id"],
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                            )
                                          : noNotificationWidgetDesign(
                                              context,
                                              "No Notifications",
                                            )
                                    : dataNotAvailableWidgetDesign(context)
                              : dataNotAvailableWidgetDesign(context);
                        }
                      }
                      return Center(child: GFLoader());
                    },
                  ),
                ),

                // Broadcast Notifications Tab
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: FutureBuilder<dynamic>(
                    future: getAdminBroadcast(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          debugPrint(snapshot.error.toString());
                          return errorWidgetDesign(
                            context,
                            snapshot.error.toString(),
                          );
                        } else if (snapshot.hasData) {
                          dynamic responseForBr = snapshot.data;
                          return responseForBr['success'] == true
                              ? responseForBr['data'] != null
                                    ? Column(
                                        children: [
                                          SizedBox(height: 10),
                                          // Enhanced Create Broadcast Button
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 16,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                elevation: 2,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddBroadcast(),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.add, size: 20),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Create Broadcast',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),

                                          responseForBr['data'].length != 0
                                              ? Expanded(
                                                  child: ListView.builder(
                                                    itemCount:
                                                        responseForBr['data']
                                                            .length,
                                                    itemBuilder: (context, index) {
                                                      return _buildBroadcastCard(
                                                        title:
                                                            responseForBr['data'][index]["title"],
                                                        message:
                                                            responseForBr['data'][index]["message"],
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) => BNDetails(
                                                                    responseForBr['data'][index]["id"],
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                        onDelete: () {
                                                          wantToDelete(
                                                            context,
                                                            responseForBr['data'][index]["id"],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                )
                                              : noNotificationWidgetDesign(
                                                  context,
                                                  "No Broadcast Notifications",
                                                ),
                                        ],
                                      )
                                    : dataNotAvailableWidgetDesign(context)
                              : dataNotAvailableWidgetDesign(context);
                        }
                      }
                      return Center(child: GFLoader());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced Notification Card
  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required String time,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isRead ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isRead ? Colors.transparent : Colors.blue.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: isRead ? Colors.grey.shade300 : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications,
              color: isRead ? Colors.grey.shade700 : Colors.blue.shade700,
              size: 22,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    color: isRead ? Colors.grey.shade600 : Colors.black87,
                  ),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: isRead ? Colors.grey.shade500 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isRead ? Colors.grey.shade600 : Colors.black87,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced Broadcast Card
  Widget _buildBroadcastCard({
    required String title,
    required String message,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.campaign, color: Colors.blue.shade700, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red.shade400),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }

  Future wantToDelete(BuildContext context, id) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are You Sure?'),
          content: Text('Do you really want to delete record?'),
          actions: [
            GFButton(
              color: Theme.of(context).primaryColor,
              child: Text('Yes'),
              onPressed: () => deleteBroadcastNotification(context, id),
            ),
            GFButton(
              color: GFColors.DANGER,
              child: Text('No'),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        );
      },
    );
  }
}
