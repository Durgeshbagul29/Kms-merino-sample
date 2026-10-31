import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kmsmerino/views/common/ethics/ethics_screen.dart';
import 'package:kmsmerino/views/screens/manager/reports/manager_report_form.dart';

class ManagerReports extends StatefulWidget {
  const ManagerReports({super.key});

  @override
  State<ManagerReports> createState() => _ManagerReportsState();
}

class _ManagerReportsState extends State<ManagerReports>
    with TickerProviderStateMixin {
  late AnimationController _listController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _listController, curve: Curves.easeOut));
    _listController.forward();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSectionTitle("Operational Excellence"),
                    const SizedBox(height: 16),
                    _buildReportListItem(
                      icon: Iconsax.status_up,
                      title: "Kaizen Reports",
                      description: "Strategic performance and improvement logs",
                      color: const Color(0xFF6366F1),
                      onTap: () => _handleReportTap('Kaizen'),
                    ),
                    _buildReportListItem(
                      icon: Iconsax.danger4,
                      title: "Accident Reports",
                      description:
                          "Critical safety incidents and resolution tracking",
                      color: const Color(0xFFF43F5E),
                      onTap: () => _handleReportTap('Accident'),
                    ),
                    _buildReportListItem(
                      icon: Iconsax.shield_search,
                      title: "Near Miss Reports",
                      description: "Hazard analysis and preventative measures",
                      color: const Color(0xFFF59E0B),
                      onTap: () => _handleReportTap('Nearmiss'),
                    ),
                    _buildReportListItem(
                      icon: Iconsax.eye4,
                      title: "Observations",
                      description: "Daily safety checks and compliance audits",
                      color: const Color(0xFF10B981),
                      onTap: () => _handleReportTap('Observation'),
                    ),
                    _buildReportListItem(
                      icon: Iconsax.judge,
                      title: "Ethics Reports",
                      description:
                          "Grievance and corporate integrity analytics",
                      color: const Color(0xFF6366F1),
                      onTap: () => _handleReportTap('Ethics'),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle("Corporate Governance"),
                    const SizedBox(height: 16),
                    _buildEthicsManagedCard(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        centerTitle: false,
        title: const Text(
          "Managerial Analysis",
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -10,
                child: Icon(
                  Iconsax.layer5,
                  size: 140,
                  color: const Color(0xFF6366F1).withValues(alpha: 0.05),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: Color(0xFF64748B),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildReportListItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Iconsax.arrow_right_3,
                  size: 18,
                  color: Color(0xFFCBD5E1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEthicsManagedCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EthicsScreen()),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Iconsax.judge,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ethics & Complaints",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Manage organizational integrity cases",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFE0E7FF),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Iconsax.arrow_right_3,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleReportTap(String type) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManagerReportForm(type)),
    );
  }
}
