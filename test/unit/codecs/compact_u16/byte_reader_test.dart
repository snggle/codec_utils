import 'dart:typed_data';

import 'package:codec_utils/src/codecs/compact_u16/byte_reader.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ByteReader.readBytes()', () {
    test('Should [return read bytes]', () {
      // Arrange
      ByteReader byteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]));

      // Act
      Uint8List actualReadBytes = byteReader.readBytes(2);

      // Assert
      Uint8List expectedReadBytes = Uint8List.fromList(<int>[0x01, 0x02]);

      expect(actualReadBytes, expectedReadBytes);
    });

    test('Should [increment offset]', () {
      // Arrange
      ByteReader byteReader = ByteReader(Uint8List.fromList(<int>[0x01, 0x02, 0x03, 0x04]))

        // Act
        ..readBytes(4);
      int actualOffset = byteReader.offset;

      // Assert
      int expectedOffset = 4;

      expect(actualOffset, expectedOffset);
    });
  });

  group('Tests of ByteReader.decodeCompactU16Value()', () {
    test('Should [decode CompactU16 value]', () {
      // Arrange
      ByteReader byteReader = ByteReader(Uint8List.fromList(<int>[0xAC, 0x02]));

      // Act
      int actualDecodedValue = byteReader.decodeCompactU16Value();

      // Assert
      int expectedDecodedValue = 300;

      expect(actualDecodedValue, expectedDecodedValue);
    });

    test('Should [update offset]', () {
      // Arrange
      ByteReader byteReader = ByteReader(Uint8List.fromList(<int>[0xAC, 0x02]))

        // Act
        ..decodeCompactU16Value();
      int actualOffset = byteReader.offset;

      // Assert
      int expectedOffset = 2;

      expect(actualOffset, expectedOffset);
    });
  });

  group('Tests of ByteReader.decodeCompactU16Length()', () {
    test('Should [return length]', () {
      // Arrange
      ByteReader byteReader = ByteReader(Uint8List.fromList(<int>[0xAC, 0x02]));

      // Act
      int actualDecodedLength = byteReader.decodeCompactU16Length();

      // Assert
      int expectedDecodedLength = 2;

      expect(actualDecodedLength, expectedDecodedLength);
    });

    test('Should [leave offset untouched]', () {
      // Arrange
      ByteReader byteReader = ByteReader(Uint8List.fromList(<int>[0xAC, 0x02]))

        // Act
        ..decodeCompactU16Length();
      int actualOffset = byteReader.offset;

      // Assert
      int expectedOffset = 0;

      expect(actualOffset, expectedOffset);
    });
  });
}
