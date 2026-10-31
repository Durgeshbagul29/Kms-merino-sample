// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Widget errorWidgetDesign(BuildContext context, String errormsg) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50, color: Colors.red),
          SizedBox(height: 10),
          Text(
            "Error",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(errormsg, style: TextStyle(color: Colors.black87, fontSize: 15)),
        ],
      ),
    ),
  );
}

Widget dataNotAvailableWidgetDesign(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(20),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 60,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ),
          SizedBox(height: 16),
          Text(
            "Data Not Available",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "No data found to display",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget noNotificationWidgetDesign(BuildContext context, String str) {
  return Container(
    padding: EdgeInsets.all(20),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 60,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ),
          SizedBox(height: 16),
          Text(
            str,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
