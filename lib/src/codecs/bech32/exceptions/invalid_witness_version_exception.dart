class InvalidWitnessVersionException implements Exception {
  final String? message;

  InvalidWitnessVersionException(this.message);

  @override
  String toString() => message ?? runtimeType.toString();
}
