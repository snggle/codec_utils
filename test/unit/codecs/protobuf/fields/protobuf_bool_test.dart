import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufBool.encode()', () {
    test('Should [return bytes] representing bool (TRUE) encoded with protobuf', () {
      // Arrange
      ProtobufBool actualProtobufBool = const ProtobufBool(true);

      // Act
      List<int> actualProtobufResult = actualProtobufBool.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[8, 1];

      expect(actualProtobufResult, expectedProtobufResult);
    });

    test('Should [return bytes] representing bool (FALSE) encoded with protobuf', () {
      // Arrange
      ProtobufBool actualProtobufBool = const ProtobufBool(false);

      // Act
      List<int> actualProtobufResult = actualProtobufBool.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[8, 0];

      expect(actualProtobufResult, expectedProtobufResult);
    });
  });

  group('Tests of ProtobufBool.hasDefaultValue()', () {
    test('Should [return TRUE] when [bool == FALSE]', () {
      // Arrange
      ProtobufBool actualProtobufBool = const ProtobufBool(false);

      // Act
      bool actualResult = actualProtobufBool.hasDefaultValue();

      // Assert
      expect(actualResult, true);
    });

    test('Should [return FALSE] when [bool == TRUE]', () {
      // Arrange
      ProtobufBool actualProtobufBool = const ProtobufBool(true);

      // Act
      bool actualResult = actualProtobufBool.hasDefaultValue();

      // Assert
      expect(actualResult, false);
    });
  });
}
