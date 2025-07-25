import 'dart:typed_data';
import 'package:codec_utils/src/codecs/byte_reader/byte_reader.dart';
import 'package:codec_utils/src/codecs/compact_u16/compact_u16_decoder.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of CompactU16Decoder.decode()', () {
    test('Should [return 0] for input 0x00 (MIN one-byte)', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x00]));

      // Act
      int actualDecodedValue = CompactU16Decoder.decode(actualByteReader);
      int actualOffset = actualByteReader.offset;

      // Assert
      int expectedDecodedValue = 0;
      int expectedOffset = 1;

      expect(actualDecodedValue, expectedDecodedValue);
      expect(actualOffset, expectedOffset);
    });

    test('Should [return 127] for input 0x7F (MAX one-byte)', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x7F]));

      // Act
      int actualDecodedValue = CompactU16Decoder.decode(actualByteReader);
      int actualOffset = actualByteReader.offset;

      // Assert
      int expectedDecodedValue = 127;
      int expectedOffset = 1;

      expect(actualDecodedValue, expectedDecodedValue);
      expect(actualOffset, expectedOffset);
    });

    test('Should [return 128] for input 0x80 0x01 (MIN two-byte)', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x80, 0x01]));

      // Act
      int actualDecodedValue = CompactU16Decoder.decode(actualByteReader);
      int actualOffset = actualByteReader.offset;

      // Assert
      int expectedDecodedValue = 128;
      int expectedOffset = 2;

      expect(actualDecodedValue, expectedDecodedValue);
      expect(actualOffset, expectedOffset);
    });

    test('Should [return 16383] for input 0xFF 0x7F (MAX two-byte)', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0xFF, 0x7F]));

      // Act
      int actualDecodedValue = CompactU16Decoder.decode(actualByteReader);
      int actualOffset = actualByteReader.offset;

      // Assert
      int expectedDecodedValue = 16383;
      int expectedOffset = 2;

      expect(actualDecodedValue, expectedDecodedValue);
      expect(actualOffset, expectedOffset);
    });

    test('Should [return 16384] for input 0x80 0x80 0x01 (MIN three-byte)', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x80, 0x80, 0x01]));

      // Act
      int actualDecodedValue = CompactU16Decoder.decode(actualByteReader);
      int actualOffset = actualByteReader.offset;

      // Assert
      int expectedDecodedValue = 16384;
      int expectedOffset = 3;

      expect(actualDecodedValue, expectedDecodedValue);
      expect(actualOffset, expectedOffset);
    });

    test('Should [return 65535] for input 0xFF 0xFF 0x03 (MAX three-byte)', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0xFF, 0xFF, 0x03]));

      // Act
      int actualDecodedValue = CompactU16Decoder.decode(actualByteReader);
      int actualOffset = actualByteReader.offset;

      // Assert
      int expectedDecodedValue = 65535;
      int expectedOffset = 3;

      expect(actualDecodedValue, expectedDecodedValue);
      expect(actualOffset, expectedOffset);
    });

    test('Should [throw Exception] when a byte has a continuation bit set but the next byte is 0', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0xFF, 0x0]));

      // Assert
      int expectedOffset = 0;

      expect(() => CompactU16Decoder.decode(actualByteReader), throwsException);
      expect(actualByteReader.offset, expectedOffset);
    });

    test('Should [throw Exception] when attempting to read past the third byte', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0xFF, 0xFF, 0xFF, 0xFF]));

      // Assert
      int expectedOffset = 0;

      expect(() => CompactU16Decoder.decode(actualByteReader), throwsException);
      expect(actualByteReader.offset, expectedOffset);
    });
  });
}
