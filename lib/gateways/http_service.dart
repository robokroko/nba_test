import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum RequestMethod { post, put, get, delete, patch }

class RequestConfig {
  String path;
  dynamic body;
  Map<String, String>? headers;

  RequestConfig({
    required this.path,
    this.body,
    this.headers,
  });
}

abstract class HttpService {
  Future<http.Response> request(RequestMethod method, RequestConfig config);
}

class HttpClient implements HttpService {
  final String baseUrl;

  HttpClient(this.baseUrl);

  @override
  Future<http.Response> request(RequestMethod method, RequestConfig config) {
    return _call(method, config).catchError((error) {
      if (error is SocketException) {
        debugPrint('Socket exception: ${error.toString()}');
      } else if (error is TimeoutException) {
        debugPrint('Timeout exception: ${error.toString()}');
      }
      throw Exception(error);
    });
  }

  Future<http.Response> _call(RequestMethod method, RequestConfig config) {
    if (method == RequestMethod.post) {
      return _post(config);
    }
    if (method == RequestMethod.get) {
      return _get(config);
    }
    if (method == RequestMethod.put) {
      return _put(config);
    }
    if (method == RequestMethod.delete) {
      return _delete(config);
    }
    if (method == RequestMethod.patch) {
      return _patch(config);
    }

    throw Exception('method$method-not-supported');
  }

  Future<http.Response> _post(RequestConfig config) {
    final url = Uri.parse(baseUrl + config.path);
    return http.post(url, body: jsonEncode(config.body), headers: config.headers);
  }

  Future<http.Response> _put(RequestConfig config) {
    final url = Uri.parse(baseUrl + config.path);
    return http.put(url, body: jsonEncode(config.body), headers: config.headers);
  }

  Future<http.Response> _get(RequestConfig config) {
    final url = Uri.parse(baseUrl + config.path);
    return http.get(url, headers: config.headers);
  }

  Future<http.Response> _delete(RequestConfig config) {
    final url = Uri.parse(baseUrl + config.path);
    return http.delete(url, body: jsonEncode(config.body), headers: config.headers);
  }

  Future<http.Response> _patch(RequestConfig config) {
    final url = Uri.parse(baseUrl + config.path);
    return http.patch(url, body: jsonEncode(config.body), headers: config.headers);
  }
}
