import 'package:flutter/material.dart';

class DirectorNotificationsScreen extends StatelessWidget {
  const DirectorNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.mark_as_unread),
            onPressed: () {
              // Mark all as read functionality
            },
          ),
        ],
      ),
      body: Center(child: Text('No notifications yet.')),
    );
  }
}
