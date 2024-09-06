import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of List<ProtobufMixin>.toProtoBytes() extension', () {
    test('Should [return List of proto bytes] from given ProtobufMixins', () {
      // Arrange
      List<ProtobufMixin> protobufMixinList = <ProtobufMixin>[
        const TestProtobufMessage('/network.gov.Message1'),
        const TestProtobufMessage('/network.gov.Message2'),
        const TestProtobufMessage('/network.gov.Message3'),
      ];

      // Act
      Uint8List actualProtoBytes = protobufMixinList.toProtoBytes();

      // Assert
      Uint8List expectedProtoBytes = base64Decode('ChUvbmV0d29yay5nb3YuTWVzc2FnZTEKFS9uZXR3b3JrLmdvdi5NZXNzYWdlMgoVL25ldHdvcmsuZ292Lk1lc3NhZ2Uz');

      expect(actualProtoBytes, expectedProtoBytes);
    });
  });
}

class TestProtobufMessage with ProtobufMixin {
  final String value;

  const TestProtobufMessage(this.value);

  @override
  Uint8List toProtoBytes() {
    return Uint8List.fromList(
      <int>[
        ...ProtobufEncoder.encode(1, value),
      ],
    );
  }

  @override
  Map<String, dynamic> toProtoJson() {
    return <String, dynamic>{'value': value};
  }
}
