// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/director/kaizen/director_allkaizens.dart';
import 'package:kmsmerino/views/screens/director/kaizen/director_viewkaizen.dart';
import 'package:kmsmerino/views/screens/director/kaizen/director_kpi.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/screens/director/director_functions.dart';
import 'package:kmsmerino/views/screens/director/safety/director_accident_screen.dart';
import 'package:kmsmerino/views/screens/director/safety/director_nearmiss_screen.dart';
import 'package:kmsmerino/views/screens/director/safety/director_observation_screen.dart';
import 'package:iconsax/iconsax.dart';

class DirectorDashboard extends StatefulWidget {
  const DirectorDashboard({super.key});

  @override
  State<DirectorDashboard> createState() => _DirectorDashboardState();
}

class _DirectorDashboardState extends State<DirectorDashboard>
    with TickerProviderStateMixin {
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _loadDashboardData();
    _fadeController.forward();
  }

  Future<void> _loadDashboardData() async {
    try {
      final data = await getDirectorDashboard();
      setState(() {
        dashboardData = data['records'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Light Slate Background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          "Director Insights",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async => await _loadDashboardData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeHeader(),
                      const SizedBox(height: 28),
                      _buildSectionHeader("Strategic Performance"),
                      const SizedBox(height: 16),
                      _buildMainCards(primaryColor),
                      const SizedBox(height: 32),
                      _buildSectionHeader("Kaizen Categories"),
                      const SizedBox(height: 16),
                      _buildKaizenGrid(primaryColor),
                      const SizedBox(height: 32),
                      _buildSectionHeader("Safety Compliance Matrix"),
                      const SizedBox(height: 16),
                      _buildSafetyOversight(primaryColor),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return FutureBuilder<String>(
      future: LoggedInUser.getName(),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Executive Overview",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Hello, ${snapshot.data ?? 'Director'}",
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Color(0xFF64748B),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildMainCards(Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: _buildExecutiveFeatureCard(
            icon: Iconsax.status_up,
            title: "All Kaizens",
            subtitle: "Full Kaizen Review",
            color: primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DirectorAllKaizens()),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildExecutiveFeatureCard(
            icon: Iconsax.diagram,
            title: "KPI Analytics",
            subtitle: "Performance Metrics",
            color: const Color(0xFF6366F1),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DirectorKPI()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExecutiveFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKaizenGrid(Color primaryColor) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: [
        _buildGridTile(
          Iconsax.flash_1,
          "Productivity",
          Colors.green,
          "Productivity",
        ),
        _buildGridTile(Iconsax.verify, "Quality", Colors.blue, "Quality"),
        _buildGridTile(Iconsax.money_3, "Cost", Colors.orange, "Cost"),
        _buildGridTile(Iconsax.truck, "Delivery", Colors.purple, "Delivery"),
        _buildGridTile(Iconsax.shield_tick, "Safety", Colors.red, "Safety"),
        _buildGridTile(Iconsax.menu_board, "Others", Colors.grey, "Others"),
      ],
    );
  }

  Widget _buildGridTile(IconData icon, String label, Color color, String type) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DirectorViewKaizen(type)),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyOversight(Color primaryColor) {
    return FutureBuilder(
      future: Future.wait([
        getDirectorAccidents(),
        getDirectorObservation(),
        getDirectorNearmiss(),
      ]),
      builder: (context, AsyncSnapshot<List> snapshot) {
        final counts = ["0", "0", "0"];
        if (snapshot.hasData) {
          for (int i = 0; i < 3; i++) {
            if (snapshot.data![i]['success'] == true &&
                snapshot.data![i]['data'] != null) {
              counts[i] = snapshot.data![i]['data'].length.toString();
            }
          }
        }

        return Column(
          children: [
            _buildSafetyRow(
              icon: Iconsax.danger,
              label: "Accident Tracking",
              count: counts[0],
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DirectorAccidentScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildSafetyRow(
              icon: Iconsax.eye,
              label: "Safety Observations",
              count: counts[1],
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DirectorObservationScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildSafetyRow(
              icon: Iconsax.shield_search,
              label: "Near Miss Logs",
              count: counts[2],
              color: Colors.orange,

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DirectorNearmissScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSafetyRow({
    required IconData icon,
    required String label,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Strategic Monitoring",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
