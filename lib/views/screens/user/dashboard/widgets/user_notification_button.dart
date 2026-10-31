import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/user/notifications/user_notifications.dart';

class UserNotificationButton extends StatelessWidget {
  final dynamic response;
  final Future<void> Function(Widget) navigateAndRefresh;

  const UserNotificationButton({
    super.key,
    required this.response,
    required this.navigateAndRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (response == null ||
        response['records'] == null ||
        response['records']['data'] == null) {
      return IconButton(
        icon: const Icon(Icons.notifications),
        color: Colors.white,
        onPressed: () {
          navigateAndRefresh(const UserNotification());
        },
      );
    }

    final int notfCount = response['records']['data']['notf_count'] ?? 0;

    if (notfCount > 0) {
      return Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              navigateAndRefresh(const UserNotification());
            },
          ),
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
                notfCount > 9 ? '9+' : notfCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.notifications),
        color: Colors.white,
        onPressed: () {
          navigateAndRefresh(const UserNotification());
        },
      );
    }
  }
}
