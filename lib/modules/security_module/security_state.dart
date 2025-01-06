import 'package:test_application/store_and_utilities/model.dart';
import 'package:test_application/modules/security_module/model.dart';

class SecurityState {
  final LoginForm loginForm;
  final AsyncResult<String, SecurityError> loginResult;
  final User? user;
  final bool obscurePassword;

  SecurityState(this.loginForm, this.loginResult, this.user, {this.obscurePassword = true});

  factory SecurityState.initial() =>
      SecurityState(LoginForm.initial(), AsyncResult<String, SecurityError>.initial(null), null, obscurePassword: true);

  SecurityState copyWith({
    LoginForm? loginForm,
    AsyncResult<String, SecurityError>? loginResult,
    User? user,
    bool? obscurePassword,
  }) =>
      SecurityState(
        loginForm ?? this.loginForm,
        loginResult ?? this.loginResult,
        user ?? this.user,
        obscurePassword: obscurePassword ?? this.obscurePassword,
      );

  SecurityState copyWithLoginForm({String? key, String? secret}) =>
      copyWith(loginForm: loginForm.copyWith(key: key ?? loginForm.key, secret: secret ?? loginForm.secret));

  SecurityState copyWithLoginResult({AsyncProgress? progress, Set<SecurityError>? errors, String? result}) => copyWith(
      loginResult: loginResult.copyWith(
          progress: progress ?? loginResult.progress, errors: errors ?? loginResult.errors, result: result ?? loginResult.result));

  SecurityError? keyError() {
    return loginResult.errors.intersection(<SecurityError>{SecurityError.usernameMissing}).firstOrNull;
  }

  SecurityError? secretError() {
    return loginResult.errors.intersection(<SecurityError>{SecurityError.secretMissing}).firstOrNull;
  }
}

abstract class SecurityEvent {
  SecurityState reducer(SecurityState state);
}

class OnLoginStarted extends SecurityEvent {
  @override
  SecurityState reducer(SecurityState state) {
    return state.copyWithLoginResult(progress: AsyncProgress.busy, errors: <SecurityError>{});
  }
}

class OnLoginFailed extends SecurityEvent {
  final SecurityError error;
  OnLoginFailed(this.error);
  @override
  SecurityState reducer(SecurityState state) {
    final errors = Set<SecurityError>.from(state.loginResult.errors);
    errors.add(error);
    return state.copyWithLoginResult(progress: AsyncProgress.idle, errors: errors);
  }
}

class OnLoginSucceeded extends SecurityEvent {
  final User user;
  OnLoginSucceeded(this.user);
  @override
  SecurityState reducer(SecurityState state) {
    return state.copyWith(
        user: user, loginForm: LoginForm.initial(), loginResult: state.loginResult.copyWith(progress: AsyncProgress.idle, errors: <SecurityError>{}));
  }
}

class OnUsernameChanged extends SecurityEvent {
  final String key;
  OnUsernameChanged(this.key);

  @override
  SecurityState reducer(SecurityState state) {
    final errors = Set<SecurityError>.from(state.loginResult.errors);
    errors.remove(SecurityError.usernameMissing);
    return state.copyWith(loginForm: state.loginForm.copyWith(key: key), loginResult: state.loginResult.copyWith(errors: errors));
  }
}

class OnSecretChanged extends SecurityEvent {
  final String secret;
  OnSecretChanged(this.secret);

  @override
  SecurityState reducer(SecurityState state) {
    final errors = Set<SecurityError>.from(state.loginResult.errors);
    errors.remove(SecurityError.secretMissing);
    return state.copyWith(loginForm: state.loginForm.copyWith(secret: secret), loginResult: state.loginResult.copyWith(errors: errors));
  }
}

class OnObscurePasswordChanged extends SecurityEvent {
  final bool obscurePassword;
  OnObscurePasswordChanged(this.obscurePassword);

  @override
  SecurityState reducer(SecurityState state) {
    return state.copyWith(obscurePassword: obscurePassword);
  }
}
