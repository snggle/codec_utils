import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_bech32_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_hrp_exception.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of Bech32Encoder.encode()', () {
    test('Should [return valid Bech32 address] from provided bytes', () {
      // Arrange
      Uint8List actualUint8List =
          Uint8List.fromList(<int>[3, 168, 243, 183, 64, 204, 140, 182, 162, 164, 160, 226, 46, 141, 157, 25, 31, 138, 25, 222, 176]);
      Bech32 actualBechInput = Bech32('bc', actualUint8List);

      // Act
      String actualEncoded = Bech32Encoder().encode(Bech32(actualBechInput.hrp, actualUint8List));

      // Assert
      String expectedEncoded = 'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4';

      expect(actualEncoded, expectedEncoded);
    });

    test('Should [throw InvalidLengthException] if encoded Bech32 string exceeds 90 characters', () {
      // Arrange
      Uint8List actualUint8List = Uint8List.fromList(<int>[
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, //
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      ]);
      Bech32 actualInput = Bech32('bc', actualUint8List);

      // Assert
      expect(() => Bech32Encoder().encode(actualInput), throwsA(isA<InvalidBech32Exception>()));
    });

    test('Should [throw InvalidHRPException] if HRP is empty', () {
      // Arrange
      Bech32 actualInput = Bech32('', Uint8List.fromList(<int>[0, 1, 2]));

      // Assert
      expect(
        () => Bech32Encoder().encode(actualInput),
        throwsA(isA<InvalidHrpException>()),
      );
    });
  });
}
