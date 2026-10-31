import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'director_dashboard.dart';
import 'package:kmsmerino/views/common/common_profile_screen.dart';
import 'reports/director_reports.dart';

class DirectorBottomNavigation extends StatefulWidget {
  const DirectorBottomNavigation({super.key});

  @override
  State<DirectorBottomNavigation> createState() =>
      _DirectorBottomNavigationState();
}

class _DirectorBottomNavigationState extends State<DirectorBottomNavigation> {
  int _currentIndex = 0;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  void _loadPages() {
    _pages = [
      DirectorDashboard(),
      DirectorReports(),
      CommonProfileScreen(role: 'Director', title: 'Director Profile'),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Color.fromARGB(255, 241, 241, 241),
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
            return;
          } else {
            final exit = await showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  'Exit App',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text('Do you really want to exit the application?'),
                actions: [
                  TextButton(
                    child: Text('No', style: TextStyle(color: Colors.grey)),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Yes', style: TextStyle(color: Colors.white)),
                    onPressed: () => SystemChannels.platform.invokeMethod(
                      'SystemNavigator.pop',
                    ),
                  ),
                ],
              ),
            );
            if (exit == true) {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }
          }
        },
        child: Scaffold(
          body: _pages[_currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              elevation: 0,
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  activeIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart),
                  label: 'Reports',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outlined),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
