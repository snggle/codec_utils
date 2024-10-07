import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/protobuf/protobuf_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufUtils.encodeLength()', () {
    test('Should [return encoded length] for given length and field number (length < 128)', () {
      // Act
      List<int> actualEncodedLength = ProtobufUtils.encodeLength(1, 127);

      // Assert
      List<int> expectedEncodedLength = <int>[10, 127];

      expect(actualEncodedLength, expectedEncodedLength);
    });

    test('Should [return encoded length] for given length and field number (length > 128)', () {
      // Act
      List<int> actualEncodedLength = ProtobufUtils.encodeLength(1, 128);

      // Assert
      List<int> expectedEncodedLength = <int>[10, 128, 1];

      expect(actualEncodedLength, expectedEncodedLength);
    });
  });

  group('Tests of ProtobufUtils.createTag()', () {
    test('Should [return tag] for given field number and wire type (ProtobufWireType.varint)', () {
      // Act
      int actualTag = ProtobufUtils.createTag(1, ProtobufWireType.varint);

      // Assert
      int expectedTag = 8;

      expect(actualTag, expectedTag);
    });

    test('Should [return tag] for given field number and wire type (ProtobufWireType.i64)', () {
      // Act
      int actualTag = ProtobufUtils.createTag(1, ProtobufWireType.i64);

      // Assert
      int expectedTag = 9;

      expect(actualTag, expectedTag);
    });

    test('Should [return tag] for given field number and wire type (ProtobufWireType.len)', () {
      // Act
      int actualTag = ProtobufUtils.createTag(1, ProtobufWireType.len);

      // Assert
      int expectedTag = 10;

      expect(actualTag, expectedTag);
    });

    test('Should [return tag] for given field number and wire type (ProtobufWireType.sgroup)', () {
      // Act
      int actualTag = ProtobufUtils.createTag(1, ProtobufWireType.sgroup);

      // Assert
      int expectedTag = 11;

      expect(actualTag, expectedTag);
    });

    test('Should [return tag] for given field number and wire type (ProtobufWireType.egroup)', () {
      // Act
      int actualTag = ProtobufUtils.createTag(1, ProtobufWireType.egroup);

      // Assert
      int expectedTag = 12;

      expect(actualTag, expectedTag);
    });

    test('Should [return tag] for given field number and wire type (ProtobufWireType.i32)', () {
      // Act
      int actualTag = ProtobufUtils.createTag(1, ProtobufWireType.i32);

      // Assert
      int expectedTag = 13;

      expect(actualTag, expectedTag);
    });
  });

  group('Tests of ProtobufUtils.encodeVarint32()', () {
    test('Should [return encoded varint32] for given integer value (value 0-127)', () {
      // Act
      List<int> actualEncodedVarint32 = ProtobufUtils.encodeVarint32(127);

      // Assert
      List<int> expectedEncodedVarint32 = <int>[127];

      expect(actualEncodedVarint32, expectedEncodedVarint32);
    });

    test('Should [return encoded varint32] for given integer value (value 128-16383)', () {
      // Act
      List<int> actualEncodedVarint32 = ProtobufUtils.encodeVarint32(128);

      // Assert
      List<int> expectedEncodedVarint32 = <int>[128, 1];

      expect(actualEncodedVarint32, expectedEncodedVarint32);
    });

    test('Should [return encoded varint32] for given integer value (value 16384-2097151)', () {
      // Act
      List<int> actualEncodedVarint32 = ProtobufUtils.encodeVarint32(16384);

      // Assert
      List<int> expectedEncodedVarint32 = <int>[128, 128, 1];

      expect(actualEncodedVarint32, expectedEncodedVarint32);
    });

    test('Should [return encoded varint32] for given integer value (value 2097152-268435455 )', () {
      // Act
      List<int> actualEncodedVarint32 = ProtobufUtils.encodeVarint32(2097152);

      // Assert
      List<int> expectedEncodedVarint32 = <int>[128, 128, 128, 1];

      expect(actualEncodedVarint32, expectedEncodedVarint32);
    });

    test('Should [return encoded varint32] for given integer value (value 268435456-4294967295 )', () {
      // Act
      List<int> actualEncodedVarint32 = ProtobufUtils.encodeVarint32(268435456);

      // Assert
      List<int> expectedEncodedVarint32 = <int>[128, 128, 128, 128, 1];

      expect(actualEncodedVarint32, expectedEncodedVarint32);
    });

    test('Should [return encoded varint32] for given integer value (max value)', () {
      // Act
      List<int> actualEncodedVarint32 = ProtobufUtils.encodeVarint32(4294967295);

      // Assert
      List<int> expectedEncodedVarint32 = <int>[255, 255, 255, 255, 15];

      expect(actualEncodedVarint32, expectedEncodedVarint32);
    });
  });

  group('Tests of ProtobufUtils.encodeVarint64()', () {
    test('Should [return encoded varint64] for given BigInt value (value < 128)', () {
      // Act
      List<int> actualEncodedVarint64 = ProtobufUtils.encodeVarint64(BigInt.parse('127'));

      // Assert
      List<int> expectedEncodedVarint64 = <int>[127];

      expect(actualEncodedVarint64, expectedEncodedVarint64);
    });

    test('Should [return encoded varint64] for given BigInt value (value 128-16383)', () {
      // Act
      List<int> actualEncodedVarint64 = ProtobufUtils.encodeVarint64(BigInt.parse('128'));

      // Assert
      List<int> expectedEncodedVarint64 = <int>[128, 1];

      expect(actualEncodedVarint64, expectedEncodedVarint64);
    });

    test('Should [return encoded varint64] for given BigInt value (value 16384-2097151)', () {
      // Act
      List<int> actualEncodedVarint64 = ProtobufUtils.encodeVarint64(BigInt.parse('16384'));

      // Assert
      List<int> expectedEncodedVarint64 = <int>[128, 128, 1];

      expect(actualEncodedVarint64, expectedEncodedVarint64);
    });

    test('Should [return encoded varint64] for given BigInt value (value 2097152-268435455)', () {
      // Act
      List<int> actualEncodedVarint64 = ProtobufUtils.encodeVarint64(BigInt.parse('2097152'));

      // Assert
      List<int> expectedEncodedVarint64 = <int>[128, 128, 128, 1];

      expect(actualEncodedVarint64, expectedEncodedVarint64);
    });

    test('Should [return encoded varint64] for given BigInt value (value 268435456-34359738367)', () {
      // Act
      List<int> actualEncodedVarint64 = ProtobufUtils.encodeVarint64(BigInt.parse('268435456'));

      // Assert
      List<int> expectedEncodedVarint64 = <int>[128, 128, 128, 128, 1];

      expect(actualEncodedVarint64, expectedEncodedVarint64);
    });

    test('Should [return encoded varint64] for given BigInt value (value 34359738368-4398046511103)', () {
      // Act
      List<int> actualEncodedVarint64 = ProtobufUtils.encodeVarint64(BigInt.parse('34359738368'));

      // Assert
      List<int> expectedEncodedVarint64 = <int>[128, 128, 128, 128, 128, 1];

      expect(actualEncodedVarint64, expectedEncodedVarint64);
    });

    test('Should [return encoded varint64] for given BigInt value (value 4398046511104-562949953421311)', () {
      // Act
      List<int> actualEncodedVarint64 = ProtobufUtils.encodeVarint64(BigInt.parse('4398046511104'));

      // Assert
      List<int> expectedEncodedVarint64 = <int>[128, 128, 128, 128, 128, 128, 1];

      expect(actualEncodedVarint64, expectedEncodedVarint64);
    });

    test('Should [return encoded varint64] for given BigInt value (value 562949953421312-72057594037927935)', () {
      // Act
      List<int> actualEncodedVarint64 = ProtobufUtils.encodeVarint64(BigInt.parse('562949953421312'));

      // Assert
      List<int> expectedEncodedVarint64 = <int>[128, 128, 128, 128, 128, 128, 128, 1];

      expect(actualEncodedVarint64, expectedEncodedVarint64);
    });

    test('Should [return encoded varint64] for given BigInt value (value 72057594037927936-9223372036854775807)', () {
      // Act
      List<int> actualEncodedVarint64 = ProtobufUtils.encodeVarint64(BigInt.parse('72057594037927936'));

      // Assert
      List<int> expectedEncodedVarint64 = <int>[128, 128, 128, 128, 128, 128, 128, 128, 1];

      expect(actualEncodedVarint64, expectedEncodedVarint64);
    });

    test('Should [return encoded varint64] for given BigInt value (value 9223372036854775808-18446744073709551615)', () {
      // Act
      List<int> actualEncodedVarint64 = ProtobufUtils.encodeVarint64(BigInt.parse('9223372036854775808'));

      // Assert
      List<int> expectedEncodedVarint64 = <int>[128, 128, 128, 128, 128, 128, 128, 128, 128, 1];

      expect(actualEncodedVarint64, expectedEncodedVarint64);
    });

    test('Should [return encoded varint64] for given BigInt value (max value)', () {
      // Act
      List<int> actualEncodedVarint64 = ProtobufUtils.encodeVarint64(BigInt.parse('18446744073709551615'));

      // Assert
      List<int> expectedEncodedVarint64 = <int>[255, 255, 255, 255, 255, 255, 255, 255, 255, 1];

      expect(actualEncodedVarint64, expectedEncodedVarint64);
    });
  });
}
