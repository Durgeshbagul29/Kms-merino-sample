import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/views/common/ethics/ethics_screen.dart';
import 'package:kmsmerino/views/screens/admin/notifications/notitication.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helper/pdf_download.dart';

Future<dynamic> getAdminDashboardData() async {
  final token = await LoggedInUser.getToken();
  final name = await LoggedInUser.getName();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for admin dashboard: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/admin_dashboard?admin_id=$adminId";
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

Future<dynamic> getAdminComplaints() async {
  final token = await LoggedInUser.getToken();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_admin_ethics: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/view_admin_ethics?admin_id=$adminId";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> reviewComplaintByAdmin(BuildContext context, int dataid) async {
  final token = await LoggedInUser.getToken();
  final adminid = await LoggedInUser.getUserId();

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

  debugPrint('Using base URL for review_admin_complaint: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/review_admin_complaint/$adminid/$dataid";
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
      EthicsScreen(),
    );
    debugPrint("complaint reviewed");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("complaint not reviewed");
  }
}

Future<dynamic> getKaizenFilesData() async {
  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for kaizen_archive_files: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/kaizen_archive_files";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getAccidentFilesData() async {
  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for accident_archive_files: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/accident_archive_files";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getNearmissFilesData() async {
  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for nearmiss_archive_files: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/nearmiss_archive_files";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getObservationFilesData() async {
  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for observation_archive_files: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/observation_archive_files";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getEthicsFilesData() async {
  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for ethics_archive_files: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/ethics_archive_files";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getAdminBroadcast() async {
  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for view_admin_broadcast: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_admin_broadcast";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<void> deleteBroadcastNotification(BuildContext context, int dataid) async {
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

  debugPrint('Using base URL for delete_admin_broadcast: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/delete_admin_broadcast"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({'id': dataid}),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");
  if (responsebody['success'] == true) {
    CustomLoader.hide();
    dialogBoxForSuccess(
      context,
      'Notification Deleted Successfully',
      AdminNotification(),
    );
    debugPrint("notification deleted");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("notification not deleted");
  }
}

Future<dynamic> getBroadcastDetails(int id) async {
  final token = await LoggedInUser.getToken();

  debugPrint(
    'Using base URL for view_admin_broadcast_details: ${ApiConfig.baseUrl}',
  );
  String url = "${ApiConfig.baseUrl}/api/view_admin_broadcast_details/$id";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getAdminAccidents() async {
  final token = await LoggedInUser.getToken();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_admin_accident: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_admin_accident?admin_id=$adminId";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getAdminAccidentDetails(int id) async {
  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for view_admin_accident_details: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_admin_accident_details/$id";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getAdminNearmiss() async {
  final token = await LoggedInUser.getToken();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_admin_nearmiss: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_admin_nearmiss?admin_id=$adminId";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getAdminNearmissDetails(int id) async {
  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for view_admin_nearmiss_details: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_admin_nearmiss_details/$id";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getAdminObservation() async {
  final token = await LoggedInUser.getToken();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_admin_observation: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/view_admin_observation?admin_id=$adminId";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getAdminObservationDetails(int id) async {
  final token = await LoggedInUser.getToken();

  debugPrint(
    'Using base URL for view_admin_observation_details: ${ApiConfig.baseUrl}',
  );
  String url =
      "${ApiConfig.baseUrl}/api/view_admin_observation_details/$id";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getAdminAllKaizens() async {
  final token = await LoggedInUser.getToken();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_admin_allkaizens: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/view_admin_allkaizens?admin_id=$adminId";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getAdminViewKaizen(String type) async {
  final token = await LoggedInUser.getToken();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for view_admin_kaizentype: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/view_admin_kaizentype/$type?admin_id=$adminId";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getAdminKaizenNotifications() async {
  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for view_admin_kaizen_notf: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_admin_kaizen_notf";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> reviewKaizenNotification(BuildContext context, int dataid) async {
  final token = await LoggedInUser.getToken();
  final adminid = await LoggedInUser.getUserId();

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

  debugPrint('Using base URL for review_admin_kaizen_notf: ${ApiConfig.baseUrl}');
  String url =
      "${ApiConfig.baseUrl}/api/review_admin_kaizen_notf/$adminid/$dataid";
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
      AdminNotification(),
    );
    debugPrint("notf reviewed");
  } else {
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Something Went Wrong', 'Please Try Again');
    debugPrint("notf not reviewed");
  }
}

Future<dynamic> getAdminKaizenDetails(int id) async {
  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for view_admin_kaizen_details: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/view_admin_kaizen_details/$id";
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
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getKaizenKPIData() async {
  final token = await LoggedInUser.getToken();

  debugPrint('Using base URL for admin_kaizen_kpi: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/admin_kaizen_kpi";
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
    debugPrint("success is true");
    debugPrint("kpi records: ${responsebody['message']}");
  } else {
    debugPrint("success is false");
    debugPrint("kpi records: ${responsebody['message']}");
  }

  return responsebody;
}

Future<dynamic> getAdminMyTeam() async {
  final token = await LoggedInUser.getToken();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for admin_my_team: ${ApiConfig.baseUrl}');
  String url = "${ApiConfig.baseUrl}/api/admin_my_team?admin_id=$adminId";
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

Future<dynamic> getKaizenReport(BuildContext context, int status, String fromdate, String todate) async {
  final token = await LoggedInUser.getToken();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for admin_kaizen_report: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_kaizen_report"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'acstatus': status,
      'from_date': fromdate,
      'to_date': todate,
      'admin_id': adminId,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getAccidentReport(BuildContext context, int status, String fromdate, String todate) async {
  final token = await LoggedInUser.getToken();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for admin_accident_report: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_accident_report"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'acstatus': status,
      'from_date': fromdate,
      'to_date': todate,
      'admin_id': adminId,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getNearmissReport(BuildContext context, int status, String fromdate, String todate) async {
  final token = await LoggedInUser.getToken();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for admin_nearmiss_report: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_nearmiss_report"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'nmstatus': status,
      'from_date': fromdate,
      'to_date': todate,
      'admin_id': adminId,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getObservationReport(BuildContext context,
  int status,
  String fromdate,
  String todate,
) async {
  final token = await LoggedInUser.getToken();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for admin_obs_report: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_obs_report"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'obsstatus': status,
      'from_date': fromdate,
      'to_date': todate,
      'admin_id': adminId,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<dynamic> getEthicsReport(BuildContext context, int status, String fromdate, String todate) async {
  final token = await LoggedInUser.getToken();
  final adminId = await LoggedInUser.getUserId();

  debugPrint('Using base URL for admin_ethics_table: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_ethics_table"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'status': status,
      'from_date': fromdate,
      'to_date': todate,
      'admin_id': adminId,
    }),
  );
  debugPrint(response.body.toString());
  var responsebody = json.decode(response.body);
  debugPrint("\n Response from api:\n$responsebody");

  // return responsebody['data'];
  if (responsebody['success'] == true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;
}

Future<void> generateEthicsExcel(BuildContext context, int status, String fromdate, String todate) async {
  final token = await LoggedInUser.getToken();
  final adminid = await LoggedInUser.getUserId();

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

  debugPrint('Using base URL for admin_ethics_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_ethics_excel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'admin_id': adminid,
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

Future<void> generateAccidentExcel(
  BuildContext context,
  int status,
  String fromdate,
  String todate,
) async {
  final token = await LoggedInUser.getToken();
  final adminid = await LoggedInUser.getUserId();

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

  debugPrint('Using base URL for admin_accident_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_accident_excel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'admin_id': adminid,
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

Future<void> generateNearmissExcel(
  BuildContext context,
  int status,
  String fromdate,
  String todate,
) async {
  final token = await LoggedInUser.getToken();
  final adminid = await LoggedInUser.getUserId();

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

  debugPrint('Using base URL for admin_nearmiss_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_nearmiss_excel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'admin_id': adminid,
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

Future<void> generateObservationExcel(
  BuildContext context,
  int status,
  String fromdate,
  String todate,
) async {
  final token = await LoggedInUser.getToken();
  final adminid = await LoggedInUser.getUserId();

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

  debugPrint('Using base URL for admin_observation_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_observation_excel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'admin_id': adminid,
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

Future<void> generateKaizenExcel(BuildContext context, int status, String fromdate, String todate) async {
  final token = await LoggedInUser.getToken();
  final adminid = await LoggedInUser.getUserId();

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

  debugPrint('Using base URL for admin_kaizen_excel: ${ApiConfig.baseUrl}');
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_kaizen_excel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'admin_id': adminid,
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

Future<void> downloadAccidentFile(int id) async {
  final token = await LoggedInUser.getToken();
  // final adminid = await LoggedInUser.getUserId();

  // CustomLoader.show(context,
  //     progressIndicator: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor),
  //     loaderText:Text("\nGenerating excel...",style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.black,decoration: TextDecoration.none),textAlign: TextAlign.center,));

  debugPrint('Using base URL for download_accident_file: ${ApiConfig.baseUrl}');
  final response = await get(
    Uri.parse(
      "${ApiConfig.baseUrl}/api/download_accident_file/$id",
    ),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  debugPrint(response.body.toString());
  // var responsebody = json.decode(response.body);
  // debugPrint("\n Response from api:\n"+responsebody.toString());
}

Future<void> downloadNearmissFile(String url) async {
  await launchUrl(Uri.parse(url));

  //   final token = await LoggedInUser.getToken();
  //   // final adminid = await LoggedInUser.getUserId();

  // // CustomLoader.show(context,
  // //     progressIndicator: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor),
  // //     loaderText:Text("\nGenerating excel...",style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.black,decoration: TextDecoration.none),textAlign: TextAlign.center,));
  //   final response= await post(
  //   Uri.parse("https://kms.abraca-dabra.com/api/download_nearmiss_file"),
  //     headers: {
  //       "Accept": "application/json",
  //       'Content-Type': 'application/json',
  //       'Authorization' : 'Bearer '+token,
  //     },
  //     body: json.encode({
  //       'url':url,
  //     }),
  //   );
  //   // debugPrint(response.body.toString());
  //   // var responsebody = json.decode(response.body);
  //   // debugPrint("\n Response from api:\n"+responsebody.toString());
}

Future<void> downloadAccidentExcel(
  BuildContext context,
  int status,
  String fromdate,
  String todate,
) async {
  final token = await LoggedInUser.getToken();
  final adminid = await LoggedInUser.getUserId();

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
    'Using base URL for admin_downloadurl_accidentexcel: ${ApiConfig.baseUrl}',
  );
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_downloadurl_accidentexcel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'admin_id': adminid,
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

Future<void> downloadNearmissExcel(
  BuildContext context,
  int status,
  String fromdate,
  String todate,
) async {
  final token = await LoggedInUser.getToken();
  final adminid = await LoggedInUser.getUserId();

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
    'Using base URL for admin_downloadurl_nearmissexcel: ${ApiConfig.baseUrl}',
  );
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_downloadurl_nearmissexcel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'admin_id': adminid,
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

Future<void> downloadObservationExcel(
  BuildContext context,
  int status,
  String fromdate,
  String todate,
) async {
  final token = await LoggedInUser.getToken();
  final adminid = await LoggedInUser.getUserId();

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
    'Using base URL for admin_downloadurl_observationexcel: ${ApiConfig.baseUrl}',
  );
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_downloadurl_observationexcel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'admin_id': adminid,
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

Future<void> downloadKaizenExcel(BuildContext context, int status, String fromdate, String todate) async {
  final token = await LoggedInUser.getToken();
  final adminid = await LoggedInUser.getUserId();

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
    'Using base URL for admin_downloadurl_kaizenexcel: ${ApiConfig.baseUrl}',
  );
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_downloadurl_kaizenexcel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'admin_id': adminid,
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

Future<void> downloadEthicsExcel(BuildContext context, int status, String fromdate, String todate) async {
  final token = await LoggedInUser.getToken();
  final adminid = await LoggedInUser.getUserId();

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
    'Using base URL for admin_downloadurl_ethicsexcel: ${ApiConfig.baseUrl}',
  );
  final response = await post(
    Uri.parse("${ApiConfig.baseUrl}/api/admin_downloadurl_ethicsexcel"),
    headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode({
      'admin_id': adminid,
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

Future<String> getFilePath(String uniqueFileName) async {
  String path = '';

  String dir = (await getExternalStorageDirectory())!.path;

  path = '$dir/$uniqueFileName';
  // path = dir.path+'/'+uniqueFileName;
  debugPrint("path is $path");

  return path;
}
