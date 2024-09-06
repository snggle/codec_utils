import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufAny.encode()', () {
    test('Should [return bytes] representing Any encoded with protobuf', () {
      // Arrange
      ProtobufAny actualProtobufAny = TestProtobufAny(
        typeUrl: '/test.gov.TestProtobufAny',
        data: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0],
      );

      // Act
      List<int> actualProtobufResult = actualProtobufAny.encode(1);

      // Assert
      List<int> expectedProtobufResult = base64Decode('CicKGS90ZXN0Lmdvdi5UZXN0UHJvdG9idWZBbnkSCgECAwQFBgcICQA=');

      expect(actualProtobufResult, expectedProtobufResult);
    });
  });

  group('Tests of ProtobufAny.toProtoBytes()', () {
    test('Should [return EMPTY Uint8List]', () {
      // Arrange
      ProtobufAny actualProtobufAny = TestProtobufAny(
        typeUrl: '/test.gov.TestProtobufAny',
        data: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0],
      );

      // Act
      Uint8List actualUint8List = actualProtobufAny.toProtoBytes();

      // Assert
      Uint8List expectedUint8List = Uint8List.fromList(<int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);

      expect(actualUint8List, expectedUint8List);
    });
  });

  group('Tests of ProtobufAny.toProtoJson()', () {
    test('Should [return Map<String, dynamic>] with type URL', () {
      // Arrange
      ProtobufAny actualProtobufAny = TestProtobufAny(
        typeUrl: '/test.gov.TestProtobufAny',
        data: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0],
      );

      // Act
      Map<String, dynamic> actualMap = actualProtobufAny.toProtoJson();

      // Assert
      expect(actualMap, <String, dynamic>{
        '@type': '/test.gov.TestProtobufAny',
        'data': 'AQIDBAUGBwgJAA==',
      });
    });
  });
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
