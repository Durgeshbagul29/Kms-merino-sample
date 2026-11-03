// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:kmsmerino/views/screens/user/accident/user_accidentdetails.dart';
import 'package:kmsmerino/views/common/ethics/ethics_complaint_details.dart';
import 'package:kmsmerino/views/screens/user/kaizens/update_pending.dart';
import 'package:kmsmerino/views/screens/user/kaizens/user_kaizendetails.dart';
import 'package:kmsmerino/views/screens/user/nearmiss/user_nearmissdetails.dart';
import 'package:kmsmerino/views/screens/user/notifications/user_notifications.dart';
import 'package:kmsmerino/views/screens/user/observation/user_obsdetails.dart';
import 'package:kmsmerino/helper/network_connectivity_manager.dart';

import '../../../helper/pdf_download.dart';

Future<dynamic> getUserDashboardData() async {
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

  debugPrint('Using base URL for user dashboard: ${ApiConfig.baseUrl}');
  String url = ApiConfig.userDashboardUrl;
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  var data = {'name': name, 'records': responsebody};

  // return responsebody;
  return data;
}

Future<dynamic> getUserComplaints() async {
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

  debugPrint('Using base URL for view_user_complaints: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserComplaintsUrl();
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getUserBroadcast() async {
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

  debugPrint('Using base URL for view_user_broadcast: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserBroadcastUrl;
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getUserAccidents() async {
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

  debugPrint('Using base URL for view_user_accidents: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserAccidentsUrl();
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

  // return responsebody['data'];
  // if(responsebody['success']=true){
  //     debugPrint("success is true");
  //     debugPrint(responsebody['message'].toString());
  // }else{
  //   debugPrint("success is false");
  //   debugPrint(responsebody['message'].toString());
  // }

  return responsebody;
}

Future<dynamic> getUserAccidentDetails(int id) async {
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

  debugPrint('Using base URL for view_user_accident_details: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserAccidentDetailsUrl(id);
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getUserNearmiss() async {
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

  debugPrint('Using base URL for view_user_nearmiss: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserNearmissUrl();
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getUserNearmissDetails(int id) async {
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

  debugPrint('Using base URL for view_user_nearmiss_details: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserNearmissDetailsUrl(id);
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getUserObservation() async {
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

  debugPrint('Using base URL for view_user_observation: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserObservationUrl();
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getUserObservationDetails(int id) async {
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

  debugPrint('Using base URL for view_user_obs_details: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserObsDetailsUrl(id);
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getUserApprovedKaizens() async {
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

  debugPrint('Using base URL for view_user_approvedkaizens: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserApprovedKaizensUrl;
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getUserSubmittedKaizens() async {
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

  debugPrint('Using base URL for view_user_submittedkaizens: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserSubmittedKaizensUrl;
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getUserViewKaizens(String type) async {
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

  debugPrint('Using base URL for view_user_kaizens: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserKaizensUrl(type);
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getUserBNDetails(int id) async {
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
  final userid = await LoggedInUser.getUserId();

  debugPrint('Using base URL for seen_user_broadcast_notf: ${ApiConfig.baseUrl}');
  String url = ApiConfig.seenUserBroadcastNotfUrl(userid, id);
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getUserKaizenDetails(int id) async {
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

  debugPrint('Using base URL for view_user_kaizens_details: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserKaizenDetailsUrl(id);
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<void> deletePendingKaizen(BuildContext context, int dataid, Widget filename) async {
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

  debugPrint('Using base URL for delete_user_kaizen: ${ApiConfig.baseUrl}');
  String url = ApiConfig.deleteUserKaizenUrl;
  final response = await post(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({'kaizen_id': dataid}),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");
  if (responsebody['success'] == true) {
    CustomLoader.hide();
    dialogBoxForSuccess(context, 'Kaizen Deleted Successfully', filename);
    // if(fileno==1){
    //   dialogBoxForSuccess(context,'Kaizen Deleted Successfully',UserSubmittedKaizens());
    // }else if(fileno==2){
    //   dialogBoxForSuccess(context,'Kaizen Deleted Successfully',UserViewKaizens(type));
    // }
    debugPrint("kaizen deleted");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("kaizen not deleted");
  }
}

Future<dynamic> getUserSectionNotifications() async {
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

  debugPrint('Using base URL for view_user_notifications: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserNotificationsUrl;
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<void> deleteSectionNotification(BuildContext context, int dataid) async {
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

  debugPrint('Using base URL for delete_user_notf: ${ApiConfig.baseUrl}');
  String url = ApiConfig.deleteUserNotificationUrl;
  final response = await post(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({'notf_id': dataid}),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");
  if (responsebody['success'] == true) {
    CustomLoader.hide();
    dialogBoxForSuccess(
      context,
      'Notification Deleted Successfully',
      UserNotification(),
    );
    debugPrint("notf deleted");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("notf not deleted");
  }
}

Future<void> reviewSectionNotification(BuildContext context, int id, Widget filename) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();
  final userid = await LoggedInUser.getUserId();

  debugPrint('Using base URL for review_user_section_notf: ${ApiConfig.baseUrl}');
  String url = ApiConfig.reviewUserSectionNotfUrl(userid, id);
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

  // dialogBoxForNotficication(context,responsebody['data'],filename);
  var data = responsebody['data'];
  if (data['notf']['category_id'] == 1) {
    if (data['notf']['subcategory_id'] == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UserAccidentDetails(data['notf']['record_id'], filename),
        ),
      );
    } else if (data['notf']['subcategory_id'] == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UserNearmissDetails(data['notf']['record_id'], filename),
        ),
      );
    } else if (data['notf']['subcategory_id'] == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UserObservationDetails(data['notf']['record_id'], filename),
        ),
      );
    }
  } else if (data['notf']['category_id'] == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserKaizenDetails(data['notf']['record_id'], filename),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EthicsComplaintDetails(complaint: data['records']),
      ),
    );
  }
}

Future<void> viewSectionNotification(BuildContext context, int id, Widget filename) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();
  final userid = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_user_section_notf: ${ApiConfig.baseUrl}');
  String url = ApiConfig.viewUserSectionNotfUrl(userid, id);
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

  var data = responsebody['data'];
  if (data['notf']['category_id'] == 1) {
    if (data['notf']['subcategory_id'] == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UserAccidentDetails(data['notf']['record_id'], filename),
        ),
      );
    } else if (data['notf']['subcategory_id'] == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UserNearmissDetails(data['notf']['record_id'], filename),
        ),
      );
    } else if (data['notf']['subcategory_id'] == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UserObservationDetails(data['notf']['record_id'], filename),
        ),
      );
    }
  } else if (data['notf']['category_id'] == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserKaizenDetails(data['notf']['record_id'], filename),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EthicsComplaintDetails(complaint: data['records']),
      ),
    );
  }
}

Future<void> getUserKaizenDetailsForPendingUpdate(BuildContext context, int id, Widget filename) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  final token = await LoggedInUser.getToken();

  debugPrint(
    'Using base URL for view_user_kaizens_details (pending update): ${ApiConfig.baseUrl}',
  );
  String url = ApiConfig.viewUserKaizenDetailsUrl(id);
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

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    // Fixed the comparison operator
    if (responsebody['data'] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdatePendingKaizen(
            responsebody['data']['details']['id'],
            responsebody['data']['details']['self_support'],
            responsebody['data']['details']['subcategoryid'],
            responsebody['data']['details']['problem'],
            responsebody['data']['details']['description'],
            responsebody['data']['details']['solution'],
            responsebody['data']['before_url'] ?? '-',
            filename,
          ),
        ),
      );
    }
    debugPrint("record reviewed");
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<void> generateKaizenPDF(BuildContext context, int id) async {
  // Check network connectivity before proceeding
  final networkManager = NetworkManager.instance;
  final isConnected = await networkManager.checkConnectivityAndShowError();

  if (!isConnected) {
    return;
  }

  // Immediately show loading indicator upon clicking
  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(
      color: Theme.of(context).primaryColor,
    ),
    loaderText: Text(
      "\nGenerating PDF...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  try {
    final token = await LoggedInUser.getToken();

    debugPrint('Using base URL for download_kaizen_pdf: ${ApiConfig.baseUrl}');
    String url = ApiConfig.downloadKaizenPdfUrl(id);
    final response = await get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    debugPrint(response.body.toString());
    var responsebody = json.decode(response.body);
    debugPrint("\n Response from api:\n$responsebody");

    var data = responsebody is Map ? responsebody['data'] : null;
    if (data is Map && data['pdf_status'] == 1) {
      CustomLoader.hide();
      await downloadFromUrl(context, data['filename'] ?? 'kaizen_$id.pdf', data['url'] ?? '');
      debugPrint("file generated");
    } else {
      CustomLoader.hide();
      String message = 'Unable to download pdf';
      if (responsebody is Map && responsebody['message'] != null) {
        message = responsebody['message'].toString();
      }
      dialogBoxForFailure(context, message, 'Please Try Again');
      debugPrint("not done");
    }
  } catch (e) {
    CustomLoader.hide();
    debugPrint("Error generating PDF: $e");
    dialogBoxForFailure(context, 'Download Failed', 'Please check your connection and try again');
  }
}
