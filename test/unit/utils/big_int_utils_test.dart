import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/src/utils/big_int_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of BigIntUtils.changeToBytes()', () {
    test('Should [return Endian.big bytes] constructed from given BigInt', () {
      // Arrange
      BigInt actualBigInt = BigInt.parse('1234567890');

      // Act
      Uint8List actualBytes = BigIntUtils.changeToBytes(actualBigInt);

      // Assert
      Uint8List expectedBytes = base64Decode('SZYC0g==');

      expect(actualBytes, expectedBytes);
    });

    test('Should [return padded Endian.big bytes] constructed from given BigInt and length', () {
      // Arrange
      BigInt actualBigInt = BigInt.parse('1234567890');

      // Act
      Uint8List actualBytes = BigIntUtils.changeToBytes(actualBigInt, length: 20);

      // Assert
      Uint8List expectedBytes = base64Decode('AAAAAAAAAAAAAAAAAAAAAEmWAtI=');

      expect(actualBytes, expectedBytes);
    });

    test('Should [return Endian.little bytes] constructed from given BigInt', () {
      // Arrange
      BigInt actualBigInt = BigInt.parse('1234567890');

      // Act
      Uint8List actualBytes = BigIntUtils.changeToBytes(actualBigInt, order: Endian.little);

      // Assert
      Uint8List expectedBytes = base64Decode('0gKWSQ==');

      expect(actualBytes, expectedBytes);
    });

    test('Should [return padded Endian.little bytes] constructed from given BigInt and length', () {
      // Arrange
      BigInt actualBigInt = BigInt.parse('1234567890');

      // Act
      Uint8List actualBytes = BigIntUtils.changeToBytes(actualBigInt, length: 20, order: Endian.little);

      // Assert
      Uint8List expectedBytes = base64Decode('0gKWSQAAAAAAAAAAAAAAAAAAAAA=');

      expect(actualBytes, expectedBytes);
    });
  });

  group('Tests of BigIntUtils.decode()', () {
    test('Should [return BigInt] constructed from given [Endian.big bytes]', () {
      // Arrange
      List<int> actualBytes = base64Decode('SZYC0g==');

      // Act
      BigInt actualBigInt = BigIntUtils.decode(actualBytes);

      // Assert
      BigInt expectedBigInt = BigInt.parse('1234567890');

      expect(actualBigInt, expectedBigInt);
    });

    test('Should [return BigInt] constructed from given [Endian.little bytes]', () {
      // Arrange
      List<int> actualBytes = base64Decode('SZYC0g==');

      // Act
      BigInt actualBigInt = BigIntUtils.decode(actualBytes, order: Endian.little);

      // Assert
      BigInt expectedBigInt = BigInt.parse('3523384905');

      expect(actualBigInt, expectedBigInt);
    });
  });
}
