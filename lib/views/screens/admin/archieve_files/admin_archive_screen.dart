// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/admin/archieve_files/accident_files.dart';
import 'package:kmsmerino/views/screens/admin/archieve_files/kaizen_files.dart';
import 'package:kmsmerino/views/screens/admin/archieve_files/nearmiss_files.dart';
import 'package:kmsmerino/views/screens/admin/archieve_files/observation_files.dart';
import 'package:kmsmerino/views/screens/admin/archieve_files/ethics_files.dart';

class AdminArchiveScreen extends StatefulWidget {
  const AdminArchiveScreen({super.key});

  @override
  State<AdminArchiveScreen> createState() => _AdminArchiveScreenState();
}

class _AdminArchiveScreenState extends State<AdminArchiveScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: dashboardWidget(),
    );
  }

  Widget dashboardWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Archive Files",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [SizedBox(height: 10), _buildArchiveFilesGrid()],
        ),
      ),
    );
  }

  Widget _buildArchiveFilesGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildListArchiveItem(
            icon: Icons.list_alt,
            label: "Kaizen List",
            color: Colors.green,
            subtitle: "Views all archieve kaizens",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KaizenArchieve()),
              );
            },
          ),
          SizedBox(height: 12),
          _buildListArchiveItem(
            icon: Icons.assignment,
            label: "Accident List",
            color: Colors.redAccent,
            subtitle: "Views all archieve accidents",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccidentArchieve()),
              );
            },
          ),
          SizedBox(height: 12),
          _buildListArchiveItem(
            icon: Icons.task,
            label: "Near Miss List",
            color: Colors.orange,
            subtitle: "Views all archieve near misses",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NearmissArchieve()),
              );
            },
          ),
          SizedBox(height: 12),
          _buildListArchiveItem(
            icon: Icons.preview,
            label: "Observation List",
            color: Colors.purple,
            subtitle: "Views all archieve observations",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ObservationArchieve()),
              );
            },
          ),
          SizedBox(height: 12),
          _buildListArchiveItem(
            icon: Icons.gavel,
            label: "Ethics List",
            color: Colors.blue,
            subtitle: "Views all archieve ethics",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EthicsArchieve()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListArchiveItem({
    required IconData icon,
    required String label,
    required Color color,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
