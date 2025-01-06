enum SecurityError {
  usernameMissing('login.username.missing'),
  secretMissing('login.secret.missing'),
  incorrectCredentials('login.incorrect_credentials');

  const SecurityError(this.errorKey);
  final String errorKey;
}

enum CredentialLoginResult { failed, succeded }

class LoginForm {
  final String? key;
  final String? secret;

  LoginForm({this.key, this.secret});

  LoginForm copyWith({String? key, String? secret, String? mfaCode}) => LoginForm(key: key ?? this.key, secret: secret ?? this.secret);

  factory LoginForm.initial() => LoginForm(key: null, secret: null);
}

class User {
  final String username;
  User({required this.username});

  factory User.fromJson(Map<String, dynamic> json) => User(username: json['username']);

  Map<String, dynamic> toJson() => {'username': username};
}
