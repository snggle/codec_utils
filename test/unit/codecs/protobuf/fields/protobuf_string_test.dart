import 'dart:convert';

import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufString.encode()', () {
    test('Should [return bytes] representing String encoded with protobuf (String EMPTY)', () {
      // Arrange
      ProtobufString actualProtobufString = ProtobufString('');

      // Act
      List<int> actualProtobufResult = actualProtobufString.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[10, 0];

      expect(actualProtobufResult, expectedProtobufResult);
    });

    test('Should [return bytes] representing String encoded with protobuf (String NOT EMPTY)', () {
      // Arrange
      ProtobufString actualProtobufString = ProtobufString('/test.gov.TestProtobufAny');

      // Act
      List<int> actualProtobufResult = actualProtobufString.encode(1);

      // Assert
      List<int> expectedProtobufResult = base64Decode('ChkvdGVzdC5nb3YuVGVzdFByb3RvYnVmQW55');

      expect(actualProtobufResult, expectedProtobufResult);
    });
  });

  group('Tests of ProtobufString.hasDefaultValue()', () {
    test('Should [return TRUE] when [string EMPTY]', () {
      // Arrange
      ProtobufString actualProtobufString = ProtobufString('');

      // Act
      bool actualResult = actualProtobufString.hasDefaultValue();

      // Assert
      expect(actualResult, true);
    });

    test('Should [return FALSE] when [string NOT EMPTY]', () {
      // Arrange
      ProtobufString actualProtobufString = ProtobufString('Hello World!');

      // Act
      bool actualResult = actualProtobufString.hasDefaultValue();

      // Assert
      expect(actualResult, false);
    });
  });
}
