// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kmsmerino/views/screens/manager/manager_functions.dart';
import 'package:kmsmerino/views/screens/manager/notifications/manager_add_broadcast.dart';
import 'package:kmsmerino/views/screens/manager/notifications/manager_bn_details.dart';
import 'package:kmsmerino/views/base/error_message.dart';

class ManagerBroadcast extends StatefulWidget {
  const ManagerBroadcast({super.key});

  @override
  State<ManagerBroadcast> createState() => _ManagerBroadcastState();
}

class _ManagerBroadcastState extends State<ManagerBroadcast>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  Future<dynamic>? _broadcastFuture;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    _loadBroadcast();
  }

  void _loadBroadcast() {
    setState(() {
      _broadcastFuture = getManagerBroadcast();
    });
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
        child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(
            'Broadcast Notifications',
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
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ManagerAddBroadcast()),
            );
            if (result == true) {
              _loadBroadcast();
            }
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: Text(
            'New Broadcast',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async => _loadBroadcast(),
          child: Column(
            children: [
              // Header banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.campaign, color: Colors.white, size: 22),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Manage and send broadcast messages to your team',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Broadcast List
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: FutureBuilder<dynamic>(
                    future: _broadcastFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return errorWidgetDesign(
                            context,
                            snapshot.error.toString(),
                          );
                        } else if (snapshot.hasData) {
                          dynamic response = snapshot.data;
                          if (response['success'] != true) {
                            return dataNotAvailableWidgetDesign(context);
                          }
                          if (response['data'] == null) {
                            return dataNotAvailableWidgetDesign(context);
                          }
                          final data = response['data'];
                          if (data.length == 0) {
                            return noNotificationWidgetDesign(
                              context,
                              'No Broadcast Notifications',
                            );
                          }
                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return _buildBroadcastCard(
                                title: data[index]['title'] ?? '',
                                message: data[index]['message'] ?? '',
                                datetime: data[index]['datetime'] ?? '',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ManagerBNDetails(data[index]['id']),
                                    ),
                                  );
                                },
                                onDelete: () {
                                  _wantToDelete(context, data[index]['id']);
                                },
                              );
                            },
                          );
                        }
                      }
                      return Center(child: GFLoader());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBroadcastCard({
    required String title,
    required String message,
    required String datetime,
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
              color: Colors.grey.withValues(alpha: 0.07),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.campaign_rounded,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                message,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (datetime.isNotEmpty) ...[
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(width: 4),
                    Text(
                      datetime,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }

  Future _wantToDelete(BuildContext context, dynamic id) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Delete Broadcast'),
            ],
          ),
          content: Text('Do you really want to delete this broadcast?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Delete'),
              onPressed: () async {
                Navigator.pop(ctx);
                await deleteBroadcastNotification(context, id);
                _loadBroadcast();
              },
            ),
          ],
        );
      },
    );
  }
}
