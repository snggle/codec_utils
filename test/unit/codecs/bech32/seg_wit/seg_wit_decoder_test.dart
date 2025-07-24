import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_bech32_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_hrp_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_witness_program_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_witness_version_exception.dart';
import 'package:test/test.dart';

void main() {
  group('Test of SegWitDecoder.decode()', () {
    test('Should [return decoded data] based on given data', () {
      // Arrange
      String actualData = 'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4';

      // Act
      SegWit actualDecodedData = SegWitDecoder().decode(actualData);

      // Assert
      String expectedHrp = 'bc';
      int expectedWitnessVersion = 0;
      Uint8List expectedUint8List = Uint8List.fromList(
        <int>[117, 30, 118, 232, 25, 145, 150, 212, 84, 148, 28, 69, 209, 179, 163, 35, 241, 67, 59, 214],
      );

      SegWit expectedDecodedData = SegWit(expectedHrp, expectedWitnessVersion, expectedUint8List);

      expect(actualDecodedData, expectedDecodedData);
    });

    test('Should [throw InvalidBech32Exception] if input string is empty', () {
      // Arrange
      String actualData = '';

      // Assert
      expect(() => SegWitDecoder().decode(actualData), throwsA(isA<InvalidBech32Exception>()));
    });

    test('Should [throw InvalidHRPException] if HRP contains invalid characters', () {
      // Arrange
      String actualData = 'zz1pzry9x8gf2tvdw0s3jn5xsa9te';

      // Assert
      expect(() => SegWitDecoder().decode(actualData), throwsA(isA<InvalidHrpException>()));
    });

    test('Should [throw FormatException] if witness program is empty after decoding', () {
      // Arrange
      String actualData = 'bc1gmk9yu';

      // Assert
      expect(() => SegWitDecoder().decode(actualData), throwsA(isA<FormatException>()));
    });

    test('Should [throw InvalidWitnessVersionException] if witness version is out of allowed range (0–16)', () {
      // Arrange
      String actualData = 'bc13qypqxpq9qcrsszg2pvxq6rs0zqg3yyc5k252qw';

      // Assert
      expect(() => SegWitDecoder().decode(actualData), throwsA(isA<InvalidWitnessVersionException>()));
    });

    test('Should [throw InvalidProgramException] if witness program length is too short', () {
      // Arrange
      String actualData = 'bc1qqypf4jh4k';

      // Assert
      expect(() => SegWitDecoder().decode(actualData), throwsA(isA<InvalidWitnessProgramException>()));
    });

    test('Should [throw InvalidProgramException] if witness program length is too long', () {
      // Arrange
      String actualData = 'bc1qqypqxpq9qcrsszg2pvxq6rs0zqg3yyc5z5tpwxqergd3c8g7ruszzg3rysjjvfeg9y4zktpd9chnqvfjqaly2h';

      // Assert
      expect(() => SegWitDecoder().decode(actualData), throwsA(isA<InvalidWitnessProgramException>()));
    });
  });
}
