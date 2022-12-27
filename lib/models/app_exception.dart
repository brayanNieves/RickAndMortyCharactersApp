class AppException implements Exception {
  final String code;
  final String? message;
  final String? reason;

  AppException({required this.code, this.message, this.reason});
}
