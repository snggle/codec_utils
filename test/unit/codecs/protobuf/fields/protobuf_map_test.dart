import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufMap.encode()', () {
    test('Should [return bytes] representing Map encoded with protobuf', () {
      // Arrange
      ProtobufMap actualProtobufMap = ProtobufMap(<AProtobufField, AProtobufField>{
        const TestProtobufAny(typeUrl: '/test.TestProtobufAny', data: <int>[1]): const TestProtobufAny(typeUrl: '/test.TestProtobufAny', data: <int>[1]),
        const ProtobufBool(false): const ProtobufBool(false),
        const ProtobufBool(true): const ProtobufBool(true),
        const ProtobufBytes(<int>[1]): const ProtobufBytes(<int>[1]),
        const TestProtobufEnum(1, 'test'): const TestProtobufEnum(1, 'test'),
        const ProtobufInt32(-256): const ProtobufInt32(-256),
        const ProtobufInt32(256): const ProtobufInt32(256),
        ProtobufInt64(BigInt.parse('123456789123456789')): ProtobufInt64(BigInt.parse('123456789123456789')),
        ProtobufInt64(BigInt.parse('-123456789123456789')): ProtobufInt64(BigInt.parse('-123456789123456789')),
        ProtobufString('Hello World!'): ProtobufString('Hello World!'),
      });

      // Act
      List<int> actualProtobufResult = actualProtobufMap.encode(1);

      // Assert
      List<int> expectedProtobufResult = base64Decode(
        'CjgKGgoVL3Rlc3QuVGVzdFByb3RvYnVmQW55EgEBChoKFS90ZXN0LlRlc3RQcm90b2J1ZkFueRIBAQoECAAIAAoECAEIAQoGCgEBCgEBCgQIAQgBChYIgP7/////////AQiA/v////////8BCgYIgAIIgAIKFAiVvsHmuumm2wEIlb7B5rrpptsBChYI68G+mcWW2aT+AQjrwb6ZxZbZpP4BChwKDEhlbGxvIFdvcmxkIQoMSGVsbG8gV29ybGQh',
      );

      expect(actualProtobufResult, expectedProtobufResult);
    });
  });

  group('Tests of ProtobufMap.hasDefaultValue()', () {
    test('Should [return TRUE] when [map EMPTY]', () {
      // Arrange
      ProtobufMap actualProtobufMap = const ProtobufMap(<AProtobufField, AProtobufField>{});

      // Act
      bool actualResult = actualProtobufMap.hasDefaultValue();

      // Assert
      expect(actualResult, true);
    });

    test('Should [return FALSE] when [map NOT EMPTY]', () {
      // Arrange
      ProtobufMap actualProtobufMap = ProtobufMap(<AProtobufField, AProtobufField>{
        const ProtobufInt32(1): ProtobufString('Hello World!'),
      });

      // Act
      bool actualResult = actualProtobufMap.hasDefaultValue();

      // Assert
      expect(actualResult, false);
    });
  });
}

class TestProtobufAny extends ProtobufAny {
  final List<int> data;

  const TestProtobufAny({
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

class TestProtobufEnum extends ProtobufEnum {
  const TestProtobufEnum(super.value, super.name);
}
