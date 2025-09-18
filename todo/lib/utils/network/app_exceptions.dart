class AppException {
  final String? message;
  final int? statusCode;
  AppException([this.message, this.statusCode]);

  @override
  String toString() {
    return this.message!;
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message);
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message);
}

class ResourceNotFoundException extends AppException {
  ResourceNotFoundException([message]) : super(message);
}

class UnAuthorisedException extends AppException {
  UnAuthorisedException([String? message, int? statusCode])
    : super(message, statusCode);
}
