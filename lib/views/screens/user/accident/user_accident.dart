// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/base/padding_widget.dart';
import 'package:kmsmerino/views/common/safety/empty_state_widget.dart';
import 'package:kmsmerino/views/screens/user/accident/add_accident.dart';
import 'package:kmsmerino/views/screens/user/accident/user_accidentdetails.dart';
import 'package:kmsmerino/views/screens/user/user_functions.dart';
import 'package:kmsmerino/models/accident_model.dart';

class UserAccidents extends StatefulWidget {
  const UserAccidents({super.key});

  @override
  State<UserAccidents> createState() => _AccidentState();
}

class _AccidentState extends State<UserAccidents>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    // _getUserData();
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
          backgroundColor: Color(0xFF1A73E8),
          elevation: 6.0,
          shadowColor: Colors.black26,
          title: Text(
            'Accidents',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              tooltip: 'Add New Accident Report',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAccident()),
                );
              },
            ),
            SizedBox(width: 16),
          ],
        ),
        body: PaddingWidget(
          FutureBuilder<dynamic>(
            future: getUserAccidents(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // Error case
                  debugPrint(snapshot.error.toString());
                  return errorWidgetDesign(context, snapshot.error.toString());
                } else if (snapshot.hasData) {
                  // Success case
                  dynamic response = snapshot.data;

                  // Check if API call was successful
                  if (response['success'] == true) {
                    // Check if data exists and is not empty
                    if (response['data'] != null &&
                        (response['data'] as List).isNotEmpty) {
                      // Data available - show list
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: response['data'].length,
                        itemBuilder: (context, index) {
                        return _buildAccidentCard(
                          AccidentModel.fromJson(response['data'][index]),
                        );
                        },
                      );
                    } else {
                      // Data is null or empty - show empty state
                      return EmptyStateWidget(
                        heading: 'No Accidents Yet',
                        subHeading:
                            'Start by adding your first accident report',
                        icon: Icons.event_busy,
                        iconColor: Theme.of(context).primaryColor,
                        backgroundColor: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                      );
                    }
                  } else {
                    // API success is false - show error
                    return errorWidgetDesign(
                      context,
                      response['message'] ?? 'Failed to load data',
                    );
                  }
                } else {
                  // No data case
                  return EmptyStateWidget(
                    heading: 'Data Not Available',
                    subHeading: 'No data found to display',
                    icon: Icons.info_outline,
                    iconColor: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                  );
                }
              }
              // Loading state
              return Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF1A73E8),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAccidentCard(AccidentModel accidentData) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  UserAccidentDetails(accidentData.id, UserAccidents()),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    accidentData.accidentId.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A73E8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Divider(height: 1, color: Colors.grey[300]),
              SizedBox(height: 12),
              Text(
                'Incident Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                accidentData.incident,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: accidentData.status == 0
                          ? Colors.orange.withValues(alpha: 0.1)
                          : Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      accidentData.statusLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: accidentData.status == 0
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 16,
                        color: Color(0xFF1A73E8),
                      ),
                      SizedBox(width: 6),
                      Text(
                        accidentData.sysDate,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
