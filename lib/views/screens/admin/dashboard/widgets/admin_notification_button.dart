import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/admin/notifications/notitication.dart';

class AdminNotificationButton extends StatelessWidget {
  final Map<String, dynamic>? dashboardData;
  final VoidCallback onRefresh;

  const AdminNotificationButton({
    super.key,
    required this.dashboardData,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    int notificationCount = 0;

    try {
      if (dashboardData != null && dashboardData!['data'] != null) {
        var data = dashboardData!['data'];
        notificationCount =
            int.tryParse(data['notification_count']?.toString() ?? "0") ?? 0;
      }
    } catch (e) {
      debugPrint("Error extracting notification count: $e");
    }

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminNotification(),
              ),
            ).then((_) => onRefresh());
          },
        ),
        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                notificationCount > 9 ? '9+' : notificationCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
