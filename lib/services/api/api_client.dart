// ignore_for_file: library_prefixes

import 'dart:async';
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
import 'package:kmsmerino/utils/common_toast.dart';
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

  String _parseNetworkErrorMessage(dynamic e) {
    final String errorStr = e.toString().toLowerCase();
    if (e is TimeoutException || errorStr.contains('timeout') || errorStr.contains('timed out')) {
      return 'Server is taking too long to respond.';
    }
    if (errorStr.contains('broken pipe') ||
        errorStr.contains('connection reset') ||
        errorStr.contains('connection closed') ||
        errorStr.contains('errno = 32') ||
        errorStr.contains('errno = 104')) {
      return 'Connection interrupted. Please try again.';
    }
    if (e is HandshakeException || errorStr.contains('handshake') || errorStr.contains('certificate')) {
      return 'Secure connection failed. Please check your network or date/time settings.';
    }
    if (e is SocketException || errorStr.contains('socketexception') || errorStr.contains('failed host lookup')) {
      return 'Please check your internet connection.';
    }
    return noInternetMessage;
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
      return Response(statusCode: 1, statusText: _parseNetworkErrorMessage(e));
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
      return Response(statusCode: 1, statusText: _parseNetworkErrorMessage(e));
    }
  }

  Future<Response> postMultipartData(String uri, Map<String, String> body, List<MultipartBody> multipartBody, {Map<String, String>? headers}) async {
    final Http.Client client = Http.Client();
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
      request.headers['Connection'] = 'close';
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
          if (await file.exists()) {
            final String ext = extension(file.path).toLowerCase().replaceAll('.', '');
            final MediaType mediaType = ext == 'png'
                ? MediaType('image', 'png')
                : (ext == 'webp' ? MediaType('image', 'webp') : MediaType('image', 'jpeg'));
            request.files.add(await Http.MultipartFile.fromPath(
              multipart.key,
              file.path,
              filename: basename(file.path),
              contentType: mediaType,
            ));
          }
        }
      }
      request.fields.addAll(body);
      final streamedResponse = await client.send(request).timeout(Duration(seconds: timeoutInSeconds));
      Http.Response response = await Http.Response.fromStream(streamedResponse).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('====> API Error: $e');
      return Response(statusCode: 1, statusText: _parseNetworkErrorMessage(e));
    } finally {
      client.close();
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
      return Response(statusCode: 1, statusText: _parseNetworkErrorMessage(e));
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
      return Response(statusCode: 1, statusText: _parseNetworkErrorMessage(e));
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
      return Response(statusCode: 1, statusText: _parseNetworkErrorMessage(e));
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

  /// Centralized helper to notify user of API errors using [CommonToast].
  /// Accurately differentiates 401 (session expired), 403 (forbidden),
  /// 422 (validation errors), 500+ (server errors), and network errors.
  static void notifyError(Response response, {String? fallbackMessage}) {
    CommonToast.handleApiError(response, fallbackMessage: fallbackMessage);
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
