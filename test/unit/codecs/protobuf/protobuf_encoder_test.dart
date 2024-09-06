import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/src/codecs/protobuf/protobuf_any.dart';
import 'package:codec_utils/src/codecs/protobuf/protobuf_encoder.dart';
import 'package:codec_utils/src/codecs/protobuf/protobuf_enum.dart';
import 'package:codec_utils/src/codecs/protobuf/protobuf_mixin.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufEncoder.encode()', () {
    test('Should [return bytes] for ProtobufEnum', () {
      // Arrange
      TestProtobufEnum actualTestProtobufEnum = TestProtobufEnum(1, 'test');

      // Act
      List<int> actualProtobufBytes = ProtobufEncoder.encode(1, actualTestProtobufEnum);

      // Assert
      List<int> expectedProtobufBytes = <int>[8, 1];

      expect(actualProtobufBytes, expectedProtobufBytes);
    });

    test('Should [return bytes] for ProtobufAny', () {
      // Arrange
      TestProtobufAny actualTestProtobufAny = TestProtobufAny(
        typeUrl: '/test.gov.TestProtobufAny',
        data: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0],
      );

      // Act
      List<int> actualProtobufBytes = ProtobufEncoder.encode(1, actualTestProtobufAny);

      // Assert
      List<int> expectedProtobufBytes = base64Decode('CicKGS90ZXN0Lmdvdi5UZXN0UHJvdG9idWZBbnkSCgECAwQFBgcICQA=');

      expect(actualProtobufBytes, expectedProtobufBytes);
    });

    test('Should [return bytes] for ProtobufMixin', () {
      // Arrange
      TestProtobufMixin actualTestProtobufMixin = TestProtobufMixin(data: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);

      // Act
      List<int> actualProtobufBytes = ProtobufEncoder.encode(1, actualTestProtobufMixin);

      // Assert
      List<int> expectedProtobufBytes = <int>[10, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0];

      expect(actualProtobufBytes, expectedProtobufBytes);
    });

    test('Should [return bytes] for BigInt', () {
      // Arrange
      BigInt actualBigInt = BigInt.from(1234567890);

      // Act
      List<int> actualProtobufBytes = ProtobufEncoder.encode(1, actualBigInt);

      // Assert
      List<int> expectedProtobufBytes = <int>[8, 210, 133, 216, 204, 4];

      expect(actualProtobufBytes, expectedProtobufBytes);
    });

    test('Should [return bytes] for int', () {
      // Arrange
      int actualInt = 1234567890;

      // Act
      List<int> actualProtobufBytes = ProtobufEncoder.encode(1, actualInt);

      // Assert
      List<int> expectedProtobufBytes = <int>[8, 210, 133, 216, 204, 4];

      expect(actualProtobufBytes, expectedProtobufBytes);
    });

    test('Should [return bytes] for List<int>', () {
      // Arrange
      List<int> actualListInt = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0];

      // Act
      List<int> actualProtobufBytes = ProtobufEncoder.encode(1, actualListInt);

      // Assert
      List<int> expectedProtobufBytes = <int>[10, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0];

      expect(actualProtobufBytes, expectedProtobufBytes);
    });

    test('Should [return bytes] for String', () {
      // Arrange
      String actualString = 'test';

      // Act
      List<int> actualProtobufBytes = ProtobufEncoder.encode(1, actualString);

      // Assert
      List<int> expectedProtobufBytes = <int>[10, 4, 116, 101, 115, 116];

      expect(actualProtobufBytes, expectedProtobufBytes);
    });

    test('Should [return bytes] for List', () {
      // Arrange
      List<dynamic> actualList = <dynamic>[false, 1, BigInt.from(2), '3'];

      // Act
      List<int> actualProtobufBytes = ProtobufEncoder.encode(1, actualList);

      // Assert
      List<int> expectedProtobufBytes = <int>[8, 0, 8, 1, 8, 2, 10, 1, 51];

      expect(actualProtobufBytes, expectedProtobufBytes);
    });

    test('Should [return bytes] for bool (bool == true)', () {
      // Arrange
      bool actualBool = true;

      // Act
      List<int> actualProtobufBytes = ProtobufEncoder.encode(1, actualBool);

      // Assert
      List<int> expectedProtobufBytes = <int>[8, 1];

      expect(actualProtobufBytes, expectedProtobufBytes);
    });

    test('Should [return bytes] for bool (bool == false)', () {
      // Arrange
      bool actualBool = false;

      // Act
      List<int> actualProtobufBytes = ProtobufEncoder.encode(1, actualBool);

      // Assert
      List<int> expectedProtobufBytes = <int>[8, 0];

      expect(actualProtobufBytes, expectedProtobufBytes);
    });

    test('Should [return bytes] for Map', () {
      // Arrange
      Map<dynamic, dynamic> actualMap = <dynamic, dynamic>{
        'key': 'value',
      };

      // Act
      List<int> actualProtobufBytes = ProtobufEncoder.encode(1, actualMap);

      // Assert
      List<int> expectedProtobufBytes = <int>[10, 12, 10, 3, 107, 101, 121, 18, 5, 118, 97, 108, 117, 101];

      expect(actualProtobufBytes, expectedProtobufBytes);
    });
  });
}

class TestProtobufEnum extends ProtobufEnum {
  TestProtobufEnum(super.value, super.name);
}

class TestProtobufAny extends ProtobufAny {
  final List<int> data;

  TestProtobufAny({
    required super.typeUrl,
    required this.data,
  });

  @override
  Uint8List toProtoBytes() {
    return Uint8List.fromList(data);
  }

  @override
  Map<String, dynamic> toProtoJson() {
    return <String, dynamic>{
      '@type': typeUrl,
      'data': base64Encode(data),
    };
  }
}

class TestProtobufMixin with ProtobufMixin {
  final List<int> data;

  TestProtobufMixin({required this.data});

  @override
  Uint8List toProtoBytes() {
    return Uint8List.fromList(data);
  }

  @override
  Map<String, dynamic> toProtoJson() {
    return <String, dynamic>{
      'data': base64Encode(data),
    };
  }
}
