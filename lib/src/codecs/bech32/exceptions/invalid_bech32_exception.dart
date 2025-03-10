class InvalidBech32Exception implements Exception {
  final String? message;

  InvalidBech32Exception(this.message);

  @override
  String toString() => message ?? runtimeType.toString();
}
