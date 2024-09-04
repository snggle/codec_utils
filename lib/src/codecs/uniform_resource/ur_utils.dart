class URUtils {
  /// Allowed characters for the [type] field in a Uniform Resource.
  static const String _typeAllowedChars = 'abcdefghijklmnopqrstuvwxyz0123456789-';

  /// Checks whether the given [type] is a valid Uniform Resource type.
  static bool isValidURType(String type) {
    return type.split('').every((String char) => _typeAllowedChars.contains(char));
  }
}
