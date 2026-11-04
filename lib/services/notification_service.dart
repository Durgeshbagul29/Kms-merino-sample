import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kmsmerino/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kmsmerino/controller/auth_controller.dart';
import 'package:kmsmerino/views/screens/admin/accident/admin_accidentdetails.dart';
import 'package:kmsmerino/views/common/ethics/ethics_screen.dart';
import 'package:kmsmerino/views/screens/admin/kaizens/admin_kaizendetails.dart';
import 'package:kmsmerino/views/screens/admin/nearmiss/admin_nearmissdetails.dart';
import 'package:kmsmerino/views/screens/admin/notifications/bn_details.dart';
import 'package:kmsmerino/views/screens/auth/home_page.dart';
import 'package:kmsmerino/views/screens/admin/observation/admin_obsdetails.dart';
import 'package:kmsmerino/views/screens/user/accident/user_accidentdetails.dart';
import 'package:kmsmerino/views/screens/user/kaizens/user_kaizendetails.dart';
import 'package:kmsmerino/views/screens/user/nearmiss/user_nearmissdetails.dart';
import 'package:kmsmerino/views/screens/user/notifications/user_bndetails.dart';
import 'package:kmsmerino/views/screens/user/observation/user_obsdetails.dart';
import 'package:kmsmerino/views/screens/manager/kaizen/manager_kaizendetails.dart';
import 'package:kmsmerino/views/screens/manager/accident/manager_accidentdetails.dart';
import 'package:kmsmerino/views/screens/manager/nearmiss/manager_nearmissdetails.dart';
import 'package:kmsmerino/views/screens/manager/observation/manager_obsdetails.dart';
import 'package:kmsmerino/views/screens/manager/notifications/manager_bn_details.dart';
import 'package:kmsmerino/views/screens/director/kaizen/director_kaizendetails.dart';
import 'package:kmsmerino/views/screens/director/accident/director_accidentdetails.dart';
import 'package:kmsmerino/views/screens/director/nearmiss/director_nearmissdetails.dart';
import 'package:kmsmerino/views/screens/director/observation/director_obsdetails.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    debugPrint("Handling background FCM message ID: ${message.messageId}");
    debugPrint("Background message data: ${message.data}");

    // If it's a data-only message (no notification object), FCM won't show a system tray alert automatically.
    // So we manually display it using local notifications.
    if (message.notification == null && message.data.isNotEmpty) {
      await NotificationService().initLocalNotificationsOnly();
      await NotificationService().showLocalNotification(message);
    }
  } catch (e) {
    debugPrint("Error in background handler: $e");
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isLocalNotificationsInitialized = false;

  /// Main initialization called in main.dart
  Future<void> init() async {
    // 1. Initialize Firebase
    try {
      await Firebase.initializeApp();
      debugPrint("✅ Firebase Initialized successfully");
    } catch (e) {
      debugPrint("❌ Firebase initialization error: $e");
    }

    // 2. Initialize Flutter Local Notifications Plugin & Notification Channel
    await initLocalNotificationsOnly();

    // 3. Request permissions (Firebase Messaging + Android 13+ POST_NOTIFICATIONS)
    await _requestPermissions();

    // 4. Background message handler
    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      debugPrint("Error registering onBackgroundMessage: $e");
    }

    // 5. Configure foreground presentation options (for iOS / heads-up)
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (e) {
      debugPrint("Error setting foreground presentation options: $e");
    }

    // 6. Listen for incoming foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("🔔 [FCM FOREGROUND MESSAGE RECEIVED]");
      debugPrint("Message ID: ${message.messageId}");
      debugPrint("Notification: ${message.notification?.title} | ${message.notification?.body}");
      debugPrint("Data: ${message.data}");

      showLocalNotification(message);
    });

    // 7. Fetch and print FCM Token
    await getAndPrintFcmToken();

    // 8. Listen for FCM Token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) async {
      debugPrint("====================================================");
      debugPrint("🔥 [FCM TOKEN REFRESHED]: $newToken");
      // ignore: avoid_print
      print("🔥 [FCM TOKEN REFRESHED]: $newToken");
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.DEVICE_TOKEN, newToken);
        if (prefs.containsKey(AppConstants.TOKEN)) {
          if (Get.isRegistered<AuthController>()) {
            Get.find<AuthController>().registerDeviceToken();
          }
        }
      } catch (e) {
        debugPrint("Error updating refreshed token: $e");
      }
    });

    // 9. When app is in BACKGROUND and user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification tapped (background): ${message.data}");
      _handleNotificationTap(message);
    });

    // 10. When app was TERMINATED and opened via notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint("Notification opened from terminated state: ${message.data}");
        _handleNotificationTap(message);
      }
    });
  }

  /// Initialize local notifications plugin and create high importance channel
  Future<void> initLocalNotificationsOnly() async {
    if (_isLocalNotificationsInitialized) return;

    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/icon');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      await flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint("Notification clicked with payload: ${response.payload}");
          if (response.payload != null && response.payload!.isNotEmpty) {
            try {
              Map<String, dynamic> data = jsonDecode(response.payload!);
              _handleNotificationTapFromPayload(data);
            } catch (e) {
              debugPrint("Error decoding JSON payload: $e");
            }
          } else {
            Get.toNamed('/');
          }
        },
      );

      // Create Android Notification Channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      _isLocalNotificationsInitialized = true;
      debugPrint("✅ Local notifications initialized successfully");
    } catch (e) {
      debugPrint("❌ Flutter local notifications initialization error: $e");
    }
  }

  /// Request runtime permissions for both Firebase Messaging and Android 13+
  Future<void> _requestPermissions() async {
    try {
      // 1. Firebase Messaging permission (iOS / Web / general)
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint('🔔 FCM Permission status: ${settings.authorizationStatus}');

      // 2. Android 13+ (API level 33+) POST_NOTIFICATIONS permission
      if (Platform.isAndroid) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();
        final bool? granted =
            await androidImplementation?.requestNotificationsPermission();
        debugPrint('🔔 Android 13+ notification permission granted: $granted');
      }
    } catch (e) {
      debugPrint('❌ Error requesting notification permissions: $e');
    }
  }

  /// Fetches, saves, and prints the current FCM Device Token
  Future<String?> getAndPrintFcmToken() async {
    try {
      final String? token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.DEVICE_TOKEN, token);

        // Prominently print token to console
        debugPrint('');
        debugPrint('================================================================');
        debugPrint('🔥 [FCM TOKEN]: $token');
        debugPrint('================================================================');
        // ignore: avoid_print
        print('🔥 [FCM TOKEN]: $token');

        // If user already logged in, sync token to backend
        if (prefs.containsKey(AppConstants.TOKEN)) {
          if (Get.isRegistered<AuthController>()) {
            Get.find<AuthController>().registerDeviceToken();
          }
        }
      } else {
        debugPrint('⚠️ [FCM TOKEN]: Token returned null or empty');
      }
      return token;
    } catch (e) {
      debugPrint('❌ [FCM TOKEN ERROR]: Failed to get FCM token: $e');
      return null;
    }
  }

  /// Display a local notification from RemoteMessage (Foreground or Data-only background)
  Future<void> showLocalNotification(RemoteMessage message) async {
    try {
      debugPrint("📥 Displaying local notification. Data: ${message.data}");

      // Extract title and body from notification OR data payload
      String? title = message.notification?.title;
      String? body = message.notification?.body;

      if (title == null || title.isEmpty) {
        title = message.data['title']?.toString() ??
            message.data['subject']?.toString();
      }
      if (body == null || body.isEmpty) {
        body = message.data['body']?.toString() ??
            message.data['message']?.toString() ??
            message.data['description']?.toString();
      }

      // If both are still missing, provide a generic fallback if there's any data
      if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
        if (message.data.isNotEmpty) {
          title = "Merino KMS";
          body = "You have a new notification";
        } else {
          debugPrint("⚠️ Skipping local notification: No title/body or data found.");
          return;
        }
      }

      final String? type = message.data['type']?.toString();
      final bool isBroadcast = (type == 'broadcast');

      // Check for image URL in data or notification
      final String? imageUrl = message.data['image']?.toString() ??
          message.notification?.android?.imageUrl;

      debugPrint("Notification type: $type | Image: $imageUrl | Title: $title | Body: $body");

      AndroidNotificationDetails androidDetails;

      if (isBroadcast && imageUrl != null && imageUrl.isNotEmpty) {
        try {
          final File imageFile = await _downloadImageToTemp(imageUrl);
          final FilePathAndroidBitmap bigPicture =
              FilePathAndroidBitmap(imageFile.path);

          androidDetails = AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/icon',
            channelShowBadge: true,
            enableLights: true,
            enableVibration: true,
            playSound: true,
            visibility: NotificationVisibility.public,
            styleInformation: BigPictureStyleInformation(
              bigPicture,
              largeIcon: bigPicture,
              contentTitle: title,
              summaryText: body,
              hideExpandedLargeIcon: false,
            ),
          );
          debugPrint("Showing broadcast notification with big picture");
        } catch (e) {
          debugPrint("Failed to download image for notification: $e");
          androidDetails = _defaultAndroidDetails();
        }
      } else {
        androidDetails = _defaultAndroidDetails();
      }

      int notificationId = message.messageId.hashCode;
      if (notificationId == 0) {
        notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      }

      await flutterLocalNotificationsPlugin.show(
        id: notificationId,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: androidDetails,
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );

      debugPrint("✅ Local notification successfully displayed: $title - $body");
    } catch (e) {
      debugPrint("❌ Error showing local notification: $e");
    }
  }

  AndroidNotificationDetails _defaultAndroidDetails() {
    return const AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/icon',
      channelShowBadge: true,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      visibility: NotificationVisibility.public,
    );
  }

  Future<File> _downloadImageToTemp(String imageUrl) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String fileName =
        'notif_img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String filePath = '${tempDir.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(imageUrl));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    debugPrint("Image downloaded to: $filePath");
    return file;
  }

  void _handleNotificationTap(RemoteMessage message) {
    _handleNotificationTapFromPayload(message.data);
  }

  Future<void> _handleNotificationTapFromPayload(Map<String, dynamic> data) async {
    try {
      if (data.isEmpty) return;

      debugPrint("🔔 [NOTIFICATION TAP] Payload received: $data");

      int? roleId;
      try {
        if (Get.isRegistered<AuthController>()) {
          roleId = Get.find<AuthController>().getRoleId();
        }
        if (roleId == null) {
          final prefs = await SharedPreferences.getInstance();
          roleId = prefs.getInt(AppConstants.ROLE_ID);
        }
      } catch (e) {
        debugPrint("Error determining roleId: $e");
      }

      final String type = (data['type']?.toString() ?? '').toLowerCase().trim();
      final String? kaizenId = data['kaizen_id']?.toString() ?? data['kaizenId']?.toString();
      final String? accidentId = data['accident_id']?.toString() ?? data['accidentId']?.toString();
      final String? nearmissId = data['nearmiss_id']?.toString() ?? data['nearmissId']?.toString();
      final String? observationId = data['observation_id']?.toString() ?? data['observationId']?.toString();
      final String? broadcastId = data['broadcast_id']?.toString() ?? data['broadcastId']?.toString();
      final String? complaintId = data['complaint_id']?.toString() ?? data['complaintId']?.toString();
      final String? generalId = data['id']?.toString() ?? data['record_id']?.toString();

      debugPrint("🔍 Routing check -> type: '$type', roleId: $roleId (1=Admin, 2=HR, 3=User, 4=Director, 5=Manager)");

      // 1. KAIZEN (e.g. kaizen, kaizen_review, kaizen_ready_for_verification, etc.)
      if (type.contains('kaizen') || kaizenId != null) {
        final int id = int.tryParse(kaizenId ?? generalId ?? '') ?? 0;
        debugPrint("Navigating to Kaizen details screen for id: $id, role: $roleId");
        if (roleId == 1) {
          Get.to(() => AdminKaizenDetails(id, const HomePage()));
        } else if (roleId == 5) {
          Get.to(() => ManagerKaizenDetails(id, const HomePage()));
        } else if (roleId == 4) {
          Get.to(() => DirectorKaizenDetails(id, const HomePage()));
        } else {
          // Role 3 (User), Role 2 (HR), or default
          Get.to(() => UserKaizenDetails(id, const HomePage()));
        }
        return;
      }

      // 2. ACCIDENT (e.g. accident, accident_review, etc.)
      if (type.contains('accident') || accidentId != null) {
        final int id = int.tryParse(accidentId ?? generalId ?? '') ?? 0;
        debugPrint("Navigating to Accident details screen for id: $id, role: $roleId");
        if (roleId == 1) {
          Get.to(() => AdminAccidentDetails(id));
        } else if (roleId == 5) {
          Get.to(() => ManagerAccidentDetails(id));
        } else if (roleId == 4) {
          Get.to(() => DirectorAccidentDetails(id));
        } else {
          Get.to(() => UserAccidentDetails(id, const HomePage()));
        }
        return;
      }

      // 3. NEARMISS (e.g. nearmiss, nearmiss_review, etc.)
      if (type.contains('nearmiss') || nearmissId != null) {
        final int id = int.tryParse(nearmissId ?? generalId ?? '') ?? 0;
        debugPrint("Navigating to Nearmiss details screen for id: $id, role: $roleId");
        if (roleId == 1) {
          Get.to(() => AdminNearmissDetails(id));
        } else if (roleId == 5) {
          Get.to(() => ManagerNearmissDetails(id));
        } else if (roleId == 4) {
          Get.to(() => DirectorNearmissDetails(id));
        } else {
          Get.to(() => UserNearmissDetails(id, const HomePage()));
        }
        return;
      }

      // 4. OBSERVATION (e.g. observation, observation_review, etc.)
      if (type.contains('observation') || observationId != null) {
        final int id = int.tryParse(observationId ?? generalId ?? '') ?? 0;
        debugPrint("Navigating to Observation details screen for id: $id, role: $roleId");
        if (roleId == 1) {
          Get.to(() => AdminObservationDetails(id));
        } else if (roleId == 5) {
          Get.to(() => ManagerObservationDetails(id));
        } else if (roleId == 4) {
          Get.to(() => DirectorObservationDetails(id));
        } else {
          Get.to(() => UserObservationDetails(id, const HomePage()));
        }
        return;
      }

      // 5. BROADCAST / ANNOUNCEMENTS
      if (type.contains('broadcast') || broadcastId != null) {
        final int id = int.tryParse(broadcastId ?? generalId ?? '') ?? 0;
        debugPrint("Navigating to Broadcast details screen for id: $id, role: $roleId");
        if (roleId == 1 || roleId == 4) {
          Get.to(() => BNDetails(id));
        } else if (roleId == 5) {
          Get.to(() => ManagerBNDetails(id));
        } else {
          Get.to(() => UserBNDetails(id, const HomePage()));
        }
        return;
      }

      // 6. COMPLAINT / ETHICS
      if (type.contains('complaint') || type.contains('ethics') || complaintId != null) {
        debugPrint("Navigating to EthicsScreen");
        Get.to(() => const EthicsScreen());
        return;
      }

      // Fallback
      debugPrint("⚠️ Unmatched notification type: '$type'. Navigating to HomePage.");
      Get.to(() => const HomePage());
    } catch (e) {
      debugPrint("❌ Error handling notification tap: $e");
    }
  }
}
