// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/common/safety/empty_state_widget.dart';
import 'package:kmsmerino/views/screens/user/nearmiss/add_nearmiss.dart';
import 'package:kmsmerino/views/screens/user/nearmiss/user_nearmissdetails.dart';
import 'package:kmsmerino/views/screens/user/user_functions.dart';

class UserNearmiss extends StatefulWidget {
  const UserNearmiss({super.key});

  @override
  State<UserNearmiss> createState() => _NearmissState();
}

class _NearmissState extends State<UserNearmiss> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
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
        child: FadeTransition(opacity: _fadeAnimation, child: dashboardWidget()),
    );
  }

  Widget dashboardWidget() {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Near Miss',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              tooltip: 'Add New Near Miss Report',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNearmiss()),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: FutureBuilder<dynamic>(
              future: getUserNearmiss(),
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
                    // Check if API call was successful
                    if (response['success'] == true) {
                      // Check if data exists and is not empty
                      if (response['data'] != null &&
                          (response['data'] as List).isNotEmpty) {
                        List nearmisses = response['data'];
                        return RefreshIndicator(
                          onRefresh: () async {
                            setState(() {});
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: nearmisses.length,
                            itemBuilder: (context, index) {
                              var nearmiss = nearmisses[index];
                              // Add staggered animation delay for each item
                              final animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Interval(
                                        (1.0 / nearmisses.length) * index,
                                        1.0,
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                  );
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      0,
                                      20 * (1.0 - animation.value),
                                    ),
                                    child: Opacity(
                                      opacity: animation.value,
                                      child: _buildNearMissCard(
                                        context,
                                        nearmiss["sys_date"],
                                        nearmiss["incident"],
                                        nearmiss['status'],
                                        nearmiss['id'],
                                        nearmiss['nearmiss_id'].toString(),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      } else {
                        // Data is null or empty - show empty state
                        return EmptyStateWidget(
                          heading: 'No Near Miss Reports',
                          subHeading:
                              'Start by adding your first near miss report',
                          icon: Icons.warning_amber_outlined,
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
                      iconColor: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.7),
                    );
                  }
                }
                // Loading state
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading near miss reports...',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNearMissCard(
    BuildContext context,
    String date,
    String incident,
    int status,
    int id,
    String nearMissId,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserNearmissDetails(id, UserNearmiss()),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Near Miss ID / Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nearMissId,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A73E8),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.grey[300]),
              const SizedBox(height: 12),

              /// Section title
              const Text(
                'Near Miss Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              /// Incident text
              Text(
                incident,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              /// Status + Date row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNearMissStatusChip(status),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 16,
                        color: Color(0xFF1A73E8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        date,
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

  Widget _buildNearMissStatusChip(int status) {
    bool isPending = status == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPending
            ? Colors.orange.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPending ? 'Pending' : 'Closed',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isPending ? Colors.orange : Colors.green,
        ),
      ),
    );
  }
}
