// ignore_for_file: library_prefixes

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as Http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmsmerino/controller/auth_controller.dart';
import 'package:kmsmerino/models/error_response.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/utils/app_constants.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetxService {

  final SharedPreferences sharedPreferences;

  static const String noInternetMessage = 'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  Map<String, String> _mainHeaders = {};

  ApiClient({required this.sharedPreferences}) {
    // Check if token exists before using it
    String? token = sharedPreferences.getString(AppConstants.TOKEN);
    if (token != null) {
      updateHeader(token);
    } else {
      // Set default headers without authorization
      _mainHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
    }
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
  }

  void clearHeader() {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      
      // Build the full URI
      String fullUri;
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        fullUri = uri; // Use the absolute URL as-is
      } else {
        fullUri = ApiConfig.baseUrl + uri; // Concatenate with appropriate base URL
      }
      
      Http.Response response = await Http.get(
        Uri.parse(fullUri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('====> API Error: $e');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      
      // Build the full URI
      String fullUri;
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        fullUri = uri; // Use the absolute URL as-is
      } else {
        fullUri = ApiConfig.baseUrl + uri; // Concatenate with appropriate base URL
      }
      
      Http.Response response = await Http.post(
        Uri.parse(fullUri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('====> API Error: $e');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(String uri, Map<String, String> body, List<MultipartBody> multipartBody, {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      
      // Build the full URI
      String fullUri;
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        fullUri = uri; // Use the absolute URL as-is
      } else {
        fullUri = ApiConfig.baseUrl + uri; // Concatenate with appropriate base URL
      }
      
      Http.MultipartRequest request = Http.MultipartRequest('POST', Uri.parse(fullUri));
      request.headers.addAll(headers ?? _mainHeaders);
      for(MultipartBody multipart in multipartBody) {
        if(Foundation.kIsWeb) {
          Uint8List list = await multipart.file.readAsBytes();
          Http.MultipartFile part = Http.MultipartFile(
            multipart.key, multipart.file.readAsBytes().asStream(), list.length,
            filename: basename(multipart.file.path), contentType: MediaType('image', 'jpg'),
          );
          request.files.add(part);
        }else {
          File file = File(multipart.file.path);
          request.files.add(Http.MultipartFile(
            multipart.key, file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last,
          ));
        }
      }
      request.fields.addAll(body);
      Http.Response response = await Http.Response.fromStream(await request.send());
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('====> API Error: $e');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      
      // Build the full URI
      String fullUri;
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        fullUri = uri; // Use the absolute URL as-is
      } else {
        fullUri = ApiConfig.baseUrl + uri; // Concatenate with appropriate base URL
      }
      
      Http.Response response = await Http.put(
        Uri.parse(fullUri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('====> API Error: $e');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> patchData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      
      // Build the full URI
      String fullUri;
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        fullUri = uri; // Use the absolute URL as-is
      } else {
        fullUri = ApiConfig.baseUrl + uri; // Concatenate with appropriate base URL
      }
      
      Http.Response response = await Http.patch(
        Uri.parse(fullUri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('====> API Error: $e');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri, {Map<String, String>? headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      
      // Build the full URI
      String fullUri;
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        fullUri = uri; // Use the absolute URL as-is
      } else {
        fullUri = ApiConfig.baseUrl + uri; // Concatenate with appropriate base URL
      }
      
      Http.Response response = await Http.delete(
        Uri.parse(fullUri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('====> API Error: $e');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  /// Determines if an HTTP response represents an unauthenticated/expired session.
  /// Explicitly excludes the login endpoint so failed credentials show error messages
  /// without triggering an automatic logout loop.
  static bool isUnauthenticatedResponse(int? statusCode, dynamic body, {String? uri}) {
    if (uri != null && uri.contains(ApiConfig.loginEndpoint)) {
      return false;
    }

    // 1. Direct HTTP 401 Unauthorized status code
    if (statusCode == 401) {
      return true;
    }

    // 2. Response body inspection for Laravel's standard Unauthenticated message
    if (body != null) {
      if (body is Map) {
        final message = body['message']?.toString().trim();
        if (message != null &&
            (message == 'Unauthenticated.' ||
             message == 'Unauthenticated' ||
             message.toLowerCase() == 'unauthenticated.' ||
             message.toLowerCase() == 'unauthenticated')) {
          return true;
        }
        final error = body['error']?.toString().trim();
        if (error != null &&
            (error == 'Unauthenticated.' ||
             error == 'Unauthenticated' ||
             error.toLowerCase() == 'unauthenticated.' ||
             error.toLowerCase() == 'unauthenticated')) {
          return true;
        }
      } else if (body is String) {
        final trimmed = body.trim();
        if (trimmed.contains('"message":"Unauthenticated."') ||
            trimmed.contains('"message": "Unauthenticated."') ||
            trimmed.contains('"message":"Unauthenticated"') ||
            trimmed.contains('"message": "Unauthenticated"') ||
            trimmed.contains('"message":"unauthenticated."') ||
            trimmed.contains('"message": "unauthenticated."')) {
          return true;
        }
      }
    }

    return false;
  }

  Response handleResponse(Http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      // Body might not be JSON (e.g. plain text or HTML error page)
    }
    Response response0 = Response(
      body: body ?? response.body, bodyString: response.body.toString(),
      request: Request(headers: response.request!.headers, method: response.request!.method, url: response.request!.url),
      headers: response.headers, statusCode: response.statusCode, statusText: response.reasonPhrase,
    );

    // Global centralized detection for HTTP 401 / Laravel Unauthenticated responses
    if (isUnauthenticatedResponse(response0.statusCode, response0.body, uri: uri)) {
      debugPrint('🚨 [ApiClient] Detected 401 / Unauthenticated response on $uri');
      AuthController.handleSessionExpiredGlobally();
      return Response(
        statusCode: 401,
        body: response0.body,
        statusText: 'Your session has expired. Please log in again.',
        request: response0.request,
        headers: response0.headers,
      );
    }

    if(response0.statusCode != 200 && response0.body != null && response0.body is !String) {
      if(response0.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
        response0 = Response(statusCode: response0.statusCode, body: response0.body, statusText: errorResponse.errors[0].message);
      } else if (response0.body is Map && response0.body['message'] != null && response0.body['message'].toString().trim().isNotEmpty) {
        String msg = response0.body['message'].toString().trim();
        if (msg.toLowerCase().contains('unauthori')) {
          msg = 'Account not found or invalid credentials.';
        }
        response0 = Response(statusCode: response0.statusCode, body: response0.body, statusText: msg);
      } else if(response0.body.toString().startsWith('{message')) {
        String msg = response0.body['message']?.toString() ?? '';
        if (msg.toLowerCase().contains('unauthori')) {
          msg = 'Account not found or invalid credentials.';
        }
        response0 = Response(statusCode: response0.statusCode, body: response0.body, statusText: msg);
      } else if (response0.body is Map && response0.body['data'] != null && response0.body['data'] is Map && response0.body['data']['error'] != null) {
        // Handle error messages in data.error format
        String errorMsg = response0.body['data']['error'].toString();
        if (errorMsg.toLowerCase().contains('unauthori')) {
          errorMsg = 'Account not found or invalid credentials.';
        }
        response0 = Response(statusCode: response0.statusCode, body: response0.body, statusText: errorMsg);
      }
    }else if(response0.statusCode != 200 && response0.body == null) {
      response0 = Response(statusCode: 0, statusText: noInternetMessage);
    }
    debugPrint('====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    return response0;
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
