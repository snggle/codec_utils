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

      // Assert
      int expectedDecodedValue = 0;

      expect(actualDecodedValue, expectedDecodedValue);
    });

    test('Should [return 127] for input 0x7F (MAX one-byte)', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x7F]));

      // Act
      int actualDecodedValue = CompactU16Decoder.decode(actualByteReader);

      // Assert
      int expectedDecodedValue = 127;

      expect(actualDecodedValue, expectedDecodedValue);
    });

    test('Should [return 128] for input 0x80 0x01 (MIN two-byte)', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x80, 0x01]));

      // Act
      int actualDecodedValue = CompactU16Decoder.decode(actualByteReader);

      // Assert
      int expectedDecodedValue = 128;

      expect(actualDecodedValue, expectedDecodedValue);
    });

    test('Should [return 16383] for input 0xFF 0x7F (MAX two-byte)', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0xFF, 0x7F]));

      // Act
      int actualDecodedValue = CompactU16Decoder.decode(actualByteReader);

      // Assert
      int expectedDecodedValue = 16383;

      expect(actualDecodedValue, expectedDecodedValue);
    });

    test('Should [return 16384] for input 0x80 0x80 0x01 (MIN three-byte)', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0x80, 0x80, 0x01]));

      // Act
      int actualDecodedValue = CompactU16Decoder.decode(actualByteReader);

      // Assert
      int expectedDecodedValue = 16384;

      expect(actualDecodedValue, expectedDecodedValue);
    });

    test('Should [return 65535] for input 0xFF 0xFF 0x03 (MAX three-byte)', () {
      // Arrange
      ByteReader actualByteReader = ByteReader(Uint8List.fromList(<int>[0xFF, 0xFF, 0x03]));

      // Act
      int actualDecodedValue = CompactU16Decoder.decode(actualByteReader);

      // Assert
      int expectedDecodedValue = 65535;

      expect(actualDecodedValue, expectedDecodedValue);
    });
  });
}
