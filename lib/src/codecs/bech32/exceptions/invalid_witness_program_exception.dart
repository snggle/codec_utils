class InvalidWitnessProgramException implements Exception {
  final String? message;

  InvalidWitnessProgramException(this.message);

  @override
  String toString() => message ?? runtimeType.toString();
}
