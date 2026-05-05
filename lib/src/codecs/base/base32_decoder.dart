import 'dart:typed_data';

/// The [Base32Decoder] class is designed for decoding data using the Base32 encoding scheme.
class Base32Decoder {
  static const String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
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

    String normalizedData = data.toUpperCase();
    int paddingIndex = normalizedData.indexOf('=');
    bool paddingPresentBool = paddingIndex != -1;
    String dataWithoutPadding = paddingPresentBool ? normalizedData.substring(0, paddingIndex) : normalizedData;

    if (paddingPresentBool) {
      _validatePadding(normalizedData, paddingIndex, dataWithoutPadding.length);
    }

    List<int> decodedBytes = <int>[];
    int temporaryBuffer = 0;
    int validBitsInBuffer = 0;

    for (int i = 0; i < dataWithoutPadding.length; i++) {
      int charAlphabetIndex = _alphabet.indexOf(dataWithoutPadding[i]);
      if (charAlphabetIndex == -1) {
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

  static void _validatePadding(String normalizedData, int paddingIndex, int dataWithoutPadding) {
    if (normalizedData.length % 8 != 0) {
      throw const FormatException('Invalid Base32 data length');
    }

    String padding = normalizedData.substring(paddingIndex);
    if (padding.contains(RegExp('[^=]'))) {
      throw const FormatException('Invalid padding characters in Base32 string');
    }

    int remainder = dataWithoutPadding % 8;
    int? expectedPaddingLength = _paddingLengthPerRemainder[remainder];
    if (expectedPaddingLength == null || expectedPaddingLength != padding.length) {
      throw const FormatException('Invalid padding length in Base32 string');
    }
  }
}
