// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class KaizenNoDataWidget extends StatelessWidget {
  final String type;
  final VoidCallback? onAddPressed;

  const KaizenNoDataWidget({
    super.key,
    required this.type,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 80,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
            ),
            SizedBox(height: 24),
            Text(
              'No $type Kaizens Found',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'There are no kaizens in the ${type.toLowerCase()} category yet.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
           ],
        ),
      ),
    );
  }
}