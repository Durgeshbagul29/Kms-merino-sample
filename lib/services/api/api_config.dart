class ApiConfig {
  // Change this to your actual API base URL
  static const String baseUrl = 'https://kmsmerino.abraca-dabra.com';

  static const String loginEndpoint = '/api/login';

  // Combined URLs
  static String get loginUrl => '$baseUrl$loginEndpoint';
}
