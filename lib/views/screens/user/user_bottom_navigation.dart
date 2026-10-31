import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kmsmerino/views/screens/user/dashboard/user_dashboard.dart';
import 'package:kmsmerino/views/common/common_profile_screen.dart';
import 'package:kmsmerino/views/screens/user/ethics/user_ethics_screen.dart';

class UserBottomNavigation extends StatefulWidget {
  final int initialIndex;
  const UserBottomNavigation({super.key, this.initialIndex = 0});

  static UserBottomNavigationState? of(BuildContext context) {
    return context.findAncestorStateOfType<UserBottomNavigationState>();
  }

  @override
  State<UserBottomNavigation> createState() => UserBottomNavigationState();
}

class UserBottomNavigationState extends State<UserBottomNavigation> {
  int _currentIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _loadPages();
  }

  void _loadPages() {
    _pages = [
      const UserDashboard(),
      const Complaints(),
      CommonProfileScreen(role: 'User', title: 'User Profile'),
    ];
  }

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
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
                title: const Text(
                  'Exit App',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Text(
                  'Do you really want to exit the application?',
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.white),
                    ),
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
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
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
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.home_2),
                  activeIcon: Icon(Iconsax.home_15),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.gavel_outlined),
                  activeIcon: Icon(Icons.gavel),
                  label: 'Ethics',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
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
