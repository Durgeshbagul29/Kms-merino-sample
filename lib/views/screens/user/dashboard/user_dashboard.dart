// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/base/padding_widget.dart';
import 'package:kmsmerino/views/screens/user/user_functions.dart';
import 'package:kmsmerino/views/screens/user/user_bottom_navigation.dart';
import 'package:flutter/services.dart';

// Local Widget Imports
import 'widgets/user_notification_button.dart';
import 'widgets/user_summary_card.dart';
import 'widgets/user_kaizen_category_card.dart';
import 'widgets/user_status_menu_item.dart';
import 'widgets/user_safety_category_list_item.dart';

// Navigation Imports
import 'package:kmsmerino/views/screens/user/accident/user_accident.dart';
import 'package:kmsmerino/views/screens/user/kaizens/user_submittedkaizens.dart';
import 'package:kmsmerino/views/screens/user/kaizens/user_viewkaizen.dart';
import 'package:kmsmerino/views/screens/user/nearmiss/user_nearmiss.dart';
import 'package:kmsmerino/views/screens/user/kaizens/user_approvedkaizens.dart';
import '../observation/user_observations_list.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
    with TickerProviderStateMixin {
  late Future<dynamic> _dashboardFuture;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    _dashboardFuture = getUserDashboardData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refreshDashboard() {
    setState(() {
      _dashboardFuture = getUserDashboardData();
    });
  }

  Future<void> _navigateAndRefresh(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    _refreshDashboard();
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
            title: const Text(
              'Exit App',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('Do you really want to exit the application?'),
            actions: [
              TextButton(
                child: const Text('No', style: TextStyle(color: Colors.grey)),
                onPressed: () => Navigator.pop(c, false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Yes', style: TextStyle(color: Colors.white)),
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
      child: FutureBuilder<dynamic>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: const Color(0xFFEFF3F9),
            appBar: _buildAppBar(snapshot),
            body: _buildBody(snapshot),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AsyncSnapshot<dynamic> snapshot) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      title: const Text(
        'Merino KMS',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        UserNotificationButton(
          response: snapshot.data,
          navigateAndRefresh: _navigateAndRefresh,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return errorWidgetDesign(context, snapshot.error.toString());
      } else if (snapshot.hasData) {
        dynamic response = snapshot.data;
        if (response['records'] != null &&
            response['records']['success'] == true &&
            response['records']['data'] != null) {
          return _buildDashboardContent(response['records']['data']);
        } else {
          return dataNotAvailableWidgetDesign(context);
        }
      } else {
        return dataNotAvailableWidgetDesign(context);
      }
    }
    return _buildLoadingWidget();
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
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
              Theme.of(context).primaryColor,
            ),
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(Map<String, dynamic> data) {
    final Map<String, dynamic> counts = data['counts'];

    return RefreshIndicator(
      onRefresh: () async => _refreshDashboard(),
      child: PaddingWidget(
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildSummaryCards(counts),
              const SizedBox(height: 20),
              _buildKaizenSection(counts),
              const SizedBox(height: 20),
              _buildSafetySection(counts),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> counts) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          UserSummaryCard(
            icon: Icons.security,
            title: 'Safety',
            count:
                (counts['accident'] +
                        counts['nearmiss'] +
                        counts['observation'])
                    .toString(),
            color: const Color(0xFF4CAF50),
            onTap: () {
              // Navigation if needed
            },
          ),
          UserSummaryCard(
            icon: Icons.auto_graph,
            title: 'Kaizens',
            count:
                (counts['productivity'] +
                        counts['quality'] +
                        counts['cost'] +
                        counts['delivery'] +
                        counts['safety'] +
                        counts['others'])
                    .toString(),
            color: const Color(0xFF2196F3),
            onTap: () {
              // Navigation if needed
            },
          ),
          UserSummaryCard(
            icon: Icons.gavel,
            title: 'Ethics',
            count: counts['complaints'].toString(),
            color: const Color(0xFFF44336),
            onTap: () {
              UserBottomNavigation.of(context)?.switchTab(1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKaizenSection(Map<String, dynamic> counts) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            child: Text(
              'Kaizen Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 0.9,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildKaizenTile(counts, 'Productivity', Icons.speed),
                    _buildKaizenTile(
                      counts,
                      'Quality',
                      Icons.check_circle_outline,
                    ),
                    _buildKaizenTile(counts, 'Cost', Icons.currency_rupee),
                    _buildKaizenTile(counts, 'Delivery', Icons.local_shipping),
                    _buildKaizenTile(counts, 'Safety', Icons.security),
                    _buildKaizenTile(counts, 'Others', Icons.more_horiz),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Color(0xFFE0E0E0), thickness: 1),
                ),
                _buildStatusMenuItem(
                  'Submitted Kaizens',
                  Icons.send,
                  UserSubmittedKaizens(),
                ),
                _buildStatusMenuItem(
                  'Approved Kaizens',
                  Icons.check,
                  UserApprovedKaizens(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKaizenTile(
    Map<String, dynamic> counts,
    String title,
    IconData icon,
  ) {
    return UserKaizenCategoryCard(
      icon: icon,
      title: title,
      count: counts[title.toLowerCase()]?.toString() ?? "0",
      onTap: () {
        _navigateAndRefresh(UserViewKaizens(title));
      },
    );
  }

  Widget _buildStatusMenuItem(String title, IconData icon, Widget target) {
    return UserStatusMenuItem(
      title: title,
      icon: icon,
      onTap: () {
        _navigateAndRefresh(target);
      },
    );
  }

  Widget _buildSafetySection(Map<String, dynamic> counts) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Safety Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _buildSafetyItem(
                  'Accident',
                  Icons.local_fire_department,
                  counts['accident'].toString(),
                  Colors.red.shade500,
                  UserAccidents(),
                ),
                const SizedBox(height: 12),
                _buildSafetyItem(
                  'Nearmiss',
                  Icons.warning_amber,
                  counts['nearmiss'].toString(),
                  Colors.green.shade500,
                  UserNearmiss(),
                ),
                const SizedBox(height: 12),
                _buildSafetyItem(
                  'Observation',
                  Icons.visibility,
                  counts['observation'].toString(),
                  Colors.purple.shade500,
                  UserObservationsList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyItem(
    String title,
    IconData icon,
    String count,
    Color color,
    Widget target,
  ) {
    return UserSafetyCategoryListItem(
      icon: icon,
      title: title,
      count: count,
      color: color,
      onTap: () {
        _navigateAndRefresh(target);
      },
    );
  }
}
