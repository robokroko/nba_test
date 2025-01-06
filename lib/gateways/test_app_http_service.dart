import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:test_application/gateways/http_service.dart';

class TestAppHttpService {
  final HttpService _http;

  TestAppHttpService(this._http);

  Future<Map<String, dynamic>> get(RequestConfig config) {
    return _http.request(RequestMethod.get, config).then((Response response) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.bodyBytes.isEmpty) {
          return <String, dynamic>{};
        }
        return jsonDecode(response.body);
      }

      throw Exception(jsonDecode(response.body));
    });
  }

  Future<Map<String, dynamic>> post(RequestConfig config) {
    return _http.request(RequestMethod.post, config).then((Response response) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.bodyBytes.isEmpty) {
          return <String, dynamic>{};
        }
        return jsonDecode(response.body);
      }
      throw jsonDecode(response.body);
    });
  }

  Future<Map<String, dynamic>> put(RequestConfig config) {
    return _http.request(RequestMethod.put, config).then((Response response) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.bodyBytes.isEmpty) {
          return <String, dynamic>{};
        }
        return jsonDecode(response.body);
      }
      throw Exception(jsonDecode(response.body));
    });
  }

  Future<Map<String, dynamic>> delete(RequestConfig config) {
    return _http.request(RequestMethod.delete, config).then((Response response) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.bodyBytes.isEmpty) {
          return <String, dynamic>{};
        }
        return jsonDecode(response.body);
      }
      throw Exception(jsonDecode(response.body));
    });
  }

  Future<List<dynamic>> getArray(RequestConfig config) {
    return _http.request(RequestMethod.get, config).then((Response response) {
      if (200 <= response.statusCode && response.statusCode < 300) {
        if (response.bodyBytes.isEmpty) {
          return <dynamic>[];
        }
        return jsonDecode(response.body);
      }
      throw Exception(jsonDecode(response.body));
    });
  }

  Future<List<dynamic>> patchArray(RequestConfig config) {
    return _http.request(RequestMethod.patch, config).then((Response response) {
      if (200 <= response.statusCode && response.statusCode < 300) {
        if (response.bodyBytes.isEmpty) {
          return <dynamic>[];
        }
        return jsonDecode(response.body);
      }
      throw Exception(jsonDecode(response.body));
    });
  }

  Future<List<dynamic>> postArray(RequestConfig config) {
    return _http.request(RequestMethod.post, config).then((Response response) {
      if (200 <= response.statusCode && response.statusCode < 300) {
        if (response.bodyBytes.isEmpty) {
          return <dynamic>[];
        }
        return jsonDecode(response.body);
      }
      throw Exception(jsonDecode(response.body));
    });
  }
}
