// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/screens/user/observation/add_observation.dart';
import 'package:kmsmerino/views/screens/user/observation/user_obsdetails.dart';
import 'package:kmsmerino/views/screens/user/user_functions.dart';

class UserObservationsList extends StatefulWidget {
  const UserObservationsList({super.key});

  @override
  State<UserObservationsList> createState() => _UserObservationsListState();
}

class _UserObservationsListState extends State<UserObservationsList>
    with TickerProviderStateMixin {
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
        child: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                'Safety Observations',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddObservation()),
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: _buildObservationsList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildObservationsList() {
    return FutureBuilder<dynamic>(
      future: getUserObservation(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
                  'Loading observations...',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return errorWidgetDesign(context, snapshot.error.toString());
        } else if (snapshot.hasData) {
          dynamic response = snapshot.data;
          if (response['success'] == true && response['data'] != null) {
            List observations = response['data'];
            if (observations.isEmpty) {
              return Center(
                child: Container(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.visibility_off,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'No Observations Yet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start by adding your first safety observation',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: observations.length,
              itemBuilder: (context, index) {
                var observation = observations[index];
                // Add staggered animation delay for each item
                final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      (1.0 / observations.length) * index,
                      1.0,
                      curve: Curves.easeOut,
                    ),
                  ),
                );
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1.0 - animation.value)),
                      child: Opacity(
                        opacity: animation.value,
                        child: _buildObservationCard(observation),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return errorWidgetDesign(
              context,
              response['message'] ?? 'Failed to load observations',
            );
          }
        } else {
          return errorWidgetDesign(context, 'No data received');
        }
      },
    );
  }

  Widget _buildObservationCard(dynamic observation) {
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
              builder: (context) => UserObservationDetails(
                observation['id'],
                const Text('Observation Details'),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Observation ID / Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    observation['observation_id'],
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

              /// Section Title
              const Text(
                'Observation Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              /// Observation Text
              Text(
                observation['observation'] ?? 'No observation details',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              /// Status + Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(observation['status'] ?? 0),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 16,
                        color: Color(0xFF1A73E8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        observation['created_at'] != null
                            ? DateTime.parse(
                                observation['created_at'],
                              ).toString().split(' ')[0]
                            : 'Unknown date',
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

  Widget _buildStatusChip(int status) {
    String text;
    Color color;

    switch (status) {
      case 0:
        text = 'Pending';
        color = Colors.orange;
        break;
      case 1:
        text = 'Approved';
        color = Colors.green;
        break;
      case 2:
        text = 'Rejected';
        color = Colors.red;
        break;
      default:
        text = 'Unknown';
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
