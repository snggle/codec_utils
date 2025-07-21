import 'dart:typed_data';

import 'package:codec_utils/src/codecs/byte_reader/byte_reader.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ByteReader.shiftByte()', () {
    test('Should [return bytes]', () {
      // Arrange
      ByteReader byteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]))

      // Act
      ..rightShiftBy(3)
      ..leftShiftBy(2);
      int actualOffset = byteReader.offset;

      // Assert
      int expectedOffset = 1;

      expect(actualOffset, expectedOffset);
    });
  });
  group('Tests of ByteReader.shiftByte()', () {
    test('Should [return bytes]', () {
      // Arrange
      ByteReader byteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Act
      int actualReadBytes = byteReader.rightShift();

      // Assert
      int expectedReadBytes = 0x01;

      expect(actualReadBytes, expectedReadBytes);
    });

    test('Should [increment offset]', () {
      // Arrange
      ByteReader byteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]))

      // Act
        ..rightShift();
      int actualOffset = byteReader.offset;

      // Assert
      int expectedOffset = 1;

      expect(actualOffset, expectedOffset);
    });
  });
  group('Tests of ByteReader.shiftBytes()', () {
    test('Should [return bytes]', () {
      // Arrange
      ByteReader byteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Act
      Uint8List actualReadBytes = byteReader.rightShiftBy(2);

      // Assert
      Uint8List expectedReadBytes = Uint8List.fromList(<int>[0x01, 0x02]);

      expect(actualReadBytes, expectedReadBytes);
    });

    test('Should [increment offset]', () {
      // Arrange
      ByteReader byteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]))

        // Act
        ..rightShiftBy(4);
      int actualOffset = byteReader.offset;

      // Assert
      int expectedOffset = 4;

      expect(actualOffset, expectedOffset);
    });
  });
}
