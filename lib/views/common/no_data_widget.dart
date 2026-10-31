// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final double iconSize;
  final Color? iconColor;

  const NoDataWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconSize = 40.0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final displayIconColor = iconColor ?? primaryColor.withValues(alpha: 0.7);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: iconSize, color: displayIconColor),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
