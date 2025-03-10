import 'dart:typed_data';

import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_witness_program_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_witness_version_exception.dart';
import 'package:codec_utils/src/codecs/bech32/seg_wit/seg_wit.dart';
import 'package:codec_utils/src/codecs/bech32/seg_wit/seg_wit_encoder.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tests of SegWitEncoder.encode()', () {
    test('Should [return converted data] based on given data', () {
      // Arrange
      Uint8List actualUint8List = Uint8List.fromList(<int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]);
      SegWit actualSegWit = SegWit('bc', 0, actualUint8List);

      // Act
      String actualEncodedData = SegWitEncoder().encode(actualSegWit);

      // Assert
      String expectedEncodedData = 'bc1qqqqsyqcyq5rqwzqfpg9scrgwpugpzysn4v0345';

      expect(actualEncodedData, expectedEncodedData);
    });

    test('Should [throw InvalidWitnessVersionException] if witness version is greater than 16', () {
      // Arrange
      Uint8List actualUint8List = Uint8List.fromList(<int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]);
      SegWit actualSegWit = SegWit('bc', 17, actualUint8List);

      // Assert
      expect(() => SegWitEncoder().encode(actualSegWit), throwsA(isA<InvalidWitnessVersionException>()));
    });

    test('Should [throw InvalidProgramException] if witness program length is less than 2', () {
      // Arrange
      Uint8List actualUint8List = Uint8List.fromList(<int>[0]);
      SegWit actualSegWit = SegWit('bc', 0, actualUint8List);

      // Assert
      expect(() => SegWitEncoder().encode(actualSegWit), throwsA(isA<InvalidWitnessProgramException>()));
    });

    test('Should [throw InvalidProgramException] if witness program length exceeds 40 bytes', () {
      // Arrange
      Uint8List actualUint8List = Uint8List.fromList(<int>[
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, //
        13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
        30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40
      ]);

      SegWit actualSegWit = SegWit('bc', 0, actualUint8List);

      // Assert
      expect(() => SegWitEncoder().encode(actualSegWit), throwsA(isA<InvalidWitnessProgramException>()));
    });

    test('Should [throw InvalidProgramException] if witness program length is 31 bytes (invalid for version 0)', () {
      // Arrange
      Uint8List actualUint8List = Uint8List.fromList(<int>[
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, //
        13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
      ]);

      SegWit actualSegWit = SegWit('bc', 0, actualUint8List);

      // Assert
      expect(() => SegWitEncoder().encode(actualSegWit), throwsA(isA<InvalidWitnessProgramException>()));
    });
  });
}
