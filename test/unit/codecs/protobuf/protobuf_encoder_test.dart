import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufEncoder.encode()', () {
    test('Should [return bytes] representing encoded Protobuf entries (entries have NOT DEFAULT values)', () {
      // Arrange
      Map<int, AProtobufField> actualProtobufEntries = <int, AProtobufField>{
        0: const TestProtobufAny(typeUrl: '/test.gov.TestProtobufAny', data: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]),
        2: const ProtobufBool(true),
        3: const ProtobufBytes(<int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]),
        4: const TestProtobufEnum(1, 'test'),
        5: const ProtobufInt32(-256),
        6: const ProtobufInt32(256),
        7: ProtobufInt64(BigInt.parse('123456789123456789')),
        8: ProtobufInt64(BigInt.parse('-123456789123456789')),
        9: ProtobufList(<AProtobufField>[
          const TestProtobufAny(typeUrl: '/test.gov.TestProtobufAny', data: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]),
          const ProtobufBool(true),
          const ProtobufBytes(<int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]),
          const TestProtobufEnum(1, 'test'),
          const ProtobufInt32(-256),
          const ProtobufInt32(256),
          ProtobufInt64(BigInt.parse('123456789123456789')),
          ProtobufInt64(BigInt.parse('-123456789123456789')),
          ProtobufString('Hello World!'),
        ]),
        10: ProtobufMap(<AProtobufField, AProtobufField>{
          const TestProtobufAny(typeUrl: '/test.TestProtobufAny', data: <int>[1]): const TestProtobufAny(typeUrl: '/test.TestProtobufAny', data: <int>[1]),
          const ProtobufBool(true): const ProtobufBool(true),
          const ProtobufBytes(<int>[1]): const ProtobufBytes(<int>[1]),
          const TestProtobufEnum(1, 'test'): const TestProtobufEnum(1, 'test'),
          const ProtobufInt32(-256): const ProtobufInt32(-256),
          const ProtobufInt32(256): const ProtobufInt32(256),
          ProtobufInt64(BigInt.parse('123456789123456789')): ProtobufInt64(BigInt.parse('123456789123456789')),
          ProtobufInt64(BigInt.parse('-123456789123456789')): ProtobufInt64(BigInt.parse('-123456789123456789')),
          ProtobufString('Hello World!'): ProtobufString('Hello World!'),
        }),
        11: ProtobufString('Hello World!'),
      };

      // Act
      List<int> actualProtobufResult = ProtobufEncoder.encode(actualProtobufEntries);

      // Assert
      List<int> expectedProtobufResult = base64Decode(
        'AicKGS90ZXN0Lmdvdi5UZXN0UHJvdG9idWZBbnkSCgECAwQFBgcICQAQARoKAQIDBAUGBwgJACABKID+/////////wEwgAI4lb7B5rrpptsBQOvBvpnFltmk/gFKJwoZL3Rlc3QuZ292LlRlc3RQcm90b2J1ZkFueRIKAQIDBAUGBwgJAEgBSgoBAgMEBQYHCAkASAFIgP7/////////AUiAAkiVvsHmuumm2wFI68G+mcWW2aT+AUoMSGVsbG8gV29ybGQhUjhSGgoVL3Rlc3QuVGVzdFByb3RvYnVmQW55EgEBUhoKFS90ZXN0LlRlc3RQcm90b2J1ZkFueRIBAVIEUAFQAVIGUgEBUgEBUgRQAVABUhZQgP7/////////AVCA/v////////8BUgZQgAJQgAJSFFCVvsHmuumm2wFQlb7B5rrpptsBUhZQ68G+mcWW2aT+AVDrwb6ZxZbZpP4BUhxSDEhlbGxvIFdvcmxkIVIMSGVsbG8gV29ybGQhWgxIZWxsbyBXb3JsZCE=',
      );

      expect(actualProtobufResult, expectedProtobufResult);
    });

    test('Should [return empty bytes] when (entries have DEFAULT values)', () {
      // Arrange
      Map<int, AProtobufField> actualProtobufEntries = <int, AProtobufField>{
        0: const ProtobufBool(false),
        1: const ProtobufBytes(<int>[]),
        2: const ProtobufInt32(0),
        3: ProtobufInt64(BigInt.zero),
        4: const ProtobufList(<AProtobufField>[]),
        5: const ProtobufMap(<AProtobufField, AProtobufField>{}),
        6: ProtobufString(''),
      };

      // Act
      List<int> actualProtobufResult = ProtobufEncoder.encode(actualProtobufEntries);

      // Assert
      List<int> expectedProtobufResult = <int>[];

      expect(actualProtobufResult, expectedProtobufResult);
    });

    test('Should [return empty bytes] when (entries have NULL values)', () {
      // Arrange
      Map<int, AProtobufField?> actualProtobufEntries = <int, AProtobufField?>{
        0: null,
        1: null,
        2: null,
        3: null,
      };

      // Act
      List<int> actualProtobufResult = ProtobufEncoder.encode(actualProtobufEntries);

      // Assert
      List<int> expectedProtobufResult = <int>[];

      expect(actualProtobufResult, expectedProtobufResult);
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
