import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:io';
import 'package:exim_lab/core/services/shared_pref_service.dart';
import 'package:exim_lab/core/services/analytics_service.dart';
import 'dart:developer';

Future<T> callApi<T>(
  String url, {
  required T Function(dynamic json) parser,
  Map<String, dynamic>? requestData,
  Map<String, dynamic>? headers,
  Map<String, dynamic>? queryParameters,
  CancelToken? token,
  String contentType = 'application/json',
  MethodType methodType = MethodType.get,
  ProgressCallback? progressCallback,
  bool logErrorEvent = true, // Added to prevent analytics recursion
}) async {
  log("➡️ API URL: $url");
  if (requestData != null) {
    log("➡️ REQUEST DATA: $requestData");
  }

  // 🛡️ Add Bearer Token if available
  final sharedPref = SharedPrefService();
  final authToken = await sharedPref.getToken();

  final Map<String, dynamic> finalHeaders = headers ?? {};
  if (authToken != null && authToken.isNotEmpty) {
    finalHeaders['Authorization'] = 'Bearer $authToken';
  }

  final options = Options(
    headers: finalHeaders,
    contentType: contentType,
    followRedirects: true,
    receiveTimeout: const Duration(seconds: 60),
    method: methodType.methodType,
  );

  final dio = Dio();

  // 🔐 SSL handling (for dev / staging)
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  };

  try {
    final response = await dio.request(
      url,
      data: methodType == MethodType.get ? null : requestData,
      options: options,
      queryParameters: queryParameters,
      cancelToken: token,
      onSendProgress: progressCallback,
      onReceiveProgress: progressCallback,
    );

    log("✅ RESPONSE (${response.statusCode}): ${response.data}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return parser(response.data);
    } else {
      throw ApiException(
        message: 'Unexpected server response',
        statusCode: response.statusCode,
      );
    }
  } on DioException catch (e) {
    log("❌ DIO ERROR: ${e.message}");
    if (e.response?.data != null) {
      log("❌ DIO ERROR DATA: ${e.response?.data}");
    }

    String errorMessage = dioExceptionMessage(e.type);

    // 🔍 Extract server-provided error message if available (e.g. 400 Bad Request)
    if (e.response?.data != null && e.response?.data is Map) {
      final resData = e.response?.data as Map;
      final serverMsg =
          resData['message'] ?? resData['msg'] ?? resData['status'];
      if (serverMsg != null && serverMsg is String) {
        errorMessage = serverMsg;
      }
    }

    // 📊 LOG ERROR (if not suppressed)
    if (logErrorEvent) {
      AnalyticsService().logError(message: 'Dio Error: $errorMessage at $url');
    }

    throw ApiException(
      message: errorMessage,
      statusCode: e.response?.statusCode,
    );
  } catch (e) {
    log("❌ UNKNOWN ERROR: $e");
    // 📊 LOG ERROR (if not suppressed)
    if (logErrorEvent) {
      AnalyticsService().logError(message: 'Unknown Error: $e at $url');
    }

    throw ApiException(message: 'Something went wrong');
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

enum MethodType {
  get("GET"),
  post("POST"),
  put("PUT"),
  patch("PATCH"),
  delete("DELETE");

  final String methodType;

  const MethodType(this.methodType);
}

String dioExceptionMessage(DioExceptionType type) {
  switch (type) {
    case DioExceptionType.connectionTimeout:
      return 'Connection timeout. Please try again.';
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Request timed out. Please try again.';
    case DioExceptionType.connectionError:
      return 'No internet connection.';
    case DioExceptionType.cancel:
      return 'Request cancelled.';
    default:
      return 'Something went wrong. Please try again.';
  }
}
