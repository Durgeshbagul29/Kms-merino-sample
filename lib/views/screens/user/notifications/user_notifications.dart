// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/base/padding_widget.dart';
import 'package:kmsmerino/views/screens/user/notifications/user_bndetails.dart';
import 'package:kmsmerino/views/screens/user/user_functions.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({super.key});

  @override
  State<UserNotification> createState() => _AdminBroadcastState();
}

class _AdminBroadcastState extends State<UserNotification>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late TabController tabController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 1));
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
        child: dashboardWidget());
  }

  Widget dashboardWidget() {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Color(0xFFEFF3F9),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF1A73E8),
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
              onPressed: () => Navigator.pop(context)),
        ),
        body: PaddingWidget(
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 16),

            /// Simplified Segmented Control
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          tabController.animateTo(0);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: tabController.index == 0 
                            ? Color(0xFF1A73E8) 
                            : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Notifications",
                            style: TextStyle(
                              color: tabController.index == 0 
                                ? Colors.white 
                                : Colors.grey[700],
                              fontWeight: tabController.index == 0 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          tabController.animateTo(1);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: tabController.index == 1 
                            ? Color(0xFF1A73E8) 
                            : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Broadcast",
                            style: TextStyle(
                              color: tabController.index == 1 
                                ? Colors.white 
                                : Colors.grey[700],
                              fontWeight: tabController.index == 1 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    /// ==========================
                    /// NOTIFICATIONS TAB
                    /// ==========================
                    FutureBuilder<dynamic>(
                      future: getUserSectionNotifications(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return errorWidgetDesign(
                                context, snapshot.error.toString());
                          } else if (snapshot.hasData) {
                            dynamic response = snapshot.data;

                            if (response['success'] == true &&
                                response['data'] != null &&
                                response['data'].length != 0) {
                              return ListView.builder(
                                  itemCount: response['data'].length,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  itemBuilder: (context, index) {
                                    var item = response['data'][index];

                                    bool isUnread = item["status"] == 0;

                                    return Container(
                                      margin: EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: isUnread ? Colors.white : Colors.grey[50],
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.05),
                                              blurRadius: 6,
                                              offset: Offset(0, 2))
                                        ],
                                        border: Border.all(
                                          color: isUnread 
                                            ? Color(0xFF1A73E8).withValues(alpha: 0.3) 
                                            : Colors.transparent,
                                          width: 1,
                                        ),
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                        leading: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: isUnread 
                                              ? Color(0xFF1A73E8).withValues(alpha: 0.15) 
                                              : Colors.grey[200],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.notifications_active,
                                              color: isUnread 
                                                ? Color(0xFF1A73E8) 
                                                : Colors.grey[500],
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          item["category_id"] == 1
                                              ? "${item["category_name"]} - ${item["subcategory_name"]}"
                                              : item["category_name"],
                                          style: TextStyle(
                                            fontWeight: isUnread
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            fontSize: 16,
                                            color: isUnread 
                                              ? Colors.black87 
                                              : Colors.grey[700],
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 6.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${item["date"]}",
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 13,
                                                  )),
                                              SizedBox(height: 4),
                                              Text("${item["message"]}",
                                                  style: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          isUnread
                                              ? reviewSectionNotification(
                                                  context,
                                                  item["id"],
                                                  UserNotification())
                                              : viewSectionNotification(
                                                  context,
                                                  item["id"],
                                                  UserNotification());
                                        },
                                        trailing: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Colors.red.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            onPressed: () =>
                                                deleteSectionNotification(
                                                    context, item["id"]),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              return _buildEmptyState(
                                icon: Icons.notifications_outlined,
                                title: "No Notifications",
                                message: "You don't have any notifications at the moment."
                              );
                            }
                          }
                        }
                        return Center(child: _buildLoadingIndicator());
                      },
                    ),

                    /// ==========================
                    /// BROADCAST TAB
                    /// ==========================
                    FutureBuilder<dynamic>(
                      future: getUserBroadcast(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return errorWidgetDesign(
                                context, snapshot.error.toString());
                          } else if (snapshot.hasData) {
                            var responseBr = snapshot.data;

                            if (responseBr['success'] == true &&
                                responseBr['data'] != null &&
                                responseBr['data'].length != 0) {
                              return ListView.builder(
                                itemCount: responseBr['data'].length,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                itemBuilder: (context, index) {
                                  var br = responseBr['data'][index];

                                  return Container(
                                    margin: EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 6,
                                            offset: Offset(0, 2))
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(16),
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.campaign,
                                            color: Colors.orange,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        br["title"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 6.0),
                                        child: Text(br["message"],
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 14,
                                            )),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => UserBNDetails(
                                                    br["id"], UserNotification())));
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              return _buildEmptyState(
                                icon: Icons.campaign_outlined,
                                title: "No Broadcasts",
                                message: "There are no broadcast notifications at the moment."
                              );
                            }
                          }
                        }
                        return Center(child: _buildLoadingIndicator());
                      },
                    ),
                  ],
                ))
          ]),
        ),
      ),
    );
  }

  /// Loading indicator with modern design
  Widget _buildLoadingIndicator() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A73E8)),
          strokeWidth: 3,
        ),
      ),
    );
  }

  /// Empty state widget for when there are no notifications
  Widget _buildEmptyState({required IconData icon, required String title, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.grey[400],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
