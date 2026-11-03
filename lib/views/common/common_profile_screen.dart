// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../utils/app_constants.dart';
import '../../services/api/api_client.dart';
import '../../services/api/api_config.dart';
import '../screens/auth/login.dart';
import '../screens/auth/loggedin_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_app_screen.dart';

class CommonProfileScreen extends StatefulWidget {
  final String role;
  final String? title;
  final String? adminName;
  final String? userEmail;
  final String? userDept;
  final int? userId;
  final int? userRole;

  const CommonProfileScreen({
    super.key,
    required this.role,
    this.title,
    this.adminName,
    this.userEmail,
    this.userDept,
    this.userId,
    this.userRole,
  });

  @override
  State<CommonProfileScreen> createState() => _CommonProfileScreenState();
}

class _CommonProfileScreenState extends State<CommonProfileScreen> {
  String _userName = '';
  String _userEmail = '';
  String _userDept = '';
  List<String> _userDepartments = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    try {
      ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.getData(ApiConfig.getProfileEndpoint);
      if (response.statusCode == 200 && response.body != null) {
        var responsebody = response.body is String
            ? json.decode(response.body)
            : response.body;
        if (responsebody['success'] == true && responsebody['data'] != null) {
          var profileData = responsebody['data'];
          setState(() {
            _userName = profileData['name'] ?? 'User Name';
            _userEmail = profileData['email'] ?? '';
            List<dynamic>? departmentsArray = profileData['departments'];
            if (departmentsArray != null && departmentsArray.isNotEmpty) {
              _userDepartments = departmentsArray
                  .map((dept) => dept['name'] as String)
                  .toList();
              _userDept = _userDepartments.join(', ');
            } else {
              _userDept = profileData['department'] ?? 'Department';
              _userDepartments = [_userDept];
            }
            _isLoading = false;
          });
          return;
        }
      }
      _loadUserDataFallback();
    } catch (e) {
      _loadUserDataFallback();
    }
  }

  Future<void> _loadUserDataFallback() async {
    try {
      if (widget.adminName != null && widget.adminName!.isNotEmpty) {
        setState(() {
          _userName = widget.adminName!;
          _userEmail = widget.userEmail ?? '';
          _userDept = widget.userDept ?? 'Department';
          _userDepartments = widget.userDept != null
              ? [widget.userDept!]
              : ['Department'];
          _isLoading = false;
        });
        return;
      }
      final name = await LoggedInUser.getName();
      final email = await LoggedInUser.getEmail();
      final dept = await LoggedInUser.getDeptName();
      setState(() {
        _userName = name.isNotEmpty ? name : 'User Name';
        _userEmail = email.isNotEmpty ? email : 'user@company.com';
        _userDept = dept.isNotEmpty ? dept : 'Department';
        _userDepartments = dept.isNotEmpty ? [dept] : ['Department'];
        _isLoading = false;
      });
    } catch (e) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final name = prefs.getString(AppConstants.NAME) ?? 'User Name';
        final email = prefs.getString(AppConstants.EMAIL) ?? '';
        final dept = prefs.getString(AppConstants.DEPT_NAME) ?? 'Department';
        setState(() {
          _userName = name;
          _userEmail = email;
          _userDept = dept;
          _userDepartments = dept.isNotEmpty ? [dept] : ['Department'];
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            content: Row(
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Logging out...',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          );
        },
      );

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? deviceToken = preferences.getString(AppConstants.DEVICE_TOKEN);

      ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.getData(
        ApiConfig.logoutUrl(deviceToken),
      );

      if (response.statusCode == 200 && response.body != null) {
        var responsebody = response.body is String
            ? json.decode(response.body)
            : response.body;
        if (responsebody['success'] == true) {
          Navigator.pop(context);
          await preferences.remove(AppConstants.TOKEN);
          await preferences.remove(AppConstants.NAME);
          await preferences.remove(AppConstants.EMAIL);
          await preferences.remove(AppConstants.USER_ID);
          await preferences.remove(AppConstants.ROLE_ID);
          await preferences.remove(AppConstants.DEPT_NAME);
          await preferences.remove(AppConstants.DEVICE_TOKEN);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
            (route) => false,
          );
          return;
        }
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed. Please try again.'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      if (Navigator.canPop(context)) Navigator.pop(context);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove(AppConstants.TOKEN);
      await preferences.remove(AppConstants.NAME);
      await preferences.remove(AppConstants.EMAIL);
      await preferences.remove(AppConstants.USER_ID);
      await preferences.remove(AppConstants.ROLE_ID);
      await preferences.remove(AppConstants.DEPT_NAME);
      await preferences.remove(AppConstants.DEVICE_TOKEN);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final String displayName = widget.title ?? '${widget.role} Profile';

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        appBar: _buildAppBar(displayName, primary),
        body: Center(
          child: CircularProgressIndicator(color: primary, strokeWidth: 2.5),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: _buildAppBar(displayName, primary),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Header ──────────────────────────────────
            _buildProfileHeader(primary),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Account Section ──────────────────────────
                  _sectionLabel('Account'),
                  const SizedBox(height: 8),
                  _buildMenuCard([
                    _menuItem(
                      icon: Icons.manage_accounts_outlined,
                      iconColor: primary,
                      label: 'Account Settings',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Account settings coming soon'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      isLast: false,
                    ),
                    _menuItem(
                      icon: Icons.lock_outline_rounded,
                      iconColor: Colors.green.shade600,
                      label: 'Security',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Security settings coming soon'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      isLast: true,
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // ── Support Section ──────────────────────────
                  _sectionLabel('Support'),
                  const SizedBox(height: 8),
                  _buildMenuCard([
                    _menuItem(
                      icon: Icons.help_outline_rounded,
                      iconColor: Colors.deepPurple.shade400,
                      label: 'Help & Support',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Help & support coming soon'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      isLast: false,
                    ),
                    _menuItem(
                      icon: Icons.info_outline_rounded,
                      iconColor: Colors.orange.shade600,
                      label: 'About App',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutAppScreen(),
                          ),
                        );
                      },
                      isLast: true,
                    ),
                  ]),

                  const SizedBox(height: 28),

                  // ── Logout Button ────────────────────────────
                  _buildLogoutButton(),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String title, Color primary) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
      backgroundColor: primary,
      automaticallyImplyLeading: false,
      elevation: 0,
    );
  }

  Widget _buildProfileHeader(Color primary) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Row(
        children: [
          // Avatar with person icon
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                size: 34,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  _userEmail,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_userDepartments.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: _userDepartments.map((dept) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          dept,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.95),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade500,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: items),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
    required bool isLast,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                )
              : BorderRadius.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            indent: 60,
            endIndent: 14,
            color: Colors.grey.shade100,
          ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _logout,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red.shade600,
          side: BorderSide(color: Colors.red.shade200, width: 1.2),
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.red.shade50,
        ),
        icon: Icon(Icons.logout_rounded, size: 18, color: Colors.red.shade600),
        label: Text(
          'Sign Out',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.red.shade600,
          ),
        ),
      ),
    );
  }
}
