import 'dart:typed_data';
import 'package:codec_utils/src/codecs/compact_u16/export.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of CompactU16 factory constructor', () {
    test('Should [return CompactU16.zero] for input 0', () {
      // Arrange
      int actualValue = 0;

      // Act
      CompactU16 actualCompactU16DecodedValue = CompactU16(actualValue);

      // Assert
      expect(actualCompactU16DecodedValue.value, actualValue);
    });

    test('Should [create CompactU16] for input 300', () {
      // Act
      CompactU16 actualCompactU16 = CompactU16(300);
      Uint8List actualCompactU16Bytes = actualCompactU16.toBytes();

      // Assert
      Uint8List expectedCompactU16Bytes = Uint8List.fromList(<int>[0xAC, 0x02]);

      expect(actualCompactU16Bytes, expectedCompactU16Bytes);
    });
  });

  group('Tests of CompactU16.fromBytes constructor', () {
    test('Should [create CompactU16.zero]', () {
      // Arrange
      CompactU16 actualCompactU16 = CompactU16.zero;
      int actualCompactU16Value = actualCompactU16.value;

      // Assert
      int expectedCompactU16Value = 0;

      expect(actualCompactU16Value, expectedCompactU16Value);
    });

    test('Should [create CompactU16]', () {
      // Act
      int actualCompactU16Value = const CompactU16.fromBytes(<int>[0xAC, 0x02]).value;

      // Assert
      int expectedCompactU16Value = 300;

      expect(actualCompactU16Value, expectedCompactU16Value);
    });
  });

  group('Tests of CompactU16.value getter', () {
    test('Should [return value] for bytes [0]', () {
      // Act
      int actualCompactU16Value = CompactU16.zero.value;

      // Assert
      int expectedCompactU16Value = 0;

      expect(actualCompactU16Value, expectedCompactU16Value);
    });

    test('Should [return value] for bytes [0xAC, 0x02]', () {
      // Act
      int actualCompactU16Value = const CompactU16.fromBytes(<int>[0xAC, 0x02]).value;

      // Assert
      int expectedCompactU16Value = 300;

      expect(actualCompactU16Value, expectedCompactU16Value);
    });
  });

  group('Tests of CompactU16.size getter', () {
    test('Should [return size] for bytes [0]', () {
      // Arrange
      int actualCompactU16Size = CompactU16.zero.size;

      // Assert
      int expectedCompactU16Size = 1;

      expect(actualCompactU16Size, expectedCompactU16Size);
    });

    test('Should [return size] for bytes [0xAC, 0x02]', () {
      // Act
      int actualCompactU16Size = const CompactU16.fromBytes(<int>[0xAC, 0x02]).size;

      // Assert
      int expectedCompactU16Size = 2;

      expect(actualCompactU16Size, expectedCompactU16Size);
    });
  });

  group('Tests of CompactU16.toBytes method', () {
    test('Should [return bytes] for value 0', () {
      // Act
      Uint8List actualCompactU16Bytes = CompactU16(0).toBytes();

      // Assert
      Uint8List expectedCompactU16Bytes = Uint8List.fromList(<int>[0]);

      expect(actualCompactU16Bytes, expectedCompactU16Bytes);
    });

    test('Should [return bytes] for value 300', () {
      // Act
      Uint8List actualCompactU16Bytes = CompactU16(300).toBytes();

      // Assert
      Uint8List expectedCompactU16Bytes = Uint8List.fromList(<int>[0xAC, 0x02]);

      expect(actualCompactU16Bytes, expectedCompactU16Bytes);
    });
  });

  group('Tests of CompactU16.decodeLength method', () {
    test('Should [return length] for offset 0', () {
      // Arrange
      Uint8List actualData = Uint8List.fromList(<int>[0xAC, 0x02]);

      // Act
      int actualDecodedLength = CompactU16.decodeLength(actualData, 0);

      // Assert
      int expectedDecodedLength = 2;

      expect(actualDecodedLength, expectedDecodedLength);
    });

    test('Should [return length] for offset 1', () {
      // Arrange
      Uint8List actualData = Uint8List.fromList(<int>[0x81, 0x80, 0x01]);

      // Act
      int actualDecodedLength = CompactU16.decodeLength(actualData, 1);

      // Assert
      int expectedDecodedLength = 2;

      expect(actualDecodedLength, expectedDecodedLength);
    });
  });

  group('Tests of CompactU16.decodeValue method', () {
    test('Should [return value] for offset 0 and length 2', () {
      // Arrange
      Uint8List actualData = Uint8List.fromList(<int>[0xAC, 0x02]);

      // Act
      int actualDecodedValue = CompactU16.decodeValue(actualData, 0, 2);

      // Assert
      int expectedDecodedValue = 300;

      expect(actualDecodedValue, expectedDecodedValue);
    });

    test('Should [return value] for offset 1 and length 2', () {
      // Arrange
      Uint8List actualData = Uint8List.fromList(<int>[0x81, 0x80, 0x01]);

      // Act
      int actualDecodedValue = CompactU16.decodeValue(actualData, 1, 2);

      // Assert
      int expectedDecodedValue = 128;

      expect(actualDecodedValue, expectedDecodedValue);
    });
  });
}
