import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of RLPUtils.encodeLength()', () {
    test('Should [return encoded length] for [length < 56]', () {
      // Arrange
      int actualLength = 55;
      int actualOffset = 128;

      // Act
      Uint8List actualEncodedLength = RLPUtils.encodeLength(actualLength, actualOffset);

      // Assert
      Uint8List expectedEncodedLength = Uint8List.fromList(<int>[183]);

      expect(actualEncodedLength, expectedEncodedLength);
    });

    test('Should [return encoded length] for [length >= 56]', () {
      // Arrange
      int actualLength = 56;
      int actualOffset = 128;

      // Act
      Uint8List actualEncodedLength = RLPUtils.encodeLength(actualLength, actualOffset);

      // Assert
      Uint8List expectedEncodedLength = Uint8List.fromList(<int>[184, 56]);

      expect(actualEncodedLength, expectedEncodedLength);
    });

    test('Should [return encoded length] for [length >= 256]', () {
      // Arrange
      int actualLength = 257;
      int actualOffset = 128;

      // Act
      Uint8List actualEncodedLength = RLPUtils.encodeLength(actualLength, actualOffset);

      // Assert
      Uint8List expectedEncodedLength = Uint8List.fromList(<int>[185, 1, 1]);

      expect(actualEncodedLength, expectedEncodedLength);
    });
  });
}
