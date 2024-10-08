import 'dart:typed_data';

import 'package:codec_utils/src/codecs/hex/hex_codec.dart';
import 'package:test/test.dart';

void main() {
  Uint8List asciiCodeBytes = Uint8List.fromList('123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~'.codeUnits);
  String hexLowercase =
      '3132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e';
  String hexUppercase =
      '3132333435363738393A3B3C3D3E3F404142434445464748494A4B4C4D4E4F505152535455565758595A5B5D5E5F606162636465666768696A6B6C6D6E6F707172737475767778797A7B7C7D7E';

  group('Tests of HexCodec.encode()', () {
    test('Should [return UPPERCASE hexadecimal] from given bytes (WITH 0x prefix)', () {
      Uint8List actualDataToEncode = asciiCodeBytes;

      // Act
      String actualHexResult = HexCodec.encode(actualDataToEncode, lowercaseBool: false, includePrefixBool: true);

      // Assert
      String expectedHexResult = '0x$hexUppercase';

      expect(actualHexResult, expectedHexResult);
    });

    test('Should [return UPPERCASE hexadecimal] from given bytes (WITHOUT 0x prefix)', () {
      Uint8List actualDataToEncode = asciiCodeBytes;

      // Act
      String actualHexResult = HexCodec.encode(actualDataToEncode, lowercaseBool: false, includePrefixBool: false);

      // Assert
      String expectedHexResult = hexUppercase;

      expect(actualHexResult, expectedHexResult);
    });

    test('Should [return LOWERCASE hexadecimal] from given bytes (WITH 0x prefix', () {
      Uint8List actualDataToEncode = asciiCodeBytes;

      // Act
      String actualHexResult = HexCodec.encode(actualDataToEncode, lowercaseBool: true, includePrefixBool: true);

      // Assert
      String expectedHexResult = '0x$hexLowercase';

      expect(actualHexResult, expectedHexResult);
    });

    test('Should [return LOWERCASE hexadecimal] from given bytes (WITHOUT 0x prefix)', () {
      Uint8List actualDataToEncode = asciiCodeBytes;

      // Act
      String actualHexResult = HexCodec.encode(actualDataToEncode, lowercaseBool: true, includePrefixBool: false);

      // Assert
      String expectedHexResult = hexLowercase;

      expect(actualHexResult, expectedHexResult);
    });
  });

  group('Tests of HexCodec.decode()', () {
    test('Should [return Uint8List] decoded from given [UPPERCASE hexadecimal] [WITH 0x prefix]', () {
      // Arrange
      String actualHexToDecode = hexUppercase;

      // Act
      Uint8List actualDecodedHexResult = HexCodec.decode('0x$actualHexToDecode');

      // Assert
      Uint8List expectedDecodedHexResult = asciiCodeBytes;

      expect(actualDecodedHexResult, expectedDecodedHexResult);
    });

    test('Should [return Uint8List] decoded from given [UPPERCASE hexadecimal] [WITHOUT 0x prefix]', () {
      // Arrange
      String actualHexToDecode = hexUppercase;

      // Act
      Uint8List actualDecodedHexResult = HexCodec.decode(actualHexToDecode);

      // Assert
      Uint8List expectedDecodedHexResult = asciiCodeBytes;

      expect(actualDecodedHexResult, expectedDecodedHexResult);
    });

    test('Should [return Uint8List] decoded from given [LOWERCASE hexadecimal] [WITH 0x prefix]', () {
      // Arrange
      String actualHexToDecode = hexLowercase;

      // Act
      Uint8List actualDecodedHexResult = HexCodec.decode('0x$actualHexToDecode');

      // Assert
      Uint8List expectedDecodedHexResult = asciiCodeBytes;

      expect(actualDecodedHexResult, expectedDecodedHexResult);
    });

    test('Should [return Uint8List] decoded from given [LOWERCASE hexadecimal] [WITHOUT 0x prefix]', () {
      // Arrange
      String actualHexToDecode = hexLowercase;

      // Act
      Uint8List actualDecodedHexResult = HexCodec.decode(actualHexToDecode);

      // Assert
      Uint8List expectedDecodedHexResult = asciiCodeBytes;

      expect(actualDecodedHexResult, expectedDecodedHexResult);
    });
  });

  group('Tests of HexCodec.isHex()', () {
    test('Should [return TRUE] if given value is [UPPERCASE hexadecimal] [WITH 0x prefix]', () {
      // Arrange
      String actualHexToCheck = '0x$hexUppercase';

      // Act
      bool actualHexBool = HexCodec.isHex(actualHexToCheck);

      // Assert
      bool expectedHexBool = true;

      expect(actualHexBool, expectedHexBool);
    });

    test('Should [return TRUE] if given value is [UPPERCASE hexadecimal] [WITHOUT 0x prefix]', () {
      // Arrange
      String actualHexToCheck = hexUppercase;

      // Act
      bool actualHexBool = HexCodec.isHex(actualHexToCheck);

      // Assert
      bool expectedHexBool = true;

      expect(actualHexBool, expectedHexBool);
    });

    test('Should [return TRUE] if given value is [LOWERCASE hexadecimal] [WITH 0x prefix]', () {
      // Arrange
      String actualHexToCheck = '0x$hexLowercase';

      // Act
      bool actualHexBool = HexCodec.isHex(actualHexToCheck);

      // Assert
      bool expectedHexBool = true;

      expect(actualHexBool, expectedHexBool);
    });

    test('Should [return TRUE] if given value is [LOWERCASE hexadecimal] [WITHOUT 0x prefix]', () {
      // Arrange
      String actualHexToCheck = hexLowercase;

      // Act
      bool actualHexBool = HexCodec.isHex(actualHexToCheck);

      // Assert
      bool expectedHexBool = true;

      expect(actualHexBool, expectedHexBool);
    });

    test('Should [return FALSE] if given value is [NOT hexadecimal]', () {
      // Arrange
      String actualHexToCheck = 'random string';

      // Act
      bool actualHexBool = HexCodec.isHex(actualHexToCheck);

      // Assert
      bool expectedHexBool = false;

      expect(actualHexBool, expectedHexBool);
    });
  });
}
