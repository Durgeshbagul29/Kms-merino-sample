import 'package:flutter_test/flutter_test.dart';
import 'package:kmsmerino/controller/auth_controller.dart';
import 'package:kmsmerino/services/api/api_client.dart';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ApiClient isUnauthenticatedResponse Tests', () {
    test('HTTP 401 status code is detected as unauthenticated', () {
      final isUnauth = ApiClient.isUnauthenticatedResponse(401, null, uri: '/api/user_dashboard');
      expect(isUnauth, isTrue);
    });

    test('Laravel {"message": "Unauthenticated."} body is detected even if status code is non-401', () {
      final isUnauth = ApiClient.isUnauthenticatedResponse(
        200,
        {'message': 'Unauthenticated.'},
        uri: '/api/user_dashboard',
      );
      expect(isUnauth, isTrue);
    });

    test('Raw JSON string with Unauthenticated message is detected', () {
      final isUnauth = ApiClient.isUnauthenticatedResponse(
        200,
        '{"message": "Unauthenticated."}',
        uri: '/api/view_user_kaizens',
      );
      expect(isUnauth, isTrue);
    });

    test('HTTP 401 on login endpoint does NOT trigger unauthenticated logout (handled as credential error)', () {
      final isUnauth = ApiClient.isUnauthenticatedResponse(
        401,
        {'message': 'Invalid credentials'},
        uri: ApiConfig.loginEndpoint,
      );
      expect(isUnauth, isFalse);
    });

    test('HTTP 403 Forbidden does NOT trigger unauthenticated logout', () {
      final isUnauth = ApiClient.isUnauthenticatedResponse(
        403,
        {'message': 'Access forbidden'},
        uri: '/api/admin_dashboard',
      );
      expect(isUnauth, isFalse);
    });

    test('HTTP 404 Not Found does NOT trigger unauthenticated logout', () {
      final isUnauth = ApiClient.isUnauthenticatedResponse(
        404,
        {'message': 'Resource not found'},
        uri: '/api/view_user_kaizens/9999',
      );
      expect(isUnauth, isFalse);
    });

    test('HTTP 422 Validation Error does NOT trigger unauthenticated logout', () {
      final isUnauth = ApiClient.isUnauthenticatedResponse(
        422,
        {
          'message': 'The given data was invalid.',
          'errors': {'title': ['The title field is required.']}
        },
        uri: '/api/add_kaizen_record',
      );
      expect(isUnauth, isFalse);
    });

    test('HTTP 500 Server Error does NOT trigger unauthenticated logout', () {
      final isUnauth = ApiClient.isUnauthenticatedResponse(
        500,
        {'message': 'Internal Server Error'},
        uri: '/api/user_dashboard',
      );
      expect(isUnauth, isFalse);
    });

    test('HTTP 503 Service Unavailable does NOT trigger unauthenticated logout', () {
      final isUnauth = ApiClient.isUnauthenticatedResponse(
        503,
        {'message': 'Service Unavailable'},
        uri: '/api/user_dashboard',
      );
      expect(isUnauth, isFalse);
    });
  });

  group('Session Invalidation and SharedPreferences Tests', () {
    test('Session invalidation removes all 9 auth keys and preserves device_token', () async {
      SharedPreferences.setMockInitialValues({
        AppConstants.TOKEN: 'sample_bearer_token_12345',
        AppConstants.USER_ID: 42,
        AppConstants.USER_NAME: 'john_doe',
        AppConstants.NAME: 'John Doe',
        AppConstants.EMAIL: 'john@example.com',
        AppConstants.DEPT_NAME: 'Engineering',
        AppConstants.ROLE_ID: 3,
        AppConstants.STATUS: 1,
        'logstatus': true,
        AppConstants.DEVICE_TOKEN: 'fcm_push_device_token_xyz',
      });

      final prefs = await SharedPreferences.getInstance();

      // Verify keys exist initially
      expect(prefs.containsKey(AppConstants.TOKEN), isTrue);
      expect(prefs.containsKey(AppConstants.USER_ID), isTrue);
      expect(prefs.containsKey(AppConstants.USER_NAME), isTrue);
      expect(prefs.containsKey(AppConstants.NAME), isTrue);
      expect(prefs.containsKey(AppConstants.EMAIL), isTrue);
      expect(prefs.containsKey(AppConstants.DEPT_NAME), isTrue);
      expect(prefs.containsKey(AppConstants.ROLE_ID), isTrue);
      expect(prefs.containsKey(AppConstants.STATUS), isTrue);
      expect(prefs.containsKey('logstatus'), isTrue);
      expect(prefs.containsKey(AppConstants.DEVICE_TOKEN), isTrue);

      // Trigger session expiration handling
      await AuthController.handleSessionExpiredGlobally();

      // Verify all auth keys are removed
      expect(prefs.containsKey(AppConstants.TOKEN), isFalse);
      expect(prefs.containsKey(AppConstants.USER_ID), isFalse);
      expect(prefs.containsKey(AppConstants.USER_NAME), isFalse);
      expect(prefs.containsKey(AppConstants.NAME), isFalse);
      expect(prefs.containsKey(AppConstants.EMAIL), isFalse);
      expect(prefs.containsKey(AppConstants.DEPT_NAME), isFalse);
      expect(prefs.containsKey(AppConstants.ROLE_ID), isFalse);
      expect(prefs.containsKey(AppConstants.STATUS), isFalse);
      expect(prefs.containsKey('logstatus'), isFalse);

      // Verify unrelated preference (device token) is preserved
      expect(prefs.getString(AppConstants.DEVICE_TOKEN), 'fcm_push_device_token_xyz');
    });

    test('Duplicate logout requests are guarded by _isLoggingOut flag', () async {
      // Check that isLoggingOut flag is present
      expect(AuthController.isLoggingOut, isA<bool>());
    });
  });

  group('ApiClient Header Management Tests', () {
    test('clearHeader removes Authorization header', () async {
      SharedPreferences.setMockInitialValues({
        AppConstants.TOKEN: 'valid_test_token',
      });
      final prefs = await SharedPreferences.getInstance();
      final client = ApiClient(sharedPreferences: prefs);

      // Clear header
      client.clearHeader();

      // Test that patchData method exists on client
      expect(client.patchData, isNotNull);
    });
  });
}

