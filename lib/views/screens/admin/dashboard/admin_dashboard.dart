// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/screens/admin/admin_functions.dart';

// Import local widgets
import 'widgets/admin_stat_card.dart';
import 'widgets/admin_action_item.dart';
import 'widgets/admin_safety_item.dart';
import 'widgets/admin_notification_button.dart';

// Navigation Imports
import 'package:kmsmerino/views/screens/admin/kaizens/admin_allkaizens.dart';
import 'package:kmsmerino/views/screens/admin/kaizens/admin_viewkaizen.dart';
import 'package:kmsmerino/views/screens/admin/kaizens/kaizen_kpi.dart';
import 'package:kmsmerino/views/screens/admin/safety/admin_accident_screen.dart';
import 'package:kmsmerino/views/screens/admin/safety/admin_nearmiss_screen.dart';
import 'package:kmsmerino/views/screens/admin/safety/admin_observation_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final data = await getAdminDashboardData();
      setState(() {
        dashboardData = data['records'];
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading dashboard data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshDashboardData() async {
    try {
      final data = await getAdminDashboardData();
      setState(() {
        dashboardData = data['records'];
      });
    } catch (e) {
      debugPrint("Error refreshing dashboard data: $e");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: LoggedInUser.getName(),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: _buildAppBar(snapshot),
          body: _buildBody(snapshot),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(AsyncSnapshot<String> snapshot) {
    return AppBar(
      title: const Text(
        "Admin Dashboard",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      actions: [
        AdminNotificationButton(
          dashboardData: dashboardData,
          onRefresh: _refreshDashboardData,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(AsyncSnapshot<String> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData) {
        return _buildDashboardContent();
      } else {
        return const Center(child: Text("Error loading user data"));
      }
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildDashboardContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    String kaizenCount = "0";
    try {
      if (dashboardData != null && dashboardData!['data'] != null) {
        kaizenCount = dashboardData!['data']['kaizen_count']?.toString() ?? "0";
      }
    } catch (e) {
      debugPrint("Error extracting dashboard counts: $e");
    }

    return FutureBuilder(
      future: Future.wait([
        getAdminAccidents(),
        getAdminObservation(),
        getAdminNearmiss(),
      ]),
      builder: (context, AsyncSnapshot<List> snapshot) {
        String accidentCount = "0";
        String observationCount = "0";
        String nearMissCount = "0";

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          try {
            var accidentResponse = snapshot.data![0];
            var observationResponse = snapshot.data![1];
            var nearMissResponse = snapshot.data![2];

            if (accidentResponse['success'] == true &&
                accidentResponse['data'] != null) {
              accidentCount = accidentResponse['data'].length.toString();
            }
            if (observationResponse['success'] == true &&
                observationResponse['data'] != null) {
              observationCount = observationResponse['data'].length.toString();
            }
            if (nearMissResponse['success'] == true &&
                nearMissResponse['data'] != null) {
              nearMissCount = nearMissResponse['data'].length.toString();
            }
          } catch (e) {
            debugPrint("Error extracting individual safety counts: $e");
          }
        }

        return RefreshIndicator(
          onRefresh: _refreshDashboardData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Overview"),
                const SizedBox(height: 12),
                _buildStatsSection(kaizenCount),
                const SizedBox(height: 28),
                _buildSectionTitle("Kaizen Categories"),
                const SizedBox(height: 12),
                _buildKaizenGrid(),
                const SizedBox(height: 28),
                _buildSectionTitle("Safety Performance"),
                const SizedBox(height: 12),
                _buildSafetySection(
                  accidentCount,
                  observationCount,
                  nearMissCount,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1E293B),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildStatsSection(String kaizenCount) {
    return Row(
      children: [
        Expanded(
          child: AdminStatCard(
            icon: Icons.auto_fix_high,
            label: "All Kaizens",
            count: "",
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminAllKaizens(),
                ),
              );
            },
            isLocked: false,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AdminStatCard(
            icon: Icons.bar_chart,
            label: "Kaizen KPI",
            count: "",
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KaizenKPI()),
              );
            },
            isLocked: false,
          ),
        ),
      ],
    );
  }

  Widget _buildKaizenGrid() {
    final categories = [
      {"label": "Productivity", "icon": Icons.speed, "color": Colors.green},
      {
        "label": "Quality",
        "icon": Icons.check_circle_outline,
        "color": Colors.blue,
      },
      {"label": "Cost", "icon": Icons.currency_rupee, "color": Colors.orange},
      {
        "label": "Delivery",
        "icon": Icons.local_shipping,
        "color": Colors.purple,
      },
      {"label": "Safety", "icon": Icons.security, "color": Colors.red},
      {"label": "Others", "icon": Icons.more_horiz, "color": Colors.grey},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return AdminActionItem(
          icon: cat['icon'] as IconData,
          label: cat['label'] as String,
          color: cat['color'] as Color,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminViewKaizen(cat['label'] as String),
              ),
            );
          },
          isLocked: false,
        );
      },
    );
  }

  Widget _buildSafetySection(
    String accidentCount,
    String observationCount,
    String nearMissCount,
  ) {
    return SizedBox(
      height: 165,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          AdminSafetyItem(
            icon: Icons.local_fire_department,
            label: "Accidents",
            color: Colors.red,
            count: accidentCount,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminAccidentScreen(),
                ),
              );
            },
            isLocked: false,
          ),
          const SizedBox(width: 12),
          AdminSafetyItem(
            icon: Icons.visibility,
            label: "Observations",
            color: Colors.blue,
            count: observationCount,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminObservationScreen(),
                ),
              );
            },
            isLocked: false,
          ),
          const SizedBox(width: 12),
          AdminSafetyItem(
            icon: Icons.warning_amber,
            label: "Near Miss",
            color: Colors.orange,
            count: nearMissCount,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminNearmissScreen(),
                ),
              );
            },
            isLocked: false,
          ),
        ],
      ),
    );
  }
}
