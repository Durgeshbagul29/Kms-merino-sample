import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kmsmerino/views/screens/auth/home_page.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/screens/auth/login.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async'; // For StreamSubscription

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool connectedToWifi = false;
  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool updateChecked = false; // prevent multiple calls

  @override
  void initState() {
    super.initState();
    debugPrint("Authenticate initState called");
    _checkFirstConnection();
    _listenConnectionChanges();
    _checkForUpdateOnce();
    debugPrint("Authenticate initState completed");
  }

  /// Check first-time internet status
  Future<void> _checkFirstConnection() async {
    final result = await Connectivity().checkConnectivity();
    debugPrint("Authenticate connectivity result: $result");
    connectedToWifi = !result.contains(ConnectivityResult.none);
    setState(() {});
  }

  /// Realtime network listener
  void _listenConnectionChanges() {
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      debugPrint("Authenticate connectivity changed: $result");
      setState(() {
        connectedToWifi = !result.contains(ConnectivityResult.none);
      });
    });
  }

  /// Run update check only once
  void _checkForUpdateOnce() async {
    if (updateChecked) return;
    updateChecked = true;

    NewVersionPlus newVersion = NewVersionPlus();
    final status = await newVersion.getVersionStatus();

    if (status != null && status.canUpdate && mounted) {
      _showUpdateDialog(status);
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: LoggedInUser.getLoggedInStatus(),
      builder: (context, snapshot) {
        if (!connectedToWifi) {
          return _noInternetWidget();
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: errorWidgetDesign(context, snapshot.error.toString()),
          );
        }

        return snapshot.data == true ? const HomePage() : const Login();
      },
    );
  }

  /// No internet UI
  Widget _noInternetWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 150, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            const Text(
              "No Internet Connection",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text("Please turn on your internet."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkFirstConnection,
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  /// Show update dialog
  Future<void> _showUpdateDialog(VersionStatus status) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Update Available"),
        content: Text(
          "Update the app from ${status.localVersion} to ${status.storeVersion}.",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await launchUrl(Uri.parse(status.appStoreLink));
            },
            child: const Text("Update"),
          ),
          TextButton(
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: const Text("Close", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
