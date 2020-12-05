import 'dart:io';
import 'dart:async';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class ServerUnreachableError implements Exception {
  final Exception innerException;
  ServerUnreachableError(this.innerException);
}

class BackendService {
  final _baseUrl = "https://192.168.178.27:5556/";

  Dio _getDio() {
    var dio = Dio();
    dio.options.baseUrl = _baseUrl;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    return dio;
  }

  Future<Response<String>> get(String enpoint) async {
    try {
      final response =
          await _getDio().get<String>(enpoint).timeout(Duration(seconds: 5));
      return response;
    } on TimeoutException catch (e) {
      throw ServerUnreachableError(e);
    } on DioError catch (e) {
      if (e.response != null) throw e;
      throw ServerUnreachableError(e);
    }
  }

  Future<Response<String>> post(dynamic data, String endpoint) async {
    try {
      final response = await _getDio().post<String>(endpoint, data: data);
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        throw e;
      }
      throw ServerUnreachableError(e);
    }
  }

  Future delete(dynamic data, String endpoint) async {
    try {
      await _getDio().delete(endpoint, data: data);
      return;
    } on DioError catch (e) {
      if (e.response != null) {
        throw e;
      }
      throw ServerUnreachableError(e);
    }
  }
}
