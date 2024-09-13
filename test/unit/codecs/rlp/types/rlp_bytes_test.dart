import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of RLPBytes.fromBigInt() constructor', () {
    test('Should [return RLPBytes] from given BigInt', () {
      // Arrange
      BigInt actualBigInt = BigInt.from(123456789);

      // Act
      RLPBytes actualRLPBytes = RLPBytes.fromBigInt(actualBigInt);

      // Assert
      RLPBytes expectedRLPBytes = RLPBytes(Uint8List.fromList(<int>[7, 91, 205, 21]));

      expect(actualRLPBytes, expectedRLPBytes);
    });
  });

  group('Tests of RLPBytes.fromHex() constructor', () {
    test('Should [return RLPBytes] from given BigInt', () {
      // Arrange
      String actualHex = '0x075bcd15';

      // Act
      RLPBytes actualRLPBytes = RLPBytes.fromHex(actualHex);

      // Assert
      RLPBytes expectedRLPBytes = RLPBytes(Uint8List.fromList(<int>[7, 91, 205, 21]));

      expect(actualRLPBytes, expectedRLPBytes);
    });
  });

  group('Tests of RLPBytes.encode()', () {
    test('Should [return bytes] representing RLP-encoded bytes', () {
      // Arrange
      RLPBytes rlpBytes = RLPBytes(Uint8List.fromList(<int>[7, 91, 205, 21]));

      // Act
      Uint8List actualBytes = rlpBytes.encode();

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[132, 7, 91, 205, 21]);

      expect(actualBytes, expectedBytes);
    });
  });

  group('Tests of RLPBytes.toBigInt()', () {
    test('Should [return BigInt] from given RLPBytes', () {
      // Arrange
      RLPBytes actualRLPBytes = RLPBytes(Uint8List.fromList(<int>[7, 91, 205, 21]));

      // Act
      BigInt actualBigInt = actualRLPBytes.toBigInt();

      // Assert
      BigInt expectedBigInt = BigInt.from(123456789);

      expect(actualBigInt, expectedBigInt);
    });
  });

  group('Tests of RLPBytes.toHex()', () {
    test('Should [return HEX] from given RLPBytes', () {
      // Arrange
      RLPBytes actualRLPBytes = RLPBytes(Uint8List.fromList(<int>[7, 91, 205, 21]));

      // Act
      String actualHex = actualRLPBytes.toHex();

      // Assert
      String expectedHex = '0x075bcd15';

      expect(actualHex, expectedHex);
    });
  });
}
