import 'package:test_application/modules/security_module/security_repository.dart';
import 'security/model.dart';

class WithSecurityRepository {
  final SecurityRepository _securityRepository;

  WithSecurityRepository(this._securityRepository);

  Future<Access> resolveToken() {
    return _securityRepository.getAccessToken().then((access) {
      if (access == null) {
        throw Exception('missing-access-token');
      }

      return access;
    });
  }
}
