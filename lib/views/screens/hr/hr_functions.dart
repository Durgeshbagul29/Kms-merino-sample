import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper function to retrieve the tenant base URL from shared preferences
/// Returns the tenant URL if available, otherwise falls back to default API base URL
Future<String> getTenantBaseUrl() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? tenantBaseUrl = prefs.getString('tenant_base_url');
  return tenantBaseUrl ?? ApiConfig.baseUrl;
}



/// Retrieves HR dashboard data including user statistics and overview metrics
/// Returns a Map containing user name and dashboard records
/// Used to populate the HR dashboard with key metrics and statistics
Future<dynamic> getDashboardData() async {
  // debugPrint("in dashboard function :"+LoggedInUser.getToken());
  final token = await LoggedInUser.getToken();
  final name = await LoggedInUser.getName();
  // debugPrint(token);
  
  String baseUrl = await getTenantBaseUrl();
  debugPrint('Using base URL for dashboard: $baseUrl');
  
  final response = await get(
    Uri.parse("$baseUrl${ApiConfig.hrDashboardEndpoint}"),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  // return responsebody['data'];

  if (responsebody['success'] = true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  var data = {'name': name, 'records': responsebody};

  // return responsebody;
  return data;

  // if(responsebody['success']=true){

  //   // userArray = responsebody['data']['users'];
  //   // debugPrint(userArray);

  //   // adminArray = responsebody['data']['admins'];
  //   // debugPrint(adminArray);

  //   // totalAdmins = responsebody['data']['totalAdmin'];
  //   // totalUsers = responsebody['data']['totalUsers'];

  //   return responsebody['data'];

  // }else{
  //   return responsebody['data'];
  // }
}

/// Fetches all admin users data from the system
/// Returns API response containing admin users list
/// Used in admin management screens to display and manage admin accounts
Future<dynamic> getUserData() async {
  final token = await LoggedInUser.getToken();
  String baseUrl = await getTenantBaseUrl();
  debugPrint('Using base URL for get_all_admins: $baseUrl');
  
  final response = await get(
    Uri.parse("$baseUrl${ApiConfig.getAllAdminsEndpoint}"),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  // return responsebody['data'];
  if (responsebody['success'] = true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;

  // if(responsebody['success']=true){

  //   adminArray = responsebody['data']['admins'];
  //   debugPrint(adminArray);

  //   requestResponse = responsebody['success'];

  // }else{

  //   requestResponse = responsebody['success'];
  // }

  // _progressController = false;
}

/// Fetches all regular users data from the system
/// Returns API response containing users list
/// Used in user management screens to display and manage employee accounts
Future<dynamic> getUserData1() async {
  final token = await LoggedInUser.getToken();
  String baseUrl = await getTenantBaseUrl();
  debugPrint('Using base URL for get_all_users: $baseUrl');
  
  final response = await get(
    Uri.parse("$baseUrl${ApiConfig.getAllUsersEndpoint}"),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  // return responsebody['data'];
  if (responsebody['success'] = true) {
    debugPrint("success is true");
    debugPrint(responsebody['message'].toString());
  } else {
    debugPrint("success is false");
    debugPrint(responsebody['message'].toString());
  }

  return responsebody;

  // if(responsebody['success']=true){

  //   userArray = responsebody['data']['users'];
  //   debugPrint(userArray);

  //   requestResponse = responsebody['success'];

  // }else{

  //   requestResponse = responsebody['success'];
  // }

  // _progressController = false;
}

/// Fetches all manager users data from the system
/// Returns API response containing managers list
/// Used in manager management screens to display and manage manager accounts
Future<dynamic> getAllManagers() async {
  final token = await LoggedInUser.getToken();
  String baseUrl = await getTenantBaseUrl();
  debugPrint('Using base URL for get_all_managers: $baseUrl');
  
  final response = await get(
    Uri.parse("$baseUrl${ApiConfig.getAllManagersEndpoint}"),
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

/// Fetches all director users data from the system
/// Returns API response containing directors list
/// Used in director management screens to display and manage director accounts
Future<dynamic> getAllDirectors() async {
  final token = await LoggedInUser.getToken();
  String baseUrl = await getTenantBaseUrl();
  debugPrint('Using base URL for get_all_directors: $baseUrl');
  
  final response = await get(
    Uri.parse("$baseUrl${ApiConfig.getAllDirectorsEndpoint}"),
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

/// Fetches department data from the system
/// Returns list of departments data
/// Used to populate department dropdowns and selection lists
Future<dynamic> getDepts() async {
  final token = await LoggedInUser.getToken();
  String baseUrl = await getTenantBaseUrl();
  debugPrint('Using base URL for get_depts: $baseUrl');
  
  final response = await get(
    Uri.parse("$baseUrl${ApiConfig.getDeptsEndpoint}"),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(responsebody.toString());

  // List<DropdownMenuItem<String>> deptList = [];

  // responsebody['data'].forEach((element) {
  //   deptList.add(element['name']);
  // });

  return responsebody['data'];
  // return deptList;
}

/// Fetches all departments with complete details
/// Returns a List of Maps containing department information
/// Used for comprehensive department management and display
Future<List<Map<String, dynamic>>> getAllDepartments() async {
  final token = await LoggedInUser.getToken();
  String baseUrl = await getTenantBaseUrl();
  debugPrint('Using base URL for get_all_departments: $baseUrl');
  
  final response = await get(
    Uri.parse("$baseUrl${ApiConfig.getAllDepartmentsEndpoint}"),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);
  debugPrint(
    "\n Response from get_all_departments api:\n$responsebody",
  );

  if (responsebody['success'] == true && responsebody['data'] != null) {
    return List<Map<String, dynamic>>.from(responsebody['data']);
  } else {
    return [];
  }
}

/// Assigns departments to a specific manager
/// [managerId] - The ID of the manager to assign departments to
/// [departmentIds] - List of department IDs to assign
/// Returns API response with assignment result
/// Used in manager-department assignment workflows
Future<Map<String, dynamic>> assignDepartmentsToManager({
  required int managerId,
  required List<int> departmentIds,
}) async {
  final token = await LoggedInUser.getToken();
  String baseUrl = await getTenantBaseUrl();
  debugPrint('Using base URL for assign_manager_departments: $baseUrl');
  
  // Log the data being sent
  debugPrint('Sending manager_id: $managerId');
  debugPrint('Sending department_ids as array: $departmentIds');
  
  final requestBody = {
    'manager_id': managerId,
    'departments': departmentIds, // This ensures department IDs are sent as JSON array
  };
  
  debugPrint('Request body: ${json.encode(requestBody)}');
  
  final response = await post(
    Uri.parse("$baseUrl${ApiConfig.assignManagerDepartmentsEndpoint}"),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
    body: json.encode(requestBody),
  );
  
  var responsebody = json.decode(response.body);
  debugPrint("Assign departments response: $responsebody");
  
  return responsebody;
}

/// Retrieves departments assigned to a specific manager
/// [managerId] - The ID of the manager to get departments for
/// Returns a List of department IDs assigned to the manager
/// Used to display current department assignments for managers
// Future<List<int>> getManagerDepartments(int managerId) async {
//   final token = await LoggedInUser.getToken();
//   String baseUrl = await getTenantBaseUrl();
//   debugPrint('Using base URL for get_manager_departments: $baseUrl');
  
//   final response = await get(
//     Uri.parse("$baseUrl${ApiConfig.getManagerDepartmentsEndpoint}/$managerId"),
//     headers: {
//       "Accept": "application/json",
//       "Content-Type": "application/json",
//       'Authorization': 'Bearer ' + token,
//     },
//   );
  
//   var responsebody = json.decode(response.body);
//   debugPrint("Manager departments response: " + responsebody.toString());
  
//   if (responsebody['success'] == true && responsebody['data'] != null) {
//     List<int> departmentIds = [];
//     if (responsebody['data'] is List) {
//       departmentIds = List<int>.from(responsebody['data']);
//     }
//     return departmentIds;
//   }
  
//   return [];
// }

/// Prepares department data for adding new user/admin forms
/// Fetches department list and prepares it for dropdown usage
/// Used when navigating to user creation screens to populate department selections
Future<void> functionForAddUserAdmin(BuildContext context) async {
  final token = await LoggedInUser.getToken();
  String baseUrl = await getTenantBaseUrl();
  debugPrint('Using base URL for get_depts (add user): $baseUrl');
  
  final response = await get(
    Uri.parse("$baseUrl${ApiConfig.getDeptsEndpoint}"),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );
  var responsebody = json.decode(response.body);

  List<String> deptList = [];

  debugPrint("\n Response from api:\n$responsebody");
  if (responsebody['success'] == true) {
    if (responsebody['data'] != null) {
      responsebody['data'].forEach((element) {
        deptList.add(element['name']);
      });

      debugPrint(" list:$deptList");

      // Navigator.push(context,MaterialPageRoute(builder: (context) => AddNewUser(deptList)));
    }
    debugPrint("depts reviewed");
  } else {
    debugPrint("depts not reviewed");
  }
}
