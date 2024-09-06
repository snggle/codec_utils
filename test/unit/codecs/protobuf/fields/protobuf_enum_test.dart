import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufEnum.encode()', () {
    test('Should [return bytes] representing Enum encoded with protobuf', () {
      // Arrange
      ProtobufEnum actualProtobufEnum = TestProtobufEnum(1, 'test');

      // Act
      List<int> actualProtobufResult = actualProtobufEnum.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[8, 1];

      expect(actualProtobufResult, expectedProtobufResult);
    });
  });
}

class TestProtobufEnum extends ProtobufEnum {
  TestProtobufEnum(super.value, super.name);
}
