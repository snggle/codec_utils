import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufList.encode()', () {
    test('Should [return bytes] representing List encoded with protobuf', () {
      // Arrange
      ProtobufList actualProtobufList = ProtobufList(<AProtobufField>[
        const TestProtobufAny(typeUrl: '/test.gov.TestProtobufAny', data: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]),
        const ProtobufBool(false),
        const ProtobufBool(true),
        const ProtobufBytes(<int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]),
        const TestProtobufEnum(1, 'test'),
        const ProtobufInt32(-256),
        const ProtobufInt32(256),
        ProtobufInt64(BigInt.parse('123456789123456789')),
        ProtobufInt64(BigInt.parse('-123456789123456789')),
        ProtobufList(<AProtobufField>[
          const TestProtobufAny(typeUrl: '/test.gov.TestProtobufAny', data: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]),
          const ProtobufBool(false),
          const ProtobufBool(true),
          const ProtobufBytes(<int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]),
          const TestProtobufEnum(1, 'test'),
          const ProtobufInt32(-256),
          const ProtobufInt32(256),
          ProtobufInt64(BigInt.parse('123456789123456789')),
          ProtobufInt64(BigInt.parse('-123456789123456789')),
          ProtobufString('Hello World!'),
        ]),
        ProtobufMap(<AProtobufField, AProtobufField>{
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
        }),
        ProtobufString('Hello World!'),
      ]);

      // Act
      List<int> actualProtobufResult = actualProtobufList.encode(1);

      // Assert
      List<int> expectedProtobufResult = base64Decode(
        'CicKGS90ZXN0Lmdvdi5UZXN0UHJvdG9idWZBbnkSCgECAwQFBgcICQAIAAgBCgoBAgMEBQYHCAkACAEIgP7/////////AQiAAgiVvsHmuumm2wEI68G+mcWW2aT+AQonChkvdGVzdC5nb3YuVGVzdFByb3RvYnVmQW55EgoBAgMEBQYHCAkACAAIAQoKAQIDBAUGBwgJAAgBCID+/////////wEIgAIIlb7B5rrpptsBCOvBvpnFltmk/gEKDEhlbGxvIFdvcmxkIQo4ChoKFS90ZXN0LlRlc3RQcm90b2J1ZkFueRIBAQoaChUvdGVzdC5UZXN0UHJvdG9idWZBbnkSAQEKBAgACAAKBAgBCAEKBgoBAQoBAQoECAEIAQoWCID+/////////wEIgP7/////////AQoGCIACCIACChQIlb7B5rrpptsBCJW+wea66abbAQoWCOvBvpnFltmk/gEI68G+mcWW2aT+AQocCgxIZWxsbyBXb3JsZCEKDEhlbGxvIFdvcmxkIQoMSGVsbG8gV29ybGQh',
      );

      expect(actualProtobufResult, expectedProtobufResult);
    });
  });

  group('Tests of ProtobufList.hasDefaultValue()', () {
    test('Should [return TRUE] when [list EMPTY]', () {
      // Arrange
      ProtobufList actualProtobufList = const ProtobufList(<AProtobufField>[]);

      // Act
      bool actualResult = actualProtobufList.hasDefaultValue();

      // Assert
      expect(actualResult, true);
    });

    test('Should [return FALSE] when [list NOT EMPTY]', () {
      // Arrange
      ProtobufList actualProtobufList = const ProtobufList(<AProtobufField>[
        ProtobufBool(true),
      ]);

      // Act
      bool actualResult = actualProtobufList.hasDefaultValue();

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
