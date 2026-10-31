// Director Functions
// This file will contain helper functions for the director role

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/common/ethics/ethics_screen.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kmsmerino/helper/network_connectivity_manager.dart';


import '../../../helper/pdf_download.dart';



Future<dynamic> getDirectorDashboard() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for director dashboard: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/director_dashboard?director_id=$directorId";
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

/// Makes an API call to get all director kaizens
/// with the director_id as a query parameter
Future<dynamic> getViewDirectorAllKaizens() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_allkaizens: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_director_allkaizens?director_id=$directorId";

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

/// Makes an API call to get director kaizens by type
/// with the director_id as a query parameter
Future<dynamic> getViewDirectorKaizenType(String kaizenType) async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_kaizentype: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/view_director_kaizentype/$kaizenType?director_id=$directorId";

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

/// Makes an API call to get director complaints
Future<dynamic> getDirectorComplaints() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_ethics: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_director_ethics?director_id=$directorId";
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

/// Reviews complaint by director
Future<dynamic> reviewComplaintByDirector(BuildContext context, int dataid) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();
  final directorId = await LoggedInUser.getUserId();

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

  
  debugPrint('Using base URL for review_director_complaint: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/review_director_complaint/$directorId/$dataid";
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
      EthicsScreen(), // Using DirectorComplaints
    );
    debugPrint("complaint reviewed");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("complaint not reviewed");
  }
}

/// Gets director kaizen files data
Future<dynamic> getDirectorKaizenFilesData() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for director_kaizen_archive_files: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/director_kaizen_archive_files?director_id=$directorId";
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

/// Gets director accident files data
Future<dynamic> getDirectorAccidentFilesData() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for director_accident_archive_files: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/director_accident_archive_files?director_id=$directorId";
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

/// Gets director nearmiss files data
Future<dynamic> getDirectorNearmissFilesData() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for director_nearmiss_archive_files: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/director_nearmiss_archive_files?director_id=$directorId";
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

/// Gets director observation files data
Future<dynamic> getDirectorObservationFilesData() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for director_observation_archive_files: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/director_observation_archive_files?director_id=$directorId";
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

/// Gets director ethics files data
Future<dynamic> getDirectorEthicsFilesData() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for director_ethics_archive_files: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/director_ethics_archive_files?director_id=$directorId";
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

/// Gets director broadcast notifications
Future<dynamic> getDirectorBroadcast() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_broadcast: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_director_broadcast?director_id=$directorId";
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for delete_director_broadcast: ${ApiConfig.baseUrl}');

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
    Uri.parse("${ApiConfig.baseUrl}/api/delete_director_broadcast"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({'id': dataid, 'director_id': directorId}),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");
  if (responsebody['success'] == true) {
    CustomLoader.hide();
    dialogBoxForSuccess(
      context,
      'Notification Deleted Successfully',
      EthicsScreen(),
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_broadcast_details: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/view_director_broadcast_details/$id?director_id=$directorId";
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

/// Gets director accidents
Future<dynamic> getDirectorAccidents() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_accident: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_director_accident?director_id=$directorId";
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

/// Gets director accident details
Future<dynamic> getDirectorAccidentDetails(int id) async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_accident_details: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/view_director_accident_details/$id?director_id=$directorId";
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

/// Gets director nearmiss
Future<dynamic> getDirectorNearmiss() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_nearmiss: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_director_nearmiss?director_id=$directorId";
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

/// Gets director nearmiss details
Future<dynamic> getDirectorNearmissDetails(int id) async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_nearmiss_details: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/view_director_nearmiss_details/$id?director_id=$directorId";
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

/// Gets director observation
Future<dynamic> getDirectorObservation() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_observation: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_director_observation?director_id=$directorId";
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

/// Gets director observation details
Future<dynamic> getDirectorObservationDetails(int id) async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_observation_details: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/view_director_observation_details/$id?director_id=$directorId";
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

/// Gets director view kaizen
Future<dynamic> getDirectorViewKaizen(String type) async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_kaizentype: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/view_director_kaizentype/$type?director_id=$directorId";
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

/// Gets director kaizen notifications
Future<dynamic> getDirectorKaizenNotifications() async {
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for view_director_kaizen_notf: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_director_kaizen_notf?director_id=$directorId";
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
  int directorId,
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

  
  debugPrint('Using base URL for review_director_kaizen_notf: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/review_director_kaizen_notf/$directorId/$dataid";
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
      EthicsScreen(), // Using DirectorComplaints
    );
    debugPrint("notf reviewed");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("notf not reviewed");
  }
}

/// Gets director kaizen details
Future<dynamic> getDirectorKaizenDetails(int id, int directorId) async {
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

  
  debugPrint('Using base URL for view_director_kaizen_details: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/view_director_kaizen_details/$id?director_id=$directorId";
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
Future<dynamic> getKaizenKPIData(int directorId) async {
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

  
  debugPrint('Using base URL for director_kaizen_kpi: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_kaizen_kpi"),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
    body: json.encode({'director_id': directorId}),
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for director_kaizen_report: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_kaizen_report"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'acstatus': status,
      'from_date': fromdate,
      'to_date': todate,
      'director_id': directorId,
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
  int directorId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  
  debugPrint('Using base URL for director_accident_report: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_accident_report"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'acstatus': status,
      'from_date': fromdate,
      'to_date': todate,
      'director_id': directorId,
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
  int directorId,
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  
  debugPrint('Using base URL for director_nearmiss_report: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_nearmiss_report"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'nmstatus': status,
      'from_date': fromdate,
      'to_date': todate,
      'director_id': directorId,
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
Future<dynamic> getEthicsReport(BuildContext context, int status, String fromdate, String todate) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for director_ethics_table: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_ethics_table"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'status': status,
      'from_date': fromdate,
      'to_date': todate,
      'director_id': directorId,
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
  final directorId = await LoggedInUser.getUserId();

  
  debugPrint('Using base URL for director_obs_report: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_obs_report"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'obstatus': status,
      'from_date': fromdate,
      'to_date': todate,
      'director_id': directorId,
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
  int directorId,
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
  
  debugPrint('Using base URL for director_ethics_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_ethics_excel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'director_id': directorId,
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
  int directorId,
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
  
  debugPrint('Using base URL for director_accident_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_accident_excel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'director_id': directorId,
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
  int directorId,
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
  
  debugPrint('Using base URL for director_nearmiss_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_nearmiss_excel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'director_id': directorId,
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
  int directorId,
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
  
  debugPrint('Using base URL for director_observation_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_observation_excel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'director_id': directorId,
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
  int directorId,
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
  
  debugPrint('Using base URL for director_kaizen_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_kaizen_excel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'director_id': directorId,
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
Future<void> downloadAccidentFile(int id, int directorId) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  
  debugPrint('Using base URL for download_director_accident_file: ${ApiConfig.baseUrl}');
  final response = await get(
    Uri.parse(
      "${ApiConfig.baseUrl}/api/download_director_accident_file/$id?director_id=$directorId",
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
  int directorId,
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
  
  debugPrint('Using base URL for director_downloadurl_accidentexcel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_downloadurl_accidentexcel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'director_id': directorId,
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
  int directorId,
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
  
  debugPrint('Using base URL for director_downloadurl_nearmissexcel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_downloadurl_nearmissexcel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'director_id': directorId,
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
  int directorId,
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
  
  debugPrint('Using base URL for director_downloadurl_observationexcel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_downloadurl_observationexcel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'director_id': directorId,
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
) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();
  final directorId = await LoggedInUser.getUserId();

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
  
  debugPrint('Using base URL for director_downloadurl_kaizenexcel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_downloadurl_kaizenexcel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'director_id': directorId,
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
  int directorId,
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
  
  debugPrint('Using base URL for director_downloadurl_ethicsexcel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/director_downloadurl_ethicsexcel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'director_id': directorId,
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
