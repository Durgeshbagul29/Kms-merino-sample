import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kmsmerino/views/base/no_internet_screen.dart';

/// ---------------------------------------------------------------------------
/// NetworkManager
/// ---------------------------------------------------------------------------
/// Manages network connectivity status in the app.
/// - Monitors real-time connection changes.
/// - Displays warning popup when the connection is lost.
/// - Provides a method to manually check connection status.
/// ---------------------------------------------------------------------------
class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final result = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;
      _updateConnectionStatus(result);
    });
  }

  /// Handles connectivity updates and user feedback
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus.value = result;

    if (result == ConnectivityResult.none) {
      // Option 1: Show a snack bar for minor interruptions
      // AppLoaders.warningSnackBar(
      //   title: 'No Internet Connection',
      //   message:
      //   'You™re offline. Please check your Wi-Fi or mobile data and try again.',
      // );

      // Option 2: Navigate to dedicated no internet screen
      Future.delayed(const Duration(milliseconds: 300), () {
        if (Get.currentRoute != '/NoInternetScreen') {
          Get.to(
            () => NoInternetScreen(
              onRetry: () async {
                final connected = await isConnected();
                if (connected) {
                  Get.back(); // Dismiss the no internet screen
                } else {
                  // Get.snackbar(
                  // title: 'Still Offline',
                  // message:
                  // 'Unable to reconnect. Please verify your internet settings.',
                  // );
                }
              },
            ),
          );
        }
      });
    } else {
      // Optional: Show success message when connection is restored
      if (Get.currentRoute == '/NoInternetScreen') {
        Get.back(); // Automatically dismiss the offline screen
        Get.snackbar('Back Online', 'Your connection has been restored.');
      }
    }
  }

  /// Manually checks if the device has an active internet connection
  Future<bool> isConnected() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.isNotEmpty && results.first != ConnectivityResult.none;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Check connectivity before API call and show error if offline
  Future<bool> checkConnectivityAndShowError() async {
    final connected = await isConnected();
    if (!connected) {
      Get.snackbar(
        'No Internet Connection',
        'Please check your internet connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color.fromARGB(255, 249, 43, 43),
        colorText: Color(0xFFFFFFFF),
      );
    }
    return connected;
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
