class ApiError extends Error {
  String errorCode;
  String debugMessage;

  ApiError(this.errorCode, this.debugMessage);

  factory ApiError.fromJson(Map<String, dynamic> json)
    => ApiError(json['errorCode'], json['debugMessage']);
}