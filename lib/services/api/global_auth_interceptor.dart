import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:kmsmerino/controller/auth_controller.dart';
import 'package:kmsmerino/services/api/api_config.dart';

/// Global HTTP client interceptor that automatically monitors all network traffic
/// across the application (including ApiClient, package:http, and Dio requests).
///
/// Automatically intercepts:
/// 1. HTTP 401 Unauthorized responses.
/// 2. Responses whose body contains Laravel's `{"message": "Unauthenticated."}`.
///
/// When detected, immediately triggers centralized session invalidation and redirects
/// the user to the Login screen, while ignoring duplicate triggers during logout.
class GlobalAuthInterceptorHttpClient implements HttpClient {
  final HttpClient _inner;

  GlobalAuthInterceptorHttpClient(this._inner);

  @override
  bool get autoUncompress => _inner.autoUncompress;
  @override
  set autoUncompress(bool value) => _inner.autoUncompress = value;

  @override
  Duration? get connectionTimeout => _inner.connectionTimeout;
  @override
  set connectionTimeout(Duration? value) => _inner.connectionTimeout = value;

  @override
  Duration get idleTimeout => _inner.idleTimeout;
  @override
  set idleTimeout(Duration value) => _inner.idleTimeout = value;

  @override
  int? get maxConnectionsPerHost => _inner.maxConnectionsPerHost;
  @override
  set maxConnectionsPerHost(int? value) => _inner.maxConnectionsPerHost = value;

  @override
  String? get userAgent => _inner.userAgent;
  @override
  set userAgent(String? value) => _inner.userAgent = value;

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) =>
      _inner.addCredentials(url, realm, credentials);

  @override
  void addProxyCredentials(
      String host, int port, String realm, HttpClientCredentials credentials) =>
      _inner.addProxyCredentials(host, port, realm, credentials);

  @override
  set connectionFactory(
          Future<ConnectionTask<Socket>> Function(
                  Uri url, String? proxyHost, int? proxyPort)?
              f) =>
      _inner.connectionFactory = f;

  @override
  set keyLog(Function(String line)? callback) => _inner.keyLog = callback;

  @override
  set authenticate(Future<bool> Function(Uri url, String realm, String? account)? f) =>
      _inner.authenticate = f;

  @override
  set authenticateProxy(Future<bool> Function(String host, int port, String realm, String? account)? f) =>
      _inner.authenticateProxy = f;

  @override
  set badCertificateCallback(bool Function(X509Certificate cert, String host, int port)? callback) =>
      _inner.badCertificateCallback = callback;

  @override
  set findProxy(String Function(Uri url)? f) => _inner.findProxy = f;

  @override
  void close({bool force = false}) => _inner.close(force: force);

  @override
  dynamic noSuchMethod(Invocation invocation) => _inner.noSuchMethod(invocation);

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    final request = await _inner.openUrl(method, url);
    return _GlobalAuthInterceptorRequest(request, url);
  }

  @override
  Future<HttpClientRequest> open(String method, String host, int port, String path) {
    final uri = Uri(scheme: 'https', host: host, port: port, path: path);
    return openUrl(method, uri);
  }

  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      open('GET', host, port, path);

  @override
  Future<HttpClientRequest> getUrl(Uri url) => openUrl('GET', url);

  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      open('POST', host, port, path);

  @override
  Future<HttpClientRequest> postUrl(Uri url) => openUrl('POST', url);

  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      open('PUT', host, port, path);

  @override
  Future<HttpClientRequest> putUrl(Uri url) => openUrl('PUT', url);

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      open('DELETE', host, port, path);

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => openUrl('DELETE', url);

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      open('PATCH', host, port, path);

  @override
  Future<HttpClientRequest> patchUrl(Uri url) => openUrl('PATCH', url);

  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      open('HEAD', host, port, path);

  @override
  Future<HttpClientRequest> headUrl(Uri url) => openUrl('HEAD', url);
}

class _GlobalAuthInterceptorRequest implements HttpClientRequest {
  final HttpClientRequest _inner;
  final Uri _uri;

  _GlobalAuthInterceptorRequest(this._inner, this._uri);

  @override
  Encoding get encoding => _inner.encoding;
  @override
  set encoding(Encoding value) => _inner.encoding = value;

  @override
  int get contentLength => _inner.contentLength;
  @override
  set contentLength(int value) => _inner.contentLength = value;

  @override
  bool get bufferOutput => _inner.bufferOutput;
  @override
  set bufferOutput(bool value) => _inner.bufferOutput = value;

  @override
  bool get persistentConnection => _inner.persistentConnection;
  @override
  set persistentConnection(bool value) => _inner.persistentConnection = value;

  @override
  bool get followRedirects => _inner.followRedirects;
  @override
  set followRedirects(bool value) => _inner.followRedirects = value;

  @override
  int get maxRedirects => _inner.maxRedirects;
  @override
  set maxRedirects(int value) => _inner.maxRedirects = value;

  @override
  HttpHeaders get headers => _inner.headers;

  @override
  HttpConnectionInfo? get connectionInfo => _inner.connectionInfo;

  @override
  List<Cookie> get cookies => _inner.cookies;

  @override
  Future<HttpClientResponse> get done => _inner.done;

  @override
  String get method => _inner.method;

  @override
  Uri get uri => _uri;

  @override
  void abort([Object? exception, StackTrace? stackTrace]) =>
      _inner.abort(exception, stackTrace);

  @override
  void add(List<int> data) => _inner.add(data);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _inner.addError(error, stackTrace);

  @override
  Future addStream(Stream<List<int>> stream) => _inner.addStream(stream);

  @override
  Future<HttpClientResponse> close() async {
    final response = await _inner.close();

    final isLogin = _uri.path.contains(ApiConfig.loginEndpoint);

    // Fast-path: immediate detection of HTTP 401
    if (response.statusCode == 401 && !isLogin) {
      debugPrint('🚨 [GlobalAuthInterceptor] Detected HTTP 401 on ${_uri.path}');
      AuthController.handleSessionExpiredGlobally();
      return response;
    }

    // Secondary-path: wrap response to inspect body for Laravel's Unauthenticated message
    if (!isLogin) {
      return _GlobalAuthInterceptorResponse(response, _uri);
    }

    return response;
  }

  @override
  void write(Object? object) => _inner.write(object);

  @override
  void writeAll(Iterable objects, [String separator = '']) =>
      _inner.writeAll(objects, separator);

  @override
  void writeCharCode(int charCode) => _inner.writeCharCode(charCode);

  @override
  void writeln([Object? object = '']) => _inner.writeln(object);

  @override
  Future flush() => _inner.flush();

  @override
  dynamic noSuchMethod(Invocation invocation) => _inner.noSuchMethod(invocation);
}

class _GlobalAuthInterceptorResponse extends Stream<List<int>> implements HttpClientResponse {
  final HttpClientResponse _inner;
  final Uri _uri;
  bool _checked = false;
  final List<int> _inspectionBuffer = [];

  _GlobalAuthInterceptorResponse(this._inner, this._uri);

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final StreamController<List<int>> controller = StreamController<List<int>>();

    _inner.listen(
      (chunk) {
        if (!_checked) {
          _inspectionBuffer.addAll(chunk);
          if (_inspectionBuffer.length >= 512 ||
              (_inner.contentLength != -1 && _inspectionBuffer.length >= _inner.contentLength)) {
            _inspectBuffer();
          }
        }
        controller.add(chunk);
      },
      onError: (err, st) {
        controller.addError(err, st);
      },
      onDone: () {
        if (!_checked) {
          _inspectBuffer();
        }
        controller.close();
      },
      cancelOnError: cancelOnError,
    );

    return controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void _inspectBuffer() {
    _checked = true;
    try {
      if (_inspectionBuffer.isEmpty) return;
      final int takeCount = _inspectionBuffer.length > 1024 ? 1024 : _inspectionBuffer.length;
      final String text = utf8.decode(_inspectionBuffer.sublist(0, takeCount), allowMalformed: true);

      // Check for Laravel's unauthenticated body
      if (text.contains('"message":"Unauthenticated."') ||
          text.contains('"message": "Unauthenticated."') ||
          text.contains('"message":"Unauthenticated"') ||
          text.contains('"message": "Unauthenticated"') ||
          text.contains('"message":"unauthenticated."') ||
          text.contains('"message": "unauthenticated."')) {
        debugPrint('🚨 [GlobalAuthInterceptor] Detected Unauthenticated body on ${_uri.path}');
        AuthController.handleSessionExpiredGlobally();
      }
    } catch (e) {
      debugPrint('⚠️ [GlobalAuthInterceptor] Buffer inspection error: $e');
    }
  }

  @override
  int get statusCode => _inner.statusCode;
  @override
  String get reasonPhrase => _inner.reasonPhrase;
  @override
  int get contentLength => _inner.contentLength;
  @override
  HttpClientResponseCompressionState get compressionState => _inner.compressionState;
  @override
  HttpHeaders get headers => _inner.headers;
  @override
  List<Cookie> get cookies => _inner.cookies;
  @override
  X509Certificate? get certificate => _inner.certificate;
  @override
  HttpConnectionInfo? get connectionInfo => _inner.connectionInfo;
  @override
  bool get isRedirect => _inner.isRedirect;
  @override
  bool get persistentConnection => _inner.persistentConnection;
  @override
  List<RedirectInfo> get redirects => _inner.redirects;

  @override
  Future<HttpClientResponse> redirect([String? method, Uri? url, bool? followLoops]) =>
      _inner.redirect(method, url, followLoops);

  @override
  Future<Socket> detachSocket() => _inner.detachSocket();

  @override
  dynamic noSuchMethod(Invocation invocation) => _inner.noSuchMethod(invocation);
}

