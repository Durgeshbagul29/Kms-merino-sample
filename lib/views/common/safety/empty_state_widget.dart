// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String heading;
  final String subHeading;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;

  const EmptyStateWidget({
    super.key,
    required this.heading,
    required this.subHeading,
    this.icon = Icons.info_outline,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final iconClr = iconColor ?? primaryColor;
    final bgClr = backgroundColor ?? primaryColor.withValues(alpha: 0.1);

    return Center(
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: bgClr,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 40,
                  color: iconClr,
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              heading,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              subHeading,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
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