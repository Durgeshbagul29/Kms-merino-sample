

// Manager Functions
// This file will contain helper functions for the manager role

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/views/common/ethics/ethics_screen.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kmsmerino/helper/network_connectivity_manager.dart';

import '../../../helper/pdf_download.dart';

Future<dynamic> getManagerDashboard() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final name = await LoggedInUser.getName();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for manager dashboard: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.managerDashboardUrl(managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );

  var responseBody = json.decode(response.body);
  debugPrint(responseBody.toString());

  var data = {'name': name, 'records': responseBody};

  if (responseBody['success'] == true) {
    debugPrint("Success: ${responseBody['message']}");
  } else {
    debugPrint("Error: ${responseBody['message']}");
  }

  return data;
}

/// Makes an API call to get all manager kaizens
/// with the manager_id as a query parameter
Future<dynamic> getViewManagerAllKaizens() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_manager_allkaizens: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.viewManagerAllKaizensUrl(managerId);

  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );

  var responseBody = json.decode(response.body);
  debugPrint(responseBody.toString());

  if (responseBody['success'] == true) {
    debugPrint("Success: ${responseBody['message']}");
  } else {
    debugPrint("Error: ${responseBody['message']}");
  }

  return responseBody;
}

/// Makes an API call to get manager kaizens by type
/// with the manager_id as a query parameter
Future<dynamic> getViewManagerKaizenType(String kaizenType) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_manager_kaizentype: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.viewManagerKaizenTypeUrl(kaizenType, managerId);

  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );

  var responseBody = json.decode(response.body);
  debugPrint(responseBody.toString());

  if (responseBody['success'] == true) {
    debugPrint("Success: ${responseBody['message']}");
  } else {
    debugPrint("Error: ${responseBody['message']}");
  }

  return responseBody;
}

/// Makes an API call to get manager complaints
Future<dynamic> getManagerComplaints() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_manager_ethics: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.viewManagerEthicsUrl(managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Reviews complaint by manager
Future<dynamic> reviewComplaintByManager(BuildContext context, int dataid) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nProcessing your request...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  debugPrint('Using base URL for review_manager_complaint: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.reviewManagerComplaintUrl(managerId, dataid);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");
  if (responsebody['success'] == true) {
    CustomLoader.hide();
    dialogBoxForSuccess(
      context,
      'Complaint Reviewed Successfully',
      EthicsScreen(), // Using EthicsScreen
    );
    debugPrint("complaint reviewed");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("complaint not reviewed");
  }
}

/// Gets manager kaizen files data
Future<dynamic> getManagerKaizenFilesData() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint(
    'Using base URL for manager_kaizen_archive_files: ${ApiConfig.baseUrl}',
  );
  String url =
      ApiConfig.managerKaizenArchiveFilesUrl(managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager accident files data
Future<dynamic> getManagerAccidentFilesData() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint(
    'Using base URL for manager_accident_archive_files: ${ApiConfig.baseUrl}',
  );
  String url =
      ApiConfig.managerAccidentArchiveFilesUrl(managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager nearmiss files data
Future<dynamic> getManagerNearmissFilesData() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint(
    'Using base URL for manager_nearmiss_archive_files: ${ApiConfig.baseUrl}',
  );
  String url =
      ApiConfig.managerNearmissArchiveFilesUrl(managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager observation files data
Future<dynamic> getManagerObservationFilesData() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint(
    'Using base URL for manager_observation_archive_files: ${ApiConfig.baseUrl}',
  );
  String url =
      ApiConfig.managerObservationArchiveFilesUrl(managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager ethics files data
Future<dynamic> getManagerEthicsFilesData() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint(
    'Using base URL for manager_ethics_archive_files: ${ApiConfig.baseUrl}',
  );
  String url =
      ApiConfig.managerEthicsArchiveFilesUrl(managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager broadcast notifications
Future<dynamic> getManagerBroadcast() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_manager_broadcast: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.viewManagerBroadcastUrl(managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Deletes broadcast notification
Future<void> deleteBroadcastNotification(BuildContext context, int dataid) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for delete_manager_broadcast: ${ApiConfig.baseUrl}');

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nProcessing your request...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  final response = await post(
    Uri.parse(ApiConfig.deleteManagerBroadcastUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({'id': dataid, 'manager_id': managerId}),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");
  if (responsebody['success'] == true) {
    CustomLoader.hide();
    dialogBoxForExcelSuccess(
      context,
      'Notification Deleted Successfully',
    );
    debugPrint("notification deleted");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("notification not deleted");
  }
}

/// Gets broadcast details
Future<dynamic> getBroadcastDetails(int id) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint(
    'Using base URL for view_manager_broadcast_details: ${ApiConfig.baseUrl}',
  );
  String url =
      ApiConfig.viewManagerBroadcastDetailsUrl(id, managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager accidents
Future<dynamic> getManagerAccidents() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_manager_accident: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.viewManagerAccidentUrl(managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager accident details
Future<dynamic> getManagerAccidentDetails(int id) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint(
    'Using base URL for view_manager_accident_details: ${ApiConfig.baseUrl}',
  );
  String url =
      ApiConfig.viewManagerAccidentDetailsUrl(id, managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager nearmiss
Future<dynamic> getManagerNearmiss() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_manager_nearmiss: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.viewManagerNearmissUrl(managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager nearmiss details
Future<dynamic> getManagerNearmissDetails(int id) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint(
    'Using base URL for view_manager_nearmiss_details: ${ApiConfig.baseUrl}',
  );
  String url =
      ApiConfig.viewManagerNearmissDetailsUrl(id, managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager observation
Future<dynamic> getManagerObservation() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_manager_observation: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.viewManagerObservationUrl(managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager observation details
Future<dynamic> getManagerObservationDetails(int id) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint(
    'Using base URL for view_manager_observation_details: ${ApiConfig.baseUrl}',
  );
  String url =
      ApiConfig.viewManagerObservationDetailsUrl(id, managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager my team
Future<dynamic> getManagerMyTeam() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for manager_my_team: ${ApiConfig.baseUrl}');
  String url = ApiConfig.managerMyTeamUrl(managerId);

  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager view kaizen
Future<dynamic> getManagerViewKaizen(String type) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_manager_kaizentype: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.viewManagerKaizenTypeUrl(type, managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets manager kaizen notifications
Future<dynamic> getManagerKaizenNotifications() async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_manager_kaizen_notf: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.viewManagerKaizenNotfUrl(managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Reviews kaizen notification
Future<dynamic> reviewKaizenNotification(BuildContext context,
  int dataid,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nProcessing your request...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  debugPrint('Using base URL for review_manager_kaizen_notf: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.reviewManagerKaizenNotfUrl(managerId, dataid);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");
  if (responsebody['success'] == true) {
    CustomLoader.hide();
    dialogBoxForSuccess(
      context,
      'Notification Reviewed Successfully',
      EthicsScreen(), // Using ManagerComplaints as placeholder
    );
    debugPrint("notf reviewed");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("notf not reviewed");
  }
}

/// Gets manager kaizen details
Future<dynamic> getManagerKaizenDetails(int id, int managerId) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for view_manager_kaizen_details: ${ApiConfig.baseUrl}');
  String url =
      ApiConfig.viewManagerKaizenDetailsUrl(id, managerId);
  final response = await get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets kaizen KPI data
Future<dynamic> getKaizenKPIData(int managerId) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return {
      'success': false,
      'message': 'No internet connection',
      'data': null,
      'records': {'success': false, 'data': null},
    };
  }

  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for manager_kaizen_kpi: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse(ApiConfig.managerKaizenKpiUrl),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({'manager_id': managerId}),
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint("kpi records: ${responsebody['message']}");
  } else {
    debugPrint("success is false");
    debugPrint("kpi records: ${responsebody['message']}");
  }

  return responsebody;
}

/// Gets kaizen report
Future<dynamic> getKaizenReport(BuildContext context,
  int status,
  String fromdate,
  String todate,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for manager_kaizen_report: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse(ApiConfig.managerKaizenReportUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'acstatus': status,
      'from_date': fromdate,
      'to_date': todate,
      'manager_id': managerId,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets accident report
Future<dynamic> getAccidentReport(BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for manager_accident_report: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse(ApiConfig.managerAccidentReportUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'acstatus': status,
      'from_date': fromdate,
      'to_date': todate,
      'manager_id': managerId,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets nearmiss report
Future<dynamic> getNearmissReport(BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for manager_nearmiss_report: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse(ApiConfig.managerNearmissReportUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'nmstatus': status,
      'from_date': fromdate,
      'to_date': todate,
      'manager_id': managerId,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets observation report
Future<dynamic> getObservationReport(BuildContext context,
  int status,
  String fromdate,
  String todate,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();
  final managerId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for manager_obs_report: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse(ApiConfig.managerObsReportUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'obstatus': status,
      'from_date': fromdate,
      'to_date': todate,
      'manager_id': managerId,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Gets ethics report
Future<dynamic> getEthicsReport(BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for manager_ethics_table: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse(ApiConfig.managerEthicsTableUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'status': status,
      'from_date': fromdate,
      'to_date': todate,
      'manager_id': managerId,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

/// Generates ethics Excel
Future<void> generateEthicsExcel(BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nGenerating excel...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  debugPrint('Using base URL for manager_ethics_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse(ApiConfig.managerEthicsExcelUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'manager_id': managerId,
      'status': status,
      'from_date': fromdate,
      'to_date': todate,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  var data = responsebody['data'];
  if (data['excel_status'] == 1) {
    CustomLoader.hide();
    dialogBoxForExcelSuccess(context, 'Excel Report Generated Successfully');
    debugPrint("done");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("not done");
  }
}

/// Generates accident Excel
Future<void> generateAccidentExcel(
  BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nGenerating excel...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  debugPrint('Using base URL for manager_accident_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse(ApiConfig.managerAccidentExcelUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'manager_id': managerId,
      'acstatus': status,
      'from_date': fromdate,
      'to_date': todate,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  var data = responsebody['data'];
  if (data['excel_status'] == 1) {
    CustomLoader.hide();
    dialogBoxForExcelSuccess(context, 'Excel Report Generated Successfully');
    debugPrint("done");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("not done");
  }
}

/// Generates nearmiss Excel
Future<void> generateNearmissExcel(
  BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nGenerating excel...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  debugPrint('Using base URL for manager_nearmiss_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse(ApiConfig.managerNearmissExcelUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'manager_id': managerId,
      'nmstatus': status,
      'from_date': fromdate,
      'to_date': todate,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  var data = responsebody['data'];
  if (data['excel_status'] == 1) {
    CustomLoader.hide();
    dialogBoxForExcelSuccess(context, 'Excel Report Generated Successfully');
    debugPrint("done");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("not done");
  }
}

/// Generates observation Excel
Future<void> generateObservationExcel(
  BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nGenerating excel...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  debugPrint('Using base URL for manager_observation_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse(ApiConfig.managerObservationExcelUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'manager_id': managerId,
      'obsstatus': status,
      'from_date': fromdate,
      'to_date': todate,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  var data = responsebody['data'];
  if (data['excel_status'] == 1) {
    CustomLoader.hide();
    dialogBoxForExcelSuccess(context, 'Excel Report Generated Successfully');
    debugPrint("done");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("not done");
  }
}

/// Generates kaizen Excel
Future<void> generateKaizenExcel(BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nGenerating excel...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  debugPrint('Using base URL for manager_kaizen_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse(ApiConfig.managerKaizenExcelUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'manager_id': managerId,
      'acstatus': status,
      'from_date': fromdate,
      'to_date': todate,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  var data = responsebody['data'];
  if (data['excel_status'] == 1) {
    CustomLoader.hide();
    dialogBoxForExcelSuccess(context, 'Excel Report Generated Successfully');
    debugPrint("done");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("not done");
  }
}

/// Downloads accident file
Future<void> downloadAccidentFile(int id, int managerId) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  debugPrint(
    'Using base URL for download_manager_accident_file: ${ApiConfig.baseUrl}',
  );
  final response = await get(
    Uri.parse(
      ApiConfig.downloadManagerAccidentFileUrl(id, managerId),
    ),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  debugPrint(response.body.toString());
}

/// Downloads nearmiss file
Future<void> downloadNearmissFile(String url) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  await launchUrl(Uri.parse(url));
}

/// Downloads accident Excel
Future<void> downloadAccidentExcel(
  BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nGenerating excel for download...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  debugPrint(
    'Using base URL for manager_downloadurl_accidentexcel: ${ApiConfig.baseUrl}',
  );
  final response = await post(
    Uri.parse(ApiConfig.managerDownloadUrlAccidentExcelUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'manager_id': managerId,
      'acstatus': status,
      'from_date': fromdate,
      'to_date': todate,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  var data = responsebody['data'];
  if (data['excel_status'] == 1) {
    CustomLoader.hide();
    downloadFromUrl(context, data['filename'], data['url']);
    debugPrint("file generated");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(
      context,
      'Unable to download excel',
      'Please Try Again',
    );
    debugPrint("not done");
  }
}

/// Downloads nearmiss Excel
Future<void> downloadNearmissExcel(
  BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nGenerating excel for download...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  debugPrint(
    'Using base URL for manager_downloadurl_nearmissexcel: ${ApiConfig.baseUrl}',
  );
  final response = await post(
    Uri.parse(ApiConfig.managerDownloadUrlNearmissExcelUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'manager_id': managerId,
      'nmstatus': status,
      'from_date': fromdate,
      'to_date': todate,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  var data = responsebody['data'];
  if (data['excel_status'] == 1) {
    CustomLoader.hide();
    downloadFromUrl(context, data['filename'], data['url']);
    debugPrint("file generated");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(
      context,
      'Unable to download excel',
      'Please Try Again',
    );
    debugPrint("not done");
  }
}

/// Downloads observation Excel
Future<void> downloadObservationExcel(
  BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nGenerating excel for download...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  debugPrint(
    'Using base URL for manager_downloadurl_observationexcel: ${ApiConfig.baseUrl}',
  );
  final response = await post(
    Uri.parse(ApiConfig.managerDownloadUrlObservationExcelUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'manager_id': managerId,
      'obsstatus': status,
      'from_date': fromdate,
      'to_date': todate,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  var data = responsebody['data'];
  if (data['excel_status'] == 1) {
    CustomLoader.hide();
    downloadFromUrl(context, data['filename'], data['url']);
    debugPrint("file generated");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(
      context,
      'Unable to download excel',
      'Please Try Again',
    );
    debugPrint("not done");
  }
}

/// Downloads kaizen Excel
Future<void> downloadKaizenExcel(BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nGenerating excel for download...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  debugPrint(
    'Using base URL for manager_downloadurl_kaizenexcel: ${ApiConfig.baseUrl}',
  );
  final response = await post(
    Uri.parse(ApiConfig.managerDownloadUrlKaizenExcelUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'manager_id': managerId,
      'acstatus': status,
      'from_date': fromdate,
      'to_date': todate,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  var data = responsebody['data'];
  if (data['excel_status'] == 1) {
    CustomLoader.hide();
    downloadFromUrl(context, data['filename'], data['url']);
    debugPrint("file generated");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(
      context,
      'Unable to download excel',
      'Please Try Again',
    );
    debugPrint("not done");
  }
}

/// Downloads ethics Excel
Future<void> downloadEthicsExcel(BuildContext context,
  int status,
  String fromdate,
  String todate,
  int managerId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nGenerating excel for download...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  debugPrint(
    'Using base URL for manager_downloadurl_ethicsexcel: ${ApiConfig.baseUrl}',
  );
  final response = await post(
    Uri.parse(ApiConfig.managerDownloadUrlEthicsExcelUrl),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'manager_id': managerId,
      'status': status,
      'from_date': fromdate,
      'to_date': todate,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  var data = responsebody['data'];
  if (data['excel_status'] == 1) {
    CustomLoader.hide();
    downloadFromUrl(context, data['filename'], data['url']);
    debugPrint("file generated");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(
      context,
      'Unable to download excel',
      'Please Try Again',
    );
    debugPrint("not done");
  }
}

/// Gets file path
Future<String> getFilePath(String uniqueFileName) async {
  String path = '';

  String dir = (await getExternalStorageDirectory())!.path;

  path = '$dir/$uniqueFileName';
  debugPrint("path is $path");

  return path;
}
