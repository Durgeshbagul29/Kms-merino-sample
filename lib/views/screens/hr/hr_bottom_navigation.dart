import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/hr/hr_dashboard.dart';
import 'package:kmsmerino/views/screens/hr/add_new_useradmin.dart';
import 'package:kmsmerino/views/screens/hr/add_new_director.dart';
import 'package:flutter/services.dart';
import 'package:kmsmerino/views/common/common_profile_screen.dart';

class HrBottomNavigation extends StatefulWidget {
  const HrBottomNavigation({super.key});

  @override
  State<HrBottomNavigation> createState() => _HrBottomNavigationState();
}

class _HrBottomNavigationState extends State<HrBottomNavigation> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Color.fromARGB(255, 241, 241, 241),
      ),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HrDashboard(),
            _currentIndex == 1 ? AddNewUser() : const SizedBox.shrink(),
            _currentIndex == 2 ? AddNewDirector() : const SizedBox.shrink(),
            CommonProfileScreen(role: 'HR', title: 'HR Profile'),
          ],
        ),
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
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_add_alt_1_outlined),
                activeIcon: Icon(Icons.person_add_alt_1),
                label: 'Add Member',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business_center_outlined),
                activeIcon: Icon(Icons.business_center),
                label: 'Add Director',
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
    );
  }
}
