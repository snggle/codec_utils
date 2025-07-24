class InvalidHrpException implements Exception {
  final String? message;

  InvalidHrpException(this.message);

  @override
  String toString() => message ?? runtimeType.toString();
}
