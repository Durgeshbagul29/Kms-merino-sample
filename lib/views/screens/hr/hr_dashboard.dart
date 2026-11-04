// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kmsmerino/views/base/animated_dots_loader.dart';
import 'package:kmsmerino/views/screens/hr/hr_functions.dart';
import 'package:kmsmerino/views/screens/hr/manage_admin.dart';
import 'package:kmsmerino/views/screens/hr/manage_users.dart';
import 'package:kmsmerino/views/screens/hr/manage_manager.dart';
import 'package:kmsmerino/views/screens/hr/manage_director.dart';

class HrDashboard extends StatefulWidget {
  const HrDashboard({super.key});

  @override
  State<HrDashboard> createState() => _HrDashboardState();
}

class _HrDashboardState extends State<HrDashboard> {
  bool _isLoading = true;
  String? _error;
  dynamic _data;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final result = await getDashboardData();
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (result['records']['success'] == true &&
              result['records']['data'] != null) {
            _data = result['records']['data'];
          } else {
            _error = 'No data available';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final exit = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Exit App'),
            content: Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(c, false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Exit', style: TextStyle(color: Colors.white)),
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ),
            ],
          ),
        );
        if (exit == true) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.people_alt_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HR Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'People Management',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: AnimatedDotsLoader(
          text: 'Loading dashboard data...',
          color: Theme.of(context).primaryColor,
          size: 10.0,
        ),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    return _buildDashboardContent();
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.wifi_off_rounded, color: Colors.red, size: 40),
            ),
            SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                  _data = null;
                });
                _loadDashboard();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.refresh_rounded, color: Colors.white),
              label: Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        setState(() {
          _isLoading = true;
          _error = null;
          _data = null;
        });
        await _loadDashboard();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            _buildWelcomeBanner(),
            SizedBox(height: 24),

            // Stats Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Organization Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard(
                    'Total Admin',
                    _data['totalAdmin'].toString(),
                    Icons.admin_panel_settings_outlined,
                    Color(0xFF667eea),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ManageAdmin()),
                    ),
                  ),
                  _buildStatCard(
                    'Total Directors',
                    _data['totalDirector'].toString(),
                    Icons.business_center_outlined,
                    Color(0xFF764ba2),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ManageDirector()),
                    ),
                  ),
                  _buildStatCard(
                    'Total Managers',
                    _data['totalManager'].toString(),
                    Icons.manage_accounts_outlined,
                    Color(0xFFf093fb),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ManageManager()),
                    ),
                  ),
                  _buildStatCard(
                    'Total Users',
                    _data['totalUsers'].toString(),
                    Icons.people_outline,
                    Color(0xFF4facfe),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ManageUsers()),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28),

            // Quick Actions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 14),
            _buildQuickActionsSection(),
            SizedBox(height: 28),

            // Recent Activity
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Team Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 14),
            _buildActivitySection(_data),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Manage your organization\'s people efficiently.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.people_alt_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    final actions = [
      {
        'title': 'Manage Admins',
        'icon': Icons.admin_panel_settings_rounded,
        'color': Color(0xFF667eea),
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ManageAdmin()),
        ),
      },
      {
        'title': 'Manage Directors',
        'icon': Icons.business_center_rounded,
        'color': Color(0xFF764ba2),
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ManageDirector()),
        ),
      },
      {
        'title': 'Manage Managers',
        'icon': Icons.manage_accounts_rounded,
        'color': Color(0xFFf093fb),
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ManageManager()),
        ),
      },
      {
        'title': 'Manage Users',
        'icon': Icons.people_rounded,
        'color': Color(0xFF4facfe),
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ManageUsers()),
        ),
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.1,
        ),
        itemCount: actions.length,
        itemBuilder: (context, i) {
          final a = actions[i];
          final color = a['color'] as Color;
          return GestureDetector(
            onTap: a['onTap'] as VoidCallback,
            child: Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(a['icon'] as IconData, color: color, size: 28),
                  ),
                  SizedBox(height: 10),
                  Text(
                    a['title'] as String,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivitySection(dynamic data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Admins row — data already available
          if (data['admins'] is List && (data['admins'] as List).isNotEmpty)
            _buildActivityTile(
              title: 'Admins',
              subtitle: '${(data['admins'] as List).length} admins active',
              icon: Icons.admin_panel_settings_rounded,
              color: Color(0xFF667eea),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ManageAdmin()),
              ),
            ),

          // Managers — async
          FutureBuilder<dynamic>(
            future: getAllManagers(),
            builder: (context, snap) {
              String subtitle = 'Tap to manage';
              if (snap.connectionState == ConnectionState.done &&
                  snap.hasData &&
                  snap.data is Map &&
                  snap.data['success'] == true &&
                  snap.data['data'] is List) {
                final list = snap.data['data'] as List;
                subtitle = '${list.length} managers active';
              }
              return _buildActivityTile(
                title: 'Managers',
                subtitle: subtitle,
                icon: Icons.manage_accounts_rounded,
                color: Color(0xFFf093fb),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ManageManager()),
                ),
              );
            },
          ),

          // Directors — async
          FutureBuilder<dynamic>(
            future: getAllDirectors(),
            builder: (context, snap) {
              String subtitle = 'Tap to manage';
              if (snap.connectionState == ConnectionState.done &&
                  snap.hasData &&
                  snap.data is Map &&
                  snap.data['success'] == true &&
                  snap.data['data'] is List) {
                final list = snap.data['data'] as List;
                subtitle = '${list.length} directors active';
              }
              return _buildActivityTile(
                title: 'Directors',
                subtitle: subtitle,
                icon: Icons.business_center_rounded,
                color: Color(0xFF764ba2),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ManageDirector()),
                ),
              );
            },
          ),

          // Users ” async
          FutureBuilder<dynamic>(
            future: getUserData1(),
            builder: (context, snap) {
              String subtitle = 'Tap to manage';
              if (snap.connectionState == ConnectionState.done &&
                  snap.hasData &&
                  snap.data['success'] == true) {
                final userData = snap.data['data'];
                final count = userData is List ? userData.length : 0;
                subtitle = '$count users registered';
              }
              return _buildActivityTile(
                title: 'Users',
                subtitle: subtitle,
                icon: Icons.people_rounded,
                color: Color(0xFF4facfe),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ManageUsers()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: color, width: 3.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[850],
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.chevron_right_rounded, color: color, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
