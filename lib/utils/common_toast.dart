import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Notification types supported by CommonToast.
enum ToastType {
  success,
  error,
  warning,
  info,
}

/// Centralized, modern floating toast notification utility for KMSMerino.
///
/// Features:
/// - Floating bottom-positioned notification with generous safe bottom margins.
/// - Rounded corners (14px) with subtle elevation & shadows.
/// - Distinct theme colors for Success, Error, Warning, Info.
/// - Smooth slide-up, fade-in, and fade-out animations.
/// - Automatic dismissal (default 3s) with manual close icon and swipe-to-dismiss.
/// - Deduplication against concurrent spam / duplicate API failures.
/// - Overlap prevention: Gracefully closes previous toast before showing a new one.
class CommonToast {
  CommonToast._();

  static String? _lastMessage;
  static ToastType? _lastType;
  static DateTime? _lastShownTime;

  /// Shows a green floating toast for successful operations.
  static void success(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    bool showCloseButton = true,
  }) {
    show(
      message: message,
      type: ToastType.success,
      title: title,
      duration: duration,
      onTap: onTap,
      showCloseButton: showCloseButton,
    );
  }

  /// Shows a red floating toast for errors and failed operations.
  static void error(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    bool showCloseButton = true,
  }) {
    show(
      message: message,
      type: ToastType.error,
      title: title,
      duration: duration,
      onTap: onTap,
      showCloseButton: showCloseButton,
    );
  }

  /// Shows an orange/amber floating toast for warnings.
  static void warning(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    bool showCloseButton = true,
  }) {
    show(
      message: message,
      type: ToastType.warning,
      title: title,
      duration: duration,
      onTap: onTap,
      showCloseButton: showCloseButton,
    );
  }

  /// Shows a blue floating toast for informational messages.
  static void info(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    bool showCloseButton = true,
  }) {
    show(
      message: message,
      type: ToastType.info,
      title: title,
      duration: duration,
      onTap: onTap,
      showCloseButton: showCloseButton,
    );
  }

  /// Dismisses any currently visible toast immediately.
  static void dismiss() {
    try {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    } catch (_) {}
  }

  /// Centralized network exception and error handler.
  /// Categorizes network failures (SocketException, ClientException, Broken pipe,
  /// Connection reset, timeouts, SSL errors, offline states) into accurate, user-friendly toasts.
  static void handleNetworkError(dynamic error, {String? fallbackMessage}) {
    if (error == null) {
      CommonToast.error(
        fallbackMessage ?? 'Unable to connect to server. Please check your internet connection.',
        title: 'Connection Error',
      );
      return;
    }

    final String errorStr = error.toString().toLowerCase();

    // 1. Connection / Request Timeouts (TimeoutException, connection timeout, receive timeout)
    if (error is TimeoutException ||
        errorStr.contains('timeout') ||
        errorStr.contains('timed out') ||
        errorStr.contains('time out')) {
      CommonToast.error(
        'Server is taking too long to respond.',
        title: 'Server Timeout',
      );
      return;
    }

    // 2. Broken pipe, Connection reset, Connection closed/aborted (OS Error: Broken pipe, errno = 32 / 104 / 54 / 10054)
    if (errorStr.contains('broken pipe') ||
        errorStr.contains('connection reset') ||
        errorStr.contains('connection closed') ||
        errorStr.contains('connection aborted') ||
        errorStr.contains('errno = 32') ||
        errorStr.contains('errno = 104') ||
        errorStr.contains('errno = 54') ||
        errorStr.contains('errno = 10054')) {
      CommonToast.error(
        'Connection interrupted. Please try again.',
        title: 'Connection Interrupted',
      );
      return;
    }

    // 3. SSL / Certificate / Handshake exceptions
    if (error is HandshakeException ||
        errorStr.contains('handshake') ||
        errorStr.contains('certificate') ||
        errorStr.contains('ssl') ||
        errorStr.contains('tls')) {
      CommonToast.error(
        'Secure connection failed. Please check your network or date/time settings.',
        title: 'Security Error',
      );
      return;
    }

    // 4. SocketException & No Internet Connection
    if (error is SocketException ||
        errorStr.contains('socketexception') ||
        errorStr.contains('failed host lookup') ||
        errorStr.contains('no address associated') ||
        errorStr.contains('network is unreachable') ||
        errorStr.contains('network unreachable') ||
        errorStr.contains('no route to host') ||
        errorStr.contains('no internet') ||
        errorStr.contains('errno = 7') ||
        errorStr.contains('errno = 101') ||
        errorStr.contains('errno = 110') ||
        errorStr.contains('errno = 113') ||
        errorStr.contains('errno = 10051') ||
        errorStr.contains('errno = 10060') ||
        errorStr.contains('errno = 10065')) {
      CommonToast.error(
        'Please check your internet connection.',
        title: 'No Internet',
      );
      return;
    }

    // 5. ClientException (package:http)
    if (errorStr.contains('clientexception')) {
      if (errorStr.contains('broken pipe') ||
          errorStr.contains('reset') ||
          errorStr.contains('closed') ||
          errorStr.contains('aborted')) {
        CommonToast.error(
          'Connection interrupted. Please try again.',
          title: 'Connection Interrupted',
        );
        return;
      } else if (errorStr.contains('failed host lookup') ||
          errorStr.contains('network') ||
          errorStr.contains('no address')) {
        CommonToast.error(
          'Please check your internet connection.',
          title: 'No Internet',
        );
        return;
      }
      CommonToast.error(
        fallbackMessage ?? 'Connection interrupted. Please try again.',
        title: 'Connection Error',
      );
      return;
    }

    // 6. Generic Network Fallback
    CommonToast.error(
      fallbackMessage ?? 'Connection interrupted. Please try again.',
      title: 'Connection Error',
    );
  }

  /// Centralized API error response handler.
  /// Parses standard HTTP status codes, Dio/package:http/GetConnect responses,
  /// and shows appropriate floating toast notifications.
  static void handleApiError(
    dynamic response, {
    String? fallbackMessage,
    String? uri,
  }) {
    if (response == null) {
      error(
        fallbackMessage ?? 'Unable to connect to server. Please check your internet connection.',
        title: 'Connection Error',
      );
      return;
    }

    // Direct delegation if an exception or error is passed
    if (response is Exception || response is Error) {
      handleNetworkError(response, fallbackMessage: fallbackMessage);
      return;
    }

    int? statusCode;
    dynamic body;
    String? statusText;

    if (response is Response) {
      statusCode = response.statusCode;
      body = response.body;
      statusText = response.statusText;
    } else if (response is Map) {
      statusCode = response['statusCode'] as int? ?? response['status'] as int?;
      body = response['body'] ?? response['data'] ?? response;
      statusText = response['statusText']?.toString();
    }

    // Connection Timeout / Gateway Timeout (408, 504)
    if (statusCode == 408 || statusCode == 504) {
      error(
        'Server is taking too long to respond.',
        title: 'Server Timeout',
      );
      return;
    }

    // Payload Too Large (413)
    if (statusCode == 413) {
      error(
        'Selected file size is too large for the server. Please choose a smaller file.',
        title: 'File Too Large',
      );
      return;
    }

    // Network / Connection Error (statusCode 0 or 1, or offline / broken pipe message)
    if (statusCode == 0 ||
        statusCode == 1 ||
        (statusText != null &&
            (statusText.toLowerCase().contains('internet') ||
             statusText.toLowerCase().contains('broken pipe') ||
             statusText.toLowerCase().contains('connection')))) {
      if (statusText != null &&
          (statusText.toLowerCase().contains('broken pipe') ||
           statusText.toLowerCase().contains('connection reset') ||
           statusText.toLowerCase().contains('connection interrupted'))) {
        error(
          'Connection interrupted. Please try again.',
          title: 'Connection Interrupted',
        );
        return;
      }
      if (statusText != null && statusText.toLowerCase().contains('timeout')) {
        error(
          'Server is taking too long to respond.',
          title: 'Server Timeout',
        );
        return;
      }
      error(
        'Please check your internet connection.',
        title: 'Connection Error',
      );
      return;
    }

    // 401 Session Expired is typically handled globally via AuthController.
    // If it reaches here, display once:
    if (statusCode == 401) {
      error(
        'Your session has expired. Please log in again.',
        title: 'Session Expired',
      );
      return;
    }

    // 403 Forbidden / Permission Denied
    if (statusCode == 403) {
      warning(
        'You do not have permission to perform this action.',
        title: 'Access Denied',
      );
      return;
    }

    // Extract error message from body if present
    String extractedMessage = '';
    if (body is Map) {
      if (body['message'] != null && body['message'].toString().trim().isNotEmpty) {
        extractedMessage = body['message'].toString().trim();
      } else if (body['error'] != null && body['error'].toString().trim().isNotEmpty) {
        extractedMessage = body['error'].toString().trim();
      } else if (body['data'] is Map && body['data']['error'] != null) {
        extractedMessage = body['data']['error'].toString().trim();
      } else if (body['errors'] is Map) {
        // Validation errors e.g. { errors: { email: ['Invalid email'] } }
        final errorsMap = body['errors'] as Map;
        final List<String> errorLines = [];
        errorsMap.forEach((_, value) {
          if (value is List && value.isNotEmpty) {
            errorLines.add(value.first.toString());
          } else if (value is String) {
            errorLines.add(value);
          }
        });
        if (errorLines.isNotEmpty) {
          extractedMessage = errorLines.join('\n');
        }
      }
    } else if (body is String && body.trim().isNotEmpty && !body.trim().startsWith('<')) {
      extractedMessage = body.trim();
    }

    if (extractedMessage.isEmpty) {
      extractedMessage = statusText ?? fallbackMessage ?? 'An unexpected error occurred.';
    }

    // 422 Validation Error
    if (statusCode == 422) {
      warning(
        extractedMessage,
        title: 'Validation Error',
      );
      return;
    }

    // 500+ Server Errors
    if (statusCode != null && statusCode >= 500) {
      error(
        'Internal server error occurred. Please try again later.',
        title: 'Server Error',
      );
      return;
    }

    // Default error
    error(
      extractedMessage,
      title: 'Error',
    );
  }

  /// Core method to render the styled floating toast.
  static void show({
    required String message,
    required ToastType type,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    bool showCloseButton = true,
  }) {
    final cleanMessage = message.trim();
    if (cleanMessage.isEmpty) return;

    // Deduplication: prevent identical messages from spamming within 1.5s
    final now = DateTime.now();
    if (_lastMessage == cleanMessage &&
        _lastType == type &&
        _lastShownTime != null &&
        now.difference(_lastShownTime!) < const Duration(milliseconds: 1500)) {
      return;
    }
    _lastMessage = cleanMessage;
    _lastType = type;
    _lastShownTime = now;

    // Post-frame callback ensures context and overlays are ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _displayToast(
        message: cleanMessage,
        type: type,
        title: title,
        duration: duration,
        onTap: onTap,
        showCloseButton: showCloseButton,
      );
    });
  }

  static void _displayToast({
    required String message,
    required ToastType type,
    String? title,
    required Duration duration,
    VoidCallback? onTap,
    required bool showCloseButton,
  }) {
    // If a snackbar is currently open, close it cleanly to prevent overlapping
    try {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    } catch (_) {}

    final Color backgroundColor;
    final Color shadowColor;
    final String defaultTitle;

    switch (type) {
      case ToastType.success:
        backgroundColor = const Color(0xFF15803D); // Vibrant emerald/green
        shadowColor = const Color(0xFF15803D);
        defaultTitle = 'Success';
        break;
      case ToastType.error:
        backgroundColor = const Color(0xFFDC2626); // Crimson red
        shadowColor = const Color(0xFFDC2626);
        defaultTitle = 'Error';
        break;
      case ToastType.warning:
        backgroundColor = const Color(0xFFD97706); // Amber / orange
        shadowColor = const Color(0xFFD97706);
        defaultTitle = 'Warning';
        break;
      case ToastType.info:
        backgroundColor = const Color(0xFF2563EB); // Royal blue
        shadowColor = const Color(0xFF2563EB);
        defaultTitle = 'Information';
        break;
    }

    final effectiveTitle = title ?? defaultTitle;
    final hasTitle = effectiveTitle.isNotEmpty;

    Get.rawSnackbar(
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 14,
      backgroundColor: backgroundColor,
      borderColor: Colors.white.withValues(alpha: 0.18),
      borderWidth: 1.0,
      duration: duration,
      animationDuration: const Duration(milliseconds: 320),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      isDismissible: true,
      dismissDirection: DismissDirection.down,
      boxShadows: [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.32),
          blurRadius: 18,
          offset: const Offset(0, 4),
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.14),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
      titleText: hasTitle
          ? Text(
              effectiveTitle,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            )
          : const SizedBox.shrink(),
      messageText: Text(
        message,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 13,
          fontWeight: hasTitle ? FontWeight.w400 : FontWeight.w500,
          color: Colors.white.withValues(alpha: 0.95),
          height: 1.35,
        ),
        softWrap: true,
      ),
      mainButton: showCloseButton
          ? GestureDetector(
              onTap: () {
                try {
                  if (Get.isSnackbarOpen) {
                    Get.closeCurrentSnackbar();
                  }
                } catch (_) {}
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 2.0),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            )
          : null,
      onTap: onTap != null ? (_) => onTap() : null,
    );
  }
}

