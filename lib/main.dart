import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kmsmerino/bindings/general_bindings.dart';
import 'package:kmsmerino/helper/route_helper.dart';
import 'package:kmsmerino/services/api/global_auth_interceptor.dart';
import 'package:kmsmerino/utils/app_constants.dart';
import 'package:kmsmerino/utils/app_theme.dart';
import 'package:kmsmerino/helper/get_di.dart' as di;

import 'package:kmsmerino/services/notification_service.dart';

Future<void> main() async {
  if (kDebugMode) {
    debugPrint("Main function called");
  }
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    debugPrint("WidgetsFlutterBinding.ensureInitialized completed");
  }

  try {
    await NotificationService().init();
    if (kDebugMode) {
      debugPrint("NotificationService initialized");
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint("Error initializing NotificationService: $e");
    }
  }

  // Preload fonts to avoid mid-frame loading issues
  try {
    await _preloadFonts();
    if (kDebugMode) {
      debugPrint("Fonts preloaded successfully");
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint("Error preloading fonts: $e");
    }
  }

  HttpOverrides.global = MyHttpOverrides();
  if (kDebugMode) {
    debugPrint("HttpOverrides set");
  }

  await di.init();
  if (kDebugMode) {
    debugPrint("Dependency injection completed");
  }

  runApp(const MyApp());
  if (kDebugMode) {
    debugPrint("MyApp started");
  }
}

Future<void> _preloadFonts() async {
  // Load font manifests to ensure they're ready before the app starts
  // This helps prevent font loading issues during runtime
  final fontLoader = FontLoader('Outfit');

  // Load all font variations we've declared
  try {
    final regularFont = await rootBundle.load(
      'assets/fonts/Outfit-Regular.ttf',
    );
    fontLoader.addFont(Future.value(regularFont));

    final boldFont = await rootBundle.load('assets/fonts/Outfit-Bold.ttf');
    fontLoader.addFont(Future.value(boldFont));

    final semiBoldFont = await rootBundle.load(
      'assets/fonts/Outfit-SemiBold.ttf',
    );
    fontLoader.addFont(Future.value(semiBoldFont));

    final mediumFont = await rootBundle.load('assets/fonts/Outfit-Medium.ttf');
    fontLoader.addFont(Future.value(mediumFont));

    final lightFont = await rootBundle.load('assets/fonts/Outfit-Light.ttf');
    fontLoader.addFont(Future.value(lightFont));

    final italicFont = await rootBundle.load('assets/fonts/Outfit-Thin.ttf');
    fontLoader.addFont(Future.value(italicFont));

    await fontLoader.load();
  } catch (e) {
    if (kDebugMode) {
      debugPrint("Font loading error: $e");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint("MyApp build method called");
    }
    return GetMaterialApp(
      title: AppConstants.APP_NAME,
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      theme: appTheme,
      // Remove the home property and use initialRoute instead
      initialRoute: RouteHelper.splash,
      getPages: RouteHelper.routes,
      defaultTransition: Transition.topLevel,
      initialBinding: GeneralBindings(),
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return GlobalAuthInterceptorHttpClient(client);
  }
}

class _OriginalHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return GlobalAuthInterceptorHttpClient(client);
  }
}



