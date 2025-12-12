import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/src/codecs/base/base58_codec.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of Base58Codec.encode()', () {
    test('Should [return String] encoded by Base58', () {
      // Arrange
      Uint8List actualDataToEncode = base64Decode('Q1JZUFRP');

      // Act
      String actualBase58Result = Base58Codec.encode(actualDataToEncode);

      // Assert
      String expectedBase58Result = 'aXQWBu6W';

      expect(actualBase58Result, expectedBase58Result);
    });

    test('Should [return String] encoded by Base58 (with checksum)', () {
      // Arrange
      Uint8List actualDataToEncode = base64Decode('Q1JZUFRP');

      // Act
      String actualBase58Result = Base58Codec.encodeWithChecksum(actualDataToEncode);

      // Assert
      String expectedBase58Result = '4nNW8qCqV3i7VY';

      expect(actualBase58Result, expectedBase58Result);
    });
  });

  group('Tests of Base58Codec.decode()', () {
    test('Should [return String] encoded by Base58', () {
      // Arrange
      String actualBase58 = 'aXQWBu6W';

      // Act
      Uint8List actualDecodedData = Base58Codec.decode(actualBase58);

      // Assert
      Uint8List expectedDecodedData = base64Decode('Q1JZUFRP');

      expect(actualDecodedData, expectedDecodedData);
    });

    test("Should [return String] composed entirely of '1' encoded by Base58", () {
      // Arrange
      String actualBase58 = '11111111111111111111111111111111';

      // Act
      Uint8List actualDecodedData = Base58Codec.decode(actualBase58);

      // Assert
      Uint8List expectedDecodedData = base64Decode('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=');

      expect(actualDecodedData, expectedDecodedData);
    });

    test('Should [return String] encoded by Base58 (with checksum)', () {
      // Arrange
      String actualBase58 = '4nNW8qCqV3i7VY';

      // Act
      Uint8List actualDecodedData = Base58Codec.decode(actualBase58);

      // Assert
      Uint8List expectedDecodedData = base64Decode('Q1JZUFRPndAu1w==');

      expect(actualDecodedData, expectedDecodedData);
    });

    test('Should [throw FormatException] when a String encoded by Base58 has an illegal character', () {
      // Arrange
      String actualBase58 = '4nNW8qCqV3i7VYl';

      // Assert
      expect(() => Base58Codec.decode(actualBase58), throwsException);
    });
  });
}
