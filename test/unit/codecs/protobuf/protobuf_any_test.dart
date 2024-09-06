import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/src/codecs/protobuf/protobuf_any.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufAny.packAny()', () {
    test('Should [return Uint8List] with encoded type URL', () {
      // Arrange
      ProtobufAny actualProtobufAny = const ProtobufAny(typeUrl: '/network.gov.Message');

      // Act
      Uint8List actualUint8List = actualProtobufAny.packAny();

      // Assert
      expect(actualUint8List, base64Decode('ChQvbmV0d29yay5nb3YuTWVzc2FnZRIA'));
    });
  });

  group('Tests of ProtobufAny.toProtoBytes()', () {
    test('Should [return EMPTY Uint8List]', () {
      // Arrange
      ProtobufAny actualProtobufAny = const ProtobufAny(typeUrl: '/network.gov.Message');

      // Act
      Uint8List actualUint8List = actualProtobufAny.toProtoBytes();

      // Assert
      expect(actualUint8List, Uint8List(0));
    });
  });

  group('Tests of ProtobufAny.toProtoJson()', () {
    test('Should [return Map<String, dynamic>] with type URL', () {
      // Arrange
      ProtobufAny actualProtobufAny = const ProtobufAny(typeUrl: '/network.gov.Message');

      // Act
      Map<String, dynamic> actualMap = actualProtobufAny.toProtoJson();

      // Assert
      expect(actualMap, <String, dynamic>{'@type': '/network.gov.Message'});
    });
  });
}
