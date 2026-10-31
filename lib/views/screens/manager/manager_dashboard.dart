// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/manager/kaizen/manager_allkaizens.dart';
import 'package:kmsmerino/views/screens/manager/kaizen/manager_viewkaizen.dart';
import 'package:kmsmerino/views/screens/manager/kaizen/manager_kpi.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/screens/manager/manager_functions.dart';
import 'package:kmsmerino/views/screens/manager/notifications/manager_broadcast.dart';

import 'package:kmsmerino/views/screens/manager/safety/manager_accident_screen.dart';
import 'package:kmsmerino/views/screens/manager/safety/manager_nearmiss_screen.dart';
import 'package:kmsmerino/views/screens/manager/safety/manager_observation_screen.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final data = await getManagerDashboard();
      setState(() {
        dashboardData = data;
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
      final data = await getManagerDashboard();
      setState(() {
        dashboardData = data;
      });
    } catch (e) {
      debugPrint("Error refreshing dashboard data: $e");
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: LoggedInUser.getName(),
      builder: (context, snapshot) {
        String userName = snapshot.hasData ? snapshot.data! : "Manager";
        return Scaffold(
          backgroundColor: Color(0xFFF1F5F9),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            tooltip: 'Broadcast Notifications',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ManagerBroadcast()),
              );
            },
            child: Icon(Icons.campaign_rounded, color: Colors.white),
          ),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildDashboard(userName),
          ),
        );
      },
    );
  }

  Widget _buildDashboard(String userName) {
    String kaizenCount = "0";
    try {
      if (dashboardData != null && dashboardData!['data'] != null) {
        kaizenCount = dashboardData!['data']['kaizen_count']?.toString() ?? "0";
      }
    } catch (e) {
      debugPrint("Error extracting kaizen count: $e");
    }

    return RefreshIndicator(
      onRefresh: () => _refreshDashboardData(),
      child: CustomScrollView(
        slivers: [
          _buildSliverHeader(userName),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionLabel(
                  "Operational Statistics",
                  Icons.insights_rounded,
                ),
                SizedBox(height: 16),
                _buildOverviewSection(kaizenCount),
                SizedBox(height: 32),
                _buildSectionLabel("Kaizen Categories", Icons.category_rounded),
                _buildCategorySection(),
                SizedBox(height: 32),
                _buildSectionLabel("Safety Performance", Icons.shield_rounded),
                SizedBox(height: 20),
                _buildSafetySection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(String userName) {
    // Notification count logic removed

    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withBlue(220),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                bottom: -40,
                child: Icon(
                  Icons.dashboard_rounded,
                  size: 200,
                  color: Colors.white12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Manager Dashboard",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Welcome, $userName",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Broadcast Notifications',
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 28,
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ManagerBroadcast()),
            );
          },
        ),
        SizedBox(width: 4),
      ],
    );
  }

  Widget _buildSectionLabel(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Color(0xFF64748B)),
        SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF64748B),
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewSection(String kaizenCount) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: "All Kaizens",
            icon: Icons.auto_fix_high_rounded,
            color: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ManagerAllKaizens()),
              );
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            title: "KPI Analysis",
            icon: Icons.analytics_rounded,
            color: Color(0xFF6366F1),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ManagerKPI()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    final categories = [
      {
        "name": "Productivity",
        "icon": Icons.bolt_rounded,
        "color": Colors.amber,
      },
      {
        "name": "Quality",
        "icon": Icons.verified_user_rounded,
        "color": Colors.blue,
      },
      {"name": "Cost", "icon": Icons.currency_rupee, "color": Colors.green},
      {
        "name": "Delivery",
        "icon": Icons.local_shipping_rounded,
        "color": Colors.purple,
      },
      {"name": "Safety", "icon": Icons.security_rounded, "color": Colors.red},
      {"name": "Others", "icon": Icons.apps_rounded, "color": Colors.blueGrey},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return _buildCategoryTile(
          title: cat['name'] as String,
          icon: cat['icon'] as IconData,
          color: cat['color'] as Color,
        );
      },
    );
  }

  Widget _buildSafetySection() {
    return FutureBuilder(
      future: Future.wait([
        getManagerAccidents(),
        getManagerObservation(),
        getManagerNearmiss(),
      ]),
      builder: (context, AsyncSnapshot<List> snapshot) {
        String accidents = "0";
        String observations = "0";
        String nearmiss = "0";

        if (snapshot.hasData) {
          try {
            if (snapshot.data![0]['success'] == true) {
              accidents = snapshot.data![0]['data']?.length.toString() ?? "0";
            }
            if (snapshot.data![1]['success'] == true) {
              observations =
                  snapshot.data![1]['data']?.length.toString() ?? "0";
            }
            if (snapshot.data![2]['success'] == true) {
              nearmiss = snapshot.data![2]['data']?.length.toString() ?? "0";
            }
          } catch (e) {
            debugPrint("Error parsing safety counts: $e");
          }
        }

        return Column(
          children: [
            _buildSafetyRow(
              title: "Accidents Recorded",
              subtitle: "Accident Tracking",
              count: accidents,
              icon: Icons.emergency_rounded,
              color: Colors.redAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ManagerAccidentScreen()),
                );
              },
            ),
            SizedBox(height: 12),
            _buildSafetyRow(
              title: "Safety Observations",
              subtitle: "Observation Tracking",
              count: observations,
              icon: Icons.visibility_rounded,
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ManagerObservationScreen()),
                );
              },
            ),
            SizedBox(height: 12),
            _buildSafetyRow(
              title: "Near Miss Events",
              subtitle: "Nearmiss Tracking",
              count: nearmiss,
              icon: Icons.report_problem_rounded,
              color: Colors.orangeAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ManagerNearmissScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // --- SEPARATE CARD VIEWS ---

  Widget _buildMetricCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF475569),
              ),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ManagerViewKaizen(title)),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF64748B).withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyRow({
    required String title,
    required String subtitle,
    required String count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                count,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
