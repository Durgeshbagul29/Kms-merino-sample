// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ManagerNotificationsScreen extends StatelessWidget {
  const ManagerNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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