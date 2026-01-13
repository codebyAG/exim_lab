import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

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
}) async {
  log("➡️ API URL: $url");
  if (requestData != null) {
    log("➡️ REQUEST DATA: $requestData");
  }

  final options = Options(
    headers: headers,
    contentType: contentType,
    followRedirects: true,
    receiveTimeout: const Duration(seconds: 60),
    method: methodType.methodType,
  );

  final dio = Dio();

  // 🔐 SSL handling (for dev / staging)
  (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
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
    throw ApiException(
      message: dioExceptionMessage(e.type),
      statusCode: e.response?.statusCode,
    );
  } catch (e) {
    log("❌ UNKNOWN ERROR: $e");
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
  post("POST");

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
