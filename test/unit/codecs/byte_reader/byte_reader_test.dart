// ignore_for_file: cascade_invocations

import 'dart:typed_data';

import 'package:codec_utils/src/codecs/byte_reader/byte_reader.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ByteReader.shiftLeftBy()', () {
    test('Should [decrement offset by (2)]', () {
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

    test('Should [throw Exception] if shifted left past end of data', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Act
      actualByteReader.shiftRightBy(3);

      // Assert
      expect(() => actualByteReader.shiftLeftBy(4), throwsException);
    });
  });

  group('Tests of ByteReader.shiftRight()', () {
    test('Should [return element at current offset] and [increment offset]', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Act
      int actualReadByte = actualByteReader.shiftRight();
      int actualOffset = actualByteReader.offset;

      // Assert
      int expectedReadByte = 0x01;
      int expectedOffset = 1;

      expect(actualReadByte, expectedReadByte);
      expect(actualOffset, expectedOffset);
    });

    test('Should [throw Exception] if shifted right past end of data', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01]));

      // Act
      actualByteReader.shiftRight();

      // Assert
      expect(() => actualByteReader.shiftRight(), throwsException);
    });
  });

  group('Tests of ByteReader.shiftRightBy()', () {
    test('Should [return (2) elements starting at current offset] and [increment offset by (2)]', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Act
      Uint8List actualShiftedBytes = actualByteReader.shiftRightBy(2);
      int actualOffset = actualByteReader.offset;

      // Assert
      Uint8List expectedShiftedBytes = Uint8List.fromList(<int>[0x01, 0x02]);
      int expectedOffset = 2;

      expect(actualShiftedBytes, expectedShiftedBytes);
      expect(actualOffset, expectedOffset);
    });

    test('Should [throw Exception] if shifted right past end of data', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Assert
      expect(() => actualByteReader.shiftRightBy(5), throwsException);
    });
  });
}
