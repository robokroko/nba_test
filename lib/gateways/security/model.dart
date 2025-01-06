class Credential {
  final String key;
  final String username;

  Credential(this.key, this.username);

  factory Credential.fromJson(Map<String, dynamic> json) => Credential(json['key'], json['username']);

  Map<String, dynamic> toJson() => {'key': key, 'username': username};
}

class Access {
  final String accessToken;
  final DateTime createdAt;
  Access(this.accessToken, this.createdAt);

  factory Access.fromJson(Map<String, dynamic> json) => Access(json['accessToken'], DateTime.parse(json['createdAt']));

  Map<String, dynamic> toJson() => {'accessToken': accessToken, 'createdAt': createdAt.toIso8601String()};
}

