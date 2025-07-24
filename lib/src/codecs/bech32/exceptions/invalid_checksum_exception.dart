class InvalidChecksumException implements Exception {
  final String? message;

  InvalidChecksumException(this.message);

  @override
  String toString() => message ?? runtimeType.toString();
}
