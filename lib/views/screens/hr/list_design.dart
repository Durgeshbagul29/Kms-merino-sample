// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Widget dataListWidget(dynamic datalist) {
  // Check if datalist is null or empty
  if (datalist == null || datalist.isEmpty) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: const [
            Icon(Icons.info_outline, size: 48, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "No data available",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
  }

  return Container(
    padding: EdgeInsets.all(16),
    child: datalist.length == 1
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildDataWidgetBasedOnStructure(datalist[0]),
              ),
            ],
          )
        : datalist.length == 2
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildDataWidgetBasedOnStructure(datalist[0]),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildDataWidgetBasedOnStructure(datalist[1]),
              ),
            ],
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildDataWidgetBasedOnStructure(datalist[0]),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDataWidgetBasedOnStructure(datalist[1]),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildDataWidgetBasedOnStructure(datalist[2]),
                  ),
                ],
              ),
            ],
          ),
  );
}

// Helper method to determine the structure of the data and build appropriate widget
Widget _buildDataWidgetBasedOnStructure(dynamic item) {
  // Check if the item has a 'name' property (for users/admins/managers/directors)
  if (item.containsKey('name')) {
    // Check if the item has a 'status' property
    if (item.containsKey('status')) {
      return dataWidget(item["name"], item["status"]);
    } else {
      // For items without status, create a default active status
      return dataWidget(item["name"], 1); // Default to active
    }
  } else if (item.containsKey('first_name') && item.containsKey('last_name')) {
    // Handle case where name is split into first_name and last_name
    String fullName = "${item['first_name']} ${item['last_name']}";
    int status = item.containsKey('status') ? item['status'] : 1;
    return dataWidget(fullName, status);
  } else if (item.containsKey('username')) {
    // Handle case where name is stored as username
    String name = item['username'];
    int status = item.containsKey('status') ? item['status'] : 1;
    return dataWidget(name, status);
  } else {
    // Fallback: try to get any name-like field
    String name = item.toString(); // Convert to string as fallback
    if (item.containsKey('id')) {
      name = "User ${item['id']}";
    } else if (item.containsKey('email')) {
      name = item['email'];
    }
    return dataWidget(name, 1); 
  }
}

Widget dataWidget(String name, int status) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue.shade700,
          child: Icon(Icons.person, color: Colors.white, size: 30),
        ),
        SizedBox(height: 12),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: status == 1 ? Colors.green[100] : Colors.red[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status == 1 ? "Active" : "Inactive",
            style: TextStyle(
              color: status == 1 ? Colors.green[800] : Colors.red[800],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}