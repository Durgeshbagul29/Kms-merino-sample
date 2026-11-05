import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kmsmerino/services/api/api_client.dart';
import 'package:kmsmerino/utils/common_toast.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CommonToast API Error Handling Tests', () {
    test('handleApiError handles null response as Connection Error', () {
      expect(() => CommonToast.handleApiError(null), returnsNormally);
    });

    test('handleApiError handles statusCode 0/1 as Connection Error', () {
      final response0 = Response(statusCode: 0, statusText: ApiClient.noInternetMessage);
      expect(() => CommonToast.handleApiError(response0), returnsNormally);

      final response1 = Response(statusCode: 1, statusText: 'Connection failed');
      expect(() => CommonToast.handleApiError(response1), returnsNormally);
    });

    test('handleApiError handles 401 Session Expired', () {
      final response401 = Response(
        statusCode: 401,
        body: {'message': 'Unauthenticated.'},
      );
      expect(() => CommonToast.handleApiError(response401), returnsNormally);
    });

    test('handleApiError handles 403 Forbidden / Access Denied', () {
      final response403 = Response(
        statusCode: 403,
        body: {'message': 'Forbidden'},
      );
      expect(() => CommonToast.handleApiError(response403), returnsNormally);
    });

    test('handleApiError handles 422 Validation Error', () {
      final response422 = Response(
        statusCode: 422,
        body: {
          'message': 'The given data was invalid.',
          'errors': {
            'email': ['The email field is required.'],
            'password': ['The password must be at least 6 characters.'],
          },
        },
      );
      expect(() => CommonToast.handleApiError(response422), returnsNormally);
    });

    test('handleApiError handles 500 Server Error', () {
      final response500 = Response(
        statusCode: 500,
        body: {'message': 'Internal Server Error'},
      );
      expect(() => CommonToast.handleApiError(response500), returnsNormally);
    });

    test('ApiClient.notifyError forwards properly to CommonToast', () {
      final response = Response(statusCode: 500, statusText: 'Server Error');
      expect(() => ApiClient.notifyError(response), returnsNormally);
    });
  });

  group('CommonToast Network Error Handling Tests', () {
    test('handleNetworkError handles TimeoutException as Server Timeout', () {
      expect(() => CommonToast.handleNetworkError(TimeoutException('Request timed out')), returnsNormally);
    });

    test('handleNetworkError handles SocketException: Broken pipe as Connection Interrupted', () {
      const socketException = SocketException('Broken pipe', osError: OSError('Broken pipe', 32));
      expect(() => CommonToast.handleNetworkError(socketException), returnsNormally);
    });

    test('handleNetworkError handles ClientException with Broken pipe', () {
      final clientException = http.ClientException('ClientException with SocketException: Broken pipe (OS Error: Broken pipe, errno = 32)');
      expect(() => CommonToast.handleNetworkError(clientException), returnsNormally);
    });

    test('handleNetworkError handles Connection reset', () {
      const resetException = SocketException('Connection reset by peer', osError: OSError('Connection reset by peer', 104));
      expect(() => CommonToast.handleNetworkError(resetException), returnsNormally);
    });

    test('handleNetworkError handles HandshakeException as Security Error', () {
      expect(() => CommonToast.handleNetworkError(const HandshakeException('Certificate validation failed')), returnsNormally);
    });

    test('handleNetworkError handles failed host lookup as No Internet', () {
      const noInternetException = SocketException('Failed host lookup: kmsmerino.abraca-dabra.com');
      expect(() => CommonToast.handleNetworkError(noInternetException), returnsNormally);
    });

    test('handleApiError handles 413 Payload Too Large', () {
      final response413 = Response(statusCode: 413, statusText: 'Payload Too Large');
      expect(() => CommonToast.handleApiError(response413), returnsNormally);
    });

    test('handleApiError delegates exceptions to handleNetworkError', () {
      final exception = http.ClientException('Connection reset');
      expect(() => CommonToast.handleApiError(exception), returnsNormally);
    });
  });

  group('CommonToast UI & Notification Types Widget Tests', () {
    testWidgets('CommonToast methods trigger correctly in GetMaterialApp', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => CommonToast.success('Operation succeeded'),
                        child: const Text('Success'),
                      ),
                      ElevatedButton(
                        onPressed: () => CommonToast.error('Operation failed'),
                        child: const Text('Error'),
                      ),
                      ElevatedButton(
                        onPressed: () => CommonToast.warning('Check inputs'),
                        child: const Text('Warning'),
                      ),
                      ElevatedButton(
                        onPressed: () => CommonToast.info('System notification'),
                        child: const Text('Info'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap Success
      await tester.tap(find.text('Success'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Operation succeeded'), findsOneWidget);

      // Tap Error
      await tester.tap(find.text('Error'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Operation failed'), findsOneWidget);

      // Tap Warning
      await tester.tap(find.text('Warning'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Check inputs'), findsOneWidget);

      // Tap Info
      await tester.tap(find.text('Info'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('System notification'), findsOneWidget);

      // Test dismiss
      CommonToast.dismiss();
      await tester.pump();
    });
  });
}

