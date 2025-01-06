import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:test_application/gateways/http_service.dart';
import 'package:test_application/gateways/model.dart';

class TestAppSecurityService {
  TestAppSecurityService();

  Future<Map<String, dynamic>> get(RequestConfig config) {
    final createdAt = DateTime.now();
    return _verifyCrendentials(config).then((response) {
      if (response) {
        return _generateRandomAccessToken().then((accessToken) {
          return Map<String, dynamic>.from({
            'accessToken': accessToken,
            'createdAt': createdAt.toIso8601String(),
          });
        });
      } else {
        throw ApiError(jsonDecode('{"errorCode": "01"}'), jsonDecode('{ "error": "Invalid credentials"}'));
      }
    });
  }
}

Future<String> _generateRandomAccessToken() {
  const int tokenLength = 16;
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final Random random = Random();

  return Future.value(List.generate(tokenLength, (index) => chars[random.nextInt(chars.length)]).join());
}

Future<bool> _verifyCrendentials(RequestConfig requestConfig) {
  final authHeader = requestConfig.headers?['Authorization'];
  if (authHeader != null && authHeader.startsWith('Basic ')) {
    final encodedCredentials = authHeader.substring(6); // Remove 'Basic ' prefix
    final decodedCredentials = utf8.decode(base64Decode(encodedCredentials));
    final parts = decodedCredentials.split(':');
    if (parts.length == 2) {
      final decodedKey = parts[0];
      final decodedSecret = parts[1];
      debugPrint('Decoded Key: $decodedKey');
      debugPrint('Decoded Secret: $decodedSecret');

      if (decodedKey == 'Piller' && decodedSecret == 'PillerPassword') {
        return Future.value(true);
      } else {
        debugPrint('Invalid credentials.');
        return Future.value(false);
      }
    }
    {
      debugPrint('Invalid credentials format.');
      return Future.value(false);
    }
  }
  {
    debugPrint('Invalid credentials format.');
    return Future.value(false);
  }
}
