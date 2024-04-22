import 'dart:typed_data';

import 'package:codec_utils/src/utils/crc32.dart';
import 'package:test/test.dart';

void main() {
  Uint8List actualData = Uint8List.fromList('Hello world'.codeUnits);

  group('Tests of CRC32.getHex()', () {
    test('Should [return CRC32 hash as HEX] of given data', () {
      // Act
      String actualCRC32Hash = CRC32.getHex(actualData);

      // Assert
      String expectedCRC32Hash = '8bd69e52';

      expect(actualCRC32Hash, expectedCRC32Hash);
    });
  });

  group('Tests of CRC32.get()', () {
    test('Should [return CRC32 hash as number] of given data', () {
      // Act
      int actualCRC32Hash = CRC32.get(actualData);

      // Assert
      int expectedCRC32Hash = 0x8bd69e52;

      expect(actualCRC32Hash, expectedCRC32Hash);
    });
  });
}
