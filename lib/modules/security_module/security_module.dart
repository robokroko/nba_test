import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_application/gateways/security/security_api.dart';
import 'package:test_application/modules/security_module/security_state.dart';
import 'package:test_application/modules/security_module/model.dart';
import 'package:test_application/modules/security_module/security_repository.dart';

class SecurityModule extends Bloc<SecurityEvent, SecurityState> {
  final SecurityApi _securityApi;
  final SecurityRepository _securityRepository;

  SecurityModule(super.initialState, this._securityApi, this._securityRepository) {
    on<SecurityEvent>((event, emit) {
      print('[event:] $event');
      emit(event.reducer(state));
    });
  }

  void onKeyChanged(String username) {
    add(OnUsernameChanged(username));
  }

  void onSecretChanged(String secret) {
    add(OnSecretChanged(secret));
  }

  Future<SecurityError?> credentialLogin() {
    final key = state.loginForm.key;
    final secret = state.loginForm.secret;

    if (key == null || key.isEmpty) {
      add(OnLoginFailed(SecurityError.usernameMissing));
      return Future.value(SecurityError.usernameMissing);
    }

    if (secret == null || secret.isEmpty) {
      add(OnLoginFailed(SecurityError.secretMissing));
      return Future.value(SecurityError.secretMissing);
    }

    add(OnLoginStarted());
    return _securityApi.credentialLogin(key, secret).then((result) {
      if (result == null) {
        return Future.value(SecurityError.incorrectCredentials);
      }

      return _securityRepository.saveAccessToken(result).then((_) {
        final User user = User(username: key);
        return _securityRepository.saveUser(user).then((_) {
          add(OnLoginSucceeded(user));
          return Future.value(null);
        });
      });
    }).catchError((error) {
      add(OnLoginFailed(SecurityError.incorrectCredentials));
      return Future.value(SecurityError.incorrectCredentials);
    });
  }

  Future<bool> autoLogin() {
    return _securityApi.verifyAccess().catchError((error) => false);
  }

  Future<bool> logout() {
    return _securityRepository.deleteAccessToken().then((_) => true).catchError((onError) => true);
  }

  void obscurePasswordChanged(bool obscurePassword) {
    add(OnObscurePasswordChanged(obscurePassword));
  }
}
