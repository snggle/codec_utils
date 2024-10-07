import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufInt32.encode()', () {
    test('Should [return bytes] representing Int32 encoded with protobuf (Int32 == 0)', () {
      // Arrange
      ProtobufInt32 actualProtobufInt32 = const ProtobufInt32(0);

      // Act
      List<int> actualProtobufResult = actualProtobufInt32.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[8, 0];

      expect(actualProtobufResult, expectedProtobufResult);
    });

    test('Should [return bytes] representing Int32 encoded with protobuf (Int32 < 0)', () {
      // Arrange
      ProtobufInt32 actualProtobufInt32 = const ProtobufInt32(-1234567890);

      // Act
      List<int> actualProtobufResult = actualProtobufInt32.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[8, 174, 250, 167, 179, 251, 255, 255, 255, 255, 1];

      expect(actualProtobufResult, expectedProtobufResult);
    });

    test('Should [return bytes] representing Int32 encoded with protobuf (Int32 > 0)', () {
      // Arrange
      ProtobufInt32 actualProtobufInt32 = const ProtobufInt32(1234567890);

      // Act
      List<int> actualProtobufResult = actualProtobufInt32.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[8, 210, 133, 216, 204, 4];

      expect(actualProtobufResult, expectedProtobufResult);
    });
  });

  group('Tests of ProtobufInt32.hasDefaultValue()', () {
    test('Should [return TRUE] when [int32 == 0]', () {
      // Arrange
      ProtobufInt32 actualProtobufInt32 = const ProtobufInt32(0);

      // Act
      bool actualResult = actualProtobufInt32.hasDefaultValue();

      // Assert
      expect(actualResult, true);
    });

    test('Should [return FALSE] when [int32 != 0]', () {
      // Arrange
      ProtobufInt32 actualProtobufInt32 = const ProtobufInt32(1);

      // Act
      bool actualResult = actualProtobufInt32.hasDefaultValue();

      // Assert
      expect(actualResult, false);
    });
  });
}
