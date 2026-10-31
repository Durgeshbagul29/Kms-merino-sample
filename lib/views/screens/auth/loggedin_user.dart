import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kmsmerino/utils/app_constants.dart';
import 'package:kmsmerino/models/user_data.dart';

class LoggedInUser {
  static Future<void> savePref(
    int userid,
    String username,
    String name,
    String email,
    String deptname,
    int status,
    int roleid,
    String apitoken,
    bool logstatus,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setInt(AppConstants.USER_ID, userid);
    preferences.setString(AppConstants.USER_NAME, username);
    preferences.setString(AppConstants.NAME, name);
    preferences.setString(AppConstants.EMAIL, email);
    preferences.setString(AppConstants.DEPT_NAME, deptname);
    preferences.setString(AppConstants.TOKEN, apitoken);
    preferences.setInt(AppConstants.STATUS, status);
    preferences.setInt(AppConstants.ROLE_ID, roleid);
    preferences.setBool('logstatus', logstatus);
  }

  static Future<bool> getLoggedInStatus() async {
    debugPrint("Getting logged in status from SharedPreferences...");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final status = preferences.getBool('logstatus') ?? false;
    debugPrint("getLoggedInStatus: $status");
    return status;
  }

  static Future<String> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final username = preferences.getString(AppConstants.USER_NAME) ?? '';
    debugPrint("getUserName: $username");
    return username;
  }

  static Future<String> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final name = preferences.getString(AppConstants.NAME) ?? '';
    debugPrint("getName: $name");
    return name;
  }

  static Future<int?> getUserRoleId() async {
    debugPrint("Getting user role ID from SharedPreferences...");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    debugPrint("SharedPreferences instance obtained");
    final roleid = preferences.getInt(AppConstants.ROLE_ID);
    debugPrint("Raw role ID from SharedPreferences: $roleid");
    debugPrint("Role ID key used: ${AppConstants.ROLE_ID}");

    // Also check what's actually stored in SharedPreferences
    debugPrint("All keys in SharedPreferences: ${preferences.getKeys()}");

    // Check if the key exists
    bool keyExists = preferences.containsKey(AppConstants.ROLE_ID);
    debugPrint("Does role ID key exist: $keyExists");

    debugPrint("getUserRoleId returning: $roleid");
    return roleid;
  }

  static Future<int> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final userid = preferences.getInt(AppConstants.USER_ID) ?? 0;
    debugPrint("getUserId: $userid");
    return userid;
  }

  static Future<int> getStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final status = preferences.getInt(AppConstants.STATUS) ?? 0;
    debugPrint("getStatus: $status");
    return status;
  }

  static Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(AppConstants.TOKEN) ?? '';
    debugPrint("getToken: $token");
    return token;
  }

  static Future<String> getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final email = preferences.getString(AppConstants.EMAIL) ?? '';
    debugPrint("getEmail: $email");
    return email;
  }

  static Future<String> getDeptName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final deptname = preferences.getString(AppConstants.DEPT_NAME) ?? '';
    debugPrint("getDeptName: $deptname");
    return deptname;
  }

  static Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(AppConstants.USER_ID);
    await preferences.remove(AppConstants.USER_NAME);
    await preferences.remove(AppConstants.NAME);
    await preferences.remove(AppConstants.EMAIL);
    await preferences.remove(AppConstants.DEPT_NAME);
    await preferences.remove(AppConstants.TOKEN);
    await preferences.remove(AppConstants.STATUS);
    await preferences.remove(AppConstants.ROLE_ID);
    await preferences.remove('logstatus');
  }

  static Future<UserData> getAllUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final userId = preferences.getInt(AppConstants.USER_ID) ?? 0;
    final userName = preferences.getString(AppConstants.USER_NAME) ?? '';
    final name = preferences.getString(AppConstants.NAME) ?? '';
    final email = preferences.getString(AppConstants.EMAIL) ?? '';
    final deptName = preferences.getString(AppConstants.DEPT_NAME) ?? '';
    final status = preferences.getInt(AppConstants.STATUS) ?? 0;
    final roleId = preferences.getInt(AppConstants.ROLE_ID) ?? 0;
    final apiToken = preferences.getString(AppConstants.TOKEN) ?? '';

    return UserData(
      userId: userId,
      userName: userName,
      name: name,
      email: email,
      deptName: deptName,
      status: status,
      roleId: roleId,
      apiToken: apiToken,
    );
  }
}
