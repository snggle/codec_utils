import 'dart:typed_data';

import 'package:codec_utils/src/codecs/bech32/bech32.dart';
import 'package:codec_utils/src/codecs/bech32/bech32_decoder.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_bech32_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_checksum_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_hrp_exception.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of Bech32Decoder.decode()', () {
    test('Should [return decoded data] for valid Bech32 address', () {
      // Arrange
      String actualInput = 'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4';

      // Act
      Bech32 actualBech32 = Bech32Decoder().decode(actualInput);

      // Assert
      String expectedHrp = 'bc';
      Uint8List expectedDataUint8List =
          Uint8List.fromList(<int>[3, 168, 243, 183, 64, 204, 140, 182, 162, 164, 160, 226, 46, 141, 157, 25, 31, 138, 25, 222, 176]);

      Bech32 expectedBech32 = Bech32(expectedHrp, expectedDataUint8List);

      expect(actualBech32, expectedBech32);
    });

    test('Should [throw InvalidBech32Exception] if input exceeds maximum length', () {
      // Arrange
      String actualInput = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

      // Assert
      expect(() => Bech32Decoder().decode(actualInput), throwsA(isA<InvalidBech32Exception>()));
    });

    test('Should [throw InvalidBech32Exception] if input contains uppercase characters', () {
      // Arrange
      String actualInput = 'Bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kg3g4ty';

      // Assert
      expect(() => Bech32Decoder().decode(actualInput), throwsA(isA<InvalidBech32Exception>()));
    });

    test('Should [throw InvalidBech32Exception] if separator "1" is missing', () {
      // Arrange
      String actualInput = 'bcqw508d6qejxtdg4y5r3zarvary0c5xw7kg3g4ty';

      // Assert
      expect(() => Bech32Decoder().decode(actualInput), throwsA(isA<InvalidBech32Exception>()));
    });

    test('Should [throw InvalidChecksumException] if checksum is invalid due to invalid trailing characters', () {
      // Arrange
      String actualInput = 'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kygt080';

      // Assert
      expect(() => Bech32Decoder().decode(actualInput), throwsA(isA<InvalidChecksumException>()));
    });

    test('Should [throw InvalidHrpException] if HRP is empty', () {
      // Arrange
      String actualInput = '1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq';

      // Assert
      expect(() => Bech32Decoder().decode(actualInput), throwsA(isA<InvalidHrpException>()));
    });

    test('Should [throw InvalidHrpException] if HRP contains invalid characters', () {
      // Arrange
      String actualInput = '@bc 1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4';

      // Assert
      expect(() => Bech32Decoder().decode(actualInput), throwsA(isA<InvalidHrpException>()));
    });

    test('Should [throw InvalidChecksumException] if checksum contains invalid character (e.g. "!")', () {
      // Arrange
      String actualInput = 'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kg3g4t!';

      // Assert
      expect(() => Bech32Decoder().decode(actualInput), throwsA(isA<InvalidChecksumException>()));
    });

    test('Should [throw InvalidChecksumException] if checksum is incorrect (valid format, invalid sum)', () {
      // Arrange
      String actualInput = 'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kg3g4tx';

      // Assert
      expect(() => Bech32Decoder().decode(actualInput), throwsA(isA<InvalidChecksumException>()));
    });
  });
}
