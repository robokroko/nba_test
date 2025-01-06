import 'dart:convert';

import 'package:test_application/gateways/http_service.dart';
import 'package:test_application/gateways/test_app_security_service%20.dart';
import 'package:test_application/gateways/with_security_repository.dart';
import 'package:test_application/modules/security_module/security_repository.dart';

import 'model.dart';

abstract class SecurityApi extends WithSecurityRepository {
  SecurityApi(super.securityRepository);

  Future<Access?> credentialLogin(String key, String secret);
  Future<bool> verifyAccess();
}

class HttpSecurityApi extends SecurityApi {
  final TestAppSecurityService _securityService;
  final SecurityRepository _securityRepository;

  HttpSecurityApi(this._securityRepository, this._securityService) : super(_securityRepository);

  @override
  Future<Access?> credentialLogin(String key, String secret) {
    final encodedCredential = base64Encode(utf8.encode('$key:$secret'));
    final requestConfig = RequestConfig(path: '/security/access', headers: {'Authorization': 'Basic $encodedCredential'});
    return _securityService.get(requestConfig).then((result) {
      if (result.isEmpty) {
        return Future.value(null);
      }
      final token = Access.fromJson(result);
      return token;
    });
  }

  @override
  Future<bool> verifyAccess() {
    return resolveToken().then((access) {
      if (access.createdAt.add(const Duration(days: 1)).isBefore(DateTime.now())) {
        _securityRepository.deleteAccessToken().then<bool>((_) {
          return false;
        });
      }
      return true;
    }).catchError((onError) => false);
  }
}
