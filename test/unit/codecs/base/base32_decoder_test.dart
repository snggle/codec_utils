import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/src/codecs/base/base32_decoder.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of Base32Decoder.decode()', () {
    test('Should [return Uint8List] decoded from given [UPPERCASE Base32] [WITH padding]', () {
      // Arrange
      String actualBase32 = 'ONXGOZ3MMU======';

      // Act
      Uint8List actualDecodedData = Base32Decoder.decode(actualBase32);

      // Assert
      Uint8List expectedDecodedData = Uint8List.fromList(utf8.encode('snggle'));

      expect(actualDecodedData, expectedDecodedData);
    });

    test('Should [return Uint8List] decoded from given [LOWERCASE Base32] [WITHOUT padding]', () {
      // Arrange
      String actualBase32 = 'onxgoz3mmu';

      // Act
      Uint8List actualDecodedData = Base32Decoder.decode(actualBase32);

      // Assert
      Uint8List expectedDecodedData = Uint8List.fromList(utf8.encode('snggle'));

      expect(actualDecodedData, expectedDecodedData);
    });

    test('Should [return Uint8List] decoded from given [empty Base32 string]', () {
      // Arrange
      String actualBase32 = '';

      // Act
      Uint8List actualDecodedData = Base32Decoder.decode(actualBase32);

      // Assert
      Uint8List expectedDecodedData = Uint8List(0);

      expect(actualDecodedData, expectedDecodedData);
    });

    test('Should [throw FormatException] when a Base32 string has an illegal character', () {
      // Arrange
      String actualBase32 = 'MZXW6YTBO1======';

      // Assert
      expect(() => Base32Decoder.decode(actualBase32), throwsFormatException);
    });

    test('Should [throw FormatException] when a Base32 string has invalid padding', () {
      // Arrange
      String actualBase32 = 'ONXGOZ3MMU=====A';

      // Assert
      expect(() => Base32Decoder.decode(actualBase32), throwsFormatException);
    });

    test('Should [throw FormatException] if [non-ASCII character uppercases to a Base32 letter]', () {
      // Arrange
      String actualBase32 = '\u017FA======';

      // Assert
      expect(() => Base32Decoder.decode(actualBase32), throwsA(isA<FormatException>()));
    });

    test('Should [throw FormatException] if [padded data length is not a multiple of eight]', () {
      // Arrange
      String actualBase32 = 'MY=====';

      // Assert
      expect(() => Base32Decoder.decode(actualBase32), throwsA(isA<FormatException>()));
    });

    test('Should [throw FormatException] if [padding count is invalid for the data length]', () {
      // Arrange
      String actualBase32 = 'MZX=====';

      // Assert
      expect(() => Base32Decoder.decode(actualBase32), throwsA(isA<FormatException>()));
    });
  });
}
