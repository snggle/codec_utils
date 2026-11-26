import 'dart:typed_data';

/// The [Base32Decoder] class is designed for decoding data using the Base32 encoding scheme.
class Base32Decoder {
  static const String _uppercaseAlphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  static const String _lowercaseAlphabet = 'abcdefghijklmnopqrstuvwxyz';
  static const Map<int, int> _paddingLengthPerRemainder = <int, int>{
    0: 0,
    2: 6,
    4: 4,
    5: 3,
    7: 1,
  };

  /// Decodes the given [data] string into a list of bytes.
  ///
  /// Base32Decoder implementation fully canonical with RFC 4648 should throw an exception when the last chunk of data is incomplete.
  /// However, we simply ignore such incomplete data chunks, following the approach of Google Authenticator in this regard:
  /// https://github.com/google/google-authenticator-android/blob/6f65e99fcbc9bbefdc3317c008345db595052a2b/java/com/google/android/apps/authenticator/util/Base32String.java#L28
  static Uint8List decode(String data) {
    if (data.isEmpty) {
      return Uint8List(0);
    }

    int paddingIndex = data.indexOf('=');
    bool paddingPresentBool = paddingIndex != -1;
    int dataWithoutPadding = paddingPresentBool ? paddingIndex : data.length;

    if (paddingPresentBool) {
      _validatePadding(data, paddingIndex);
    }

    List<int> decodedBytes = <int>[];
    int temporaryBuffer = 0;
    int validBitsInBuffer = 0;

    for (int i = 0; i < dataWithoutPadding; i++) {
      int standardAlphabetIndex = _uppercaseAlphabet.indexOf(data[i]);
      int charAlphabetIndex = standardAlphabetIndex >= 0 ? standardAlphabetIndex : _lowercaseAlphabet.indexOf(data[i]);
      bool invalidCharacterBool = charAlphabetIndex == -1;

      if (invalidCharacterBool) {
        throw const FormatException('Invalid character in Base32 string');
      }

      temporaryBuffer = (temporaryBuffer << 5) | charAlphabetIndex;
      validBitsInBuffer += 5;

      while (validBitsInBuffer >= 8) {
        validBitsInBuffer -= 8;
        decodedBytes.add((temporaryBuffer >> validBitsInBuffer) & 0xFF);
        temporaryBuffer &= (1 << validBitsInBuffer) - 1;
      }
    }

    return Uint8List.fromList(decodedBytes);
  }

  static void _validatePadding(String data, int paddingIndex) {
    bool invalidDataLengthBool = data.length % 8 != 0;
    if (invalidDataLengthBool) {
      throw const FormatException('Invalid Base32 data length');
    }

    String padding = data.substring(paddingIndex);
    if (padding.contains(RegExp('[^=]'))) {
      throw const FormatException('Invalid padding characters in Base32 string');
    }

    int remainder = paddingIndex % 8;
    int? expectedPaddingLength = _paddingLengthPerRemainder[remainder];
    if (expectedPaddingLength == null || expectedPaddingLength != padding.length) {
      throw const FormatException('Invalid padding length in Base32 string');
    }
  }
}
