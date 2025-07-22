// ignore_for_file: cascade_invocations

import 'dart:typed_data';

import 'package:codec_utils/src/codecs/byte_reader/byte_reader.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ByteReader.shiftRight()', () {
    test('Should [return the element at the current offset]', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Act
      int actualReadByte = actualByteReader.shiftRight();

      // Assert
      int expectedReadByte = 0x01;

      expect(actualReadByte, expectedReadByte);
    });

    test('Should [increment offset by 1 byte]', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Act
      actualByteReader.shiftRight();
      int actualOffset = actualByteReader.offset;

      // Assert
      int expectedOffset = 1;

      expect(actualOffset, expectedOffset);
    });

    test('Should [throw RangeError] if shifted right past end of data', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01]));

      // Act
      actualByteReader.shiftRight();

      // Assert
      expect(() => actualByteReader.shiftRight(), throwsRangeError);
    });
  });
  group('Tests of ByteReader.shiftRightBy()', () {
    test('Should [return elements at the current offset]', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Act
      Uint8List actualReadBytes = actualByteReader.shiftRightBy(2);

      // Assert
      Uint8List expectedReadBytes = Uint8List.fromList(<int>[0x01, 0x02]);

      expect(actualReadBytes, expectedReadBytes);
    });

    test('Should [increment offset by the number of shifted bytes]', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Act
      actualByteReader.shiftRightBy(4);
      int actualOffset = actualByteReader.offset;

      // Assert
      int expectedOffset = 4;

      expect(actualOffset, expectedOffset);
    });

    test('Should [throw RangeError] if shifted right past end of data', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Assert
      expect(() => actualByteReader.shiftRightBy(5), throwsRangeError);
    });
  });
  group('Tests of ByteReader.shiftLeftBy()', () {
    test('Should [decrement offset by the number of shifted bytes]', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Act
      actualByteReader.shiftRightBy(3);
      actualByteReader.shiftLeftBy(2);
      int actualOffset = actualByteReader.offset;

      // Assert
      int expectedOffset = 1;

      expect(actualOffset, expectedOffset);
    });

    test('Should [throw RangeError] if shifted left past end of data', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Act
      actualByteReader.shiftRightBy(3);

      // Assert
      expect(() => actualByteReader.shiftLeftBy(4), throwsRangeError);
    });
  });
}
