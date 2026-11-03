import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kmsmerino/services/api/api_client.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kmsmerino/models/response_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthController extends GetxController implements GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthController({required this.apiClient, required this.sharedPreferences});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<ResponseModel> login(String username, String password) async {
    _isLoading = true;
    update();

    Response response = await apiClient.postData(ApiConfig.loginEndpoint, {
      "email": username,
      "password": password,
    });

    ResponseModel responseModel;
    if (response.statusCode == 200) {
      debugPrint(response.body.toString());
      debugPrint(response.body['data']['token']);

      apiClient.updateHeader(response.body['data']['token']);

      // Save user data using the saveUserData method
      await saveUserData(response.body['data'], response.body['data']['token']);
      responseModel = ResponseModel(true, 'Login successful');

      // Register device token in background
      registerDeviceToken();
    } else {
      // Handle error response with professional, user-friendly messages
      String errorMessage = 'Unable to sign in. Please try again.';

      // Extract server error details if available
      String serverMessage = '';
      if (response.body is Map) {
        if (response.body['data'] is Map && response.body['data']['error'] != null) {
          serverMessage = response.body['data']['error'].toString().trim();
        } else if (response.body['error'] != null) {
          serverMessage = response.body['error'].toString().trim();
        } else if (response.body['message'] != null) {
          serverMessage = response.body['message'].toString().trim();
        }
      }

      final String combinedText = '$serverMessage ${response.statusText ?? ''} ${response.bodyString ?? ''}'.toLowerCase();

      // Check specific scenarios and map to clear, professional messages
      if (response.statusCode == 401 ||
          combinedText.contains('unauthori') ||
          combinedText.contains('invalid credentials') ||
          combinedText.contains('user not found') ||
          combinedText.contains('account not found') ||
          combinedText.contains('credential')) {
        errorMessage = 'Account not found or invalid credentials. Please check your username/email and password.';
      } else if (response.statusCode == 404) {
        errorMessage = 'Account not found. Please verify your username or email address.';
      } else if (response.statusCode == 403 ||
          combinedText.contains('deactivated') ||
          combinedText.contains('inactive') ||
          combinedText.contains('disabled') ||
          combinedText.contains('blocked')) {
        errorMessage = 'Account deactivated. Please contact your administrator for assistance.';
      } else if (response.statusCode == 429) {
        errorMessage = 'Too many attempts. Please wait a minute and try again.';
      } else if (response.statusText == ApiClient.noInternetMessage ||
          response.statusCode == 503 ||
          response.statusCode == 504) {
        errorMessage = 'Network connection error. Please check your internet connection.';
      } else if (serverMessage.isNotEmpty &&
          !combinedText.contains('unauthori') &&
          !combinedText.contains('exception') &&
          !combinedText.contains('internal server error')) {
        errorMessage = serverMessage;
      } else {
        errorMessage = 'Unable to sign in. Please check your credentials and try again.';
      }

      // Hard safeguard: never let any "unauthorised" variation reach the user
      if (errorMessage.toLowerCase().contains('unauthori')) {
        errorMessage = 'Account not found or invalid credentials. Please check your username/email and password.';
      }

      responseModel = ResponseModel(false, errorMessage);
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> registerDeviceToken() async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null && fcmToken.isNotEmpty) {
        debugPrint('🔥 [AUTH] Registering FCM Device Token: $fcmToken');
        String deviceType = 'web';
        String deviceName = 'Unknown';

        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if (GetPlatform.isAndroid) {
          deviceType = 'android';
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceName = androidInfo.model;
        } else if (GetPlatform.isIOS) {
          deviceType = 'ios';
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceName = iosInfo.name;
        } else if (GetPlatform.isWeb) {
          deviceType = 'web';
          WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
          deviceName = webInfo.browserName.name;
        }

        Response response = await apiClient.postData(
          ApiConfig.registerDeviceTokenEndpoint,
          {
            "token": fcmToken,
            "device_type": deviceType,
            "device_name": deviceName,
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint("✅ [AUTH] Device token registered successfully on server. Response: ${response.body}");
        } else {
          debugPrint("❌ [AUTH] Failed to register device token on server. Code: ${response.statusCode}, Body: ${response.body}");
        }
      } else {
        debugPrint("⚠️ [AUTH] Failed to get FCM token: token is null or empty.");
      }
    } catch (e) {
      debugPrint("❌ [AUTH] Error registering device token: $e");
    }
  }

  Future<void> saveUserData(Map fullData, String token) async {
    Map responsedata = fullData['user_details'];
    apiClient.updateHeader(token);
    await sharedPreferences.setString(AppConstants.TOKEN, token);
    await sharedPreferences.setString(
      AppConstants.USER_NAME,
      responsedata['username'],
    );
    await sharedPreferences.setString(AppConstants.NAME, responsedata['name']);
    await sharedPreferences.setString(
      AppConstants.EMAIL,
      responsedata['email'] ?? '',
    );
    await sharedPreferences.setString(
      AppConstants.DEPT_NAME,
      responsedata['deptname'] ?? '',
    );
    await sharedPreferences.setInt(AppConstants.USER_ID, responsedata['id']);
    await sharedPreferences.setInt(
      AppConstants.ROLE_ID,
      responsedata['user_role_id'],
    );
    await sharedPreferences.setInt(AppConstants.STATUS, responsedata['status']);

    // Add login status
    await sharedPreferences.setBool('logstatus', true);
    // Ensure data is committed
    await sharedPreferences.reload();
  }

  bool isLoggedIn() {
    bool hasToken = sharedPreferences.containsKey(AppConstants.TOKEN);
    debugPrint("Checking if token exists in SharedPreferences: $hasToken");
    debugPrint("Token value: ${sharedPreferences.getString(AppConstants.TOKEN)}");
    return hasToken;
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.USER_NAME);
    sharedPreferences.remove(AppConstants.NAME);
    sharedPreferences.remove(AppConstants.EMAIL);
    sharedPreferences.remove(AppConstants.DEPT_NAME);
    sharedPreferences.remove(AppConstants.USER_ID);
    sharedPreferences.remove(AppConstants.ROLE_ID);
    sharedPreferences.remove(AppConstants.STATUS);
    sharedPreferences.remove('logstatus');
    return true;
  }

  // Getter methods for user data
  int? getUserId() {
    return sharedPreferences.getInt(AppConstants.USER_ID);
  }

  int? getRoleId() {
    return sharedPreferences.getInt(AppConstants.ROLE_ID);
  }

  String? getUserName() {
    return sharedPreferences.getString(AppConstants.USER_NAME);
  }

  String? getUserEmail() {
    return sharedPreferences.getString(AppConstants.EMAIL);
  }

  String? getDeptName() {
    return sharedPreferences.getString(AppConstants.DEPT_NAME);
  }
}
