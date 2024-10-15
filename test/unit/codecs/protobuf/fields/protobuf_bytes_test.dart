import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufBytes.encode()', () {
    test('Should [return bytes] representing bytes encoded with protobuf', () {
      // Arrange
      ProtobufBytes actualProtobufBytes = const ProtobufBytes(<int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);

      // Act
      List<int> actualProtobufResult = actualProtobufBytes.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[10, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0];

      expect(actualProtobufResult, expectedProtobufResult);
    });
  });

  group('Tests of ProtobufBytes.hasDefaultValue()', () {
    test('Should [return TRUE] when [bytes EMPTY]', () {
      // Arrange
      ProtobufBytes actualProtobufBytes = const ProtobufBytes(<int>[]);

      // Act
      bool actualResult = actualProtobufBytes.hasDefaultValue();

      // Assert
      expect(actualResult, true);
    });

    test('Should [return TRUE] when [bytes NOT EMPTY]', () {
      // Arrange
      ProtobufBytes actualProtobufBytes = const ProtobufBytes(<int>[1, 2, 3]);

      // Act
      bool actualResult = actualProtobufBytes.hasDefaultValue();

      // Assert
      expect(actualResult, false);
    });
  });
}
