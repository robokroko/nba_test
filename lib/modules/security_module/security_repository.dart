import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_application/gateways/security/model.dart';
import 'package:test_application/modules/security_module/model.dart';

abstract class SecurityRepository {
  Future<bool> hasAccessToken();
  Future<void> saveAccessToken(Access access);
  Future<void> deleteAccessToken();
  Future<Access?> getAccessToken();
  Future<void> saveUser(User user);
  Future<void> deleteUser();
  Future<User?> getUser();
}

class SecureStorageSecurityRepository extends SecurityRepository {
  static const String _accessTokenKey = 'access-token';
  static const String _userKey = 'user-key';
  final FlutterSecureStorage _secureStorage;

  SecureStorageSecurityRepository(this._secureStorage);

  @override
  Future<bool> hasAccessToken() => _secureStorage.containsKey(key: _accessTokenKey);

  @override
  Future<void> saveAccessToken(Access access) => _secureStorage.write(key: _accessTokenKey, value: jsonEncode(access));

  @override
  Future<Access?> getAccessToken() => _secureStorage.read(key: _accessTokenKey).then((access) {
        if (access == null) {
          return null;
        }

        return Access.fromJson(jsonDecode(access));
      });

  @override
  Future<void> deleteAccessToken() => _secureStorage.delete(key: _accessTokenKey);

  @override
  Future<void> deleteUser() => _secureStorage.delete(key: _userKey);

  @override
  Future<User?> getUser() => _secureStorage.read(key: _userKey).then((user) {
        if (user == null) {
          return null;
        }

        return User.fromJson(jsonDecode(user));
      });

  @override
  Future<void> saveUser(User user) => _secureStorage.write(key: _userKey, value: jsonEncode(user));
}
