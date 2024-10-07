import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ProtobufInt64.encode()', () {
    test('Should [return bytes] representing Int64 encoded with protobuf (Int64 == 0)', () {
      // Arrange
      ProtobufInt64 actualProtobufInt64 = ProtobufInt64(BigInt.from(0));

      // Act
      List<int> actualProtobufResult = actualProtobufInt64.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[8, 0];

      expect(actualProtobufResult, expectedProtobufResult);
    });

    test('Should [return bytes] representing Int64 encoded with protobuf (Int64 < Int32 < 0)', () {
      // Arrange
      ProtobufInt64 actualProtobufInt64 = ProtobufInt64(BigInt.parse('-12345678901234567890'));

      // Act
      List<int> actualProtobufResult = actualProtobufInt64.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[8, 174, 234, 131, 167, 177, 206, 213, 213, 212, 1];

      expect(actualProtobufResult, expectedProtobufResult);
    });

    test('Should [return bytes] representing Int64 encoded with protobuf (Int32 < Int64 < 0)', () {
      // Arrange
      ProtobufInt64 actualProtobufInt64 = ProtobufInt64(BigInt.from(-1234567890));

      // Act
      List<int> actualProtobufResult = actualProtobufInt64.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[8, 174, 250, 167, 179, 251, 255, 255, 255, 255, 1];

      expect(actualProtobufResult, expectedProtobufResult);
    });

    test('Should [return bytes] representing Int64 encoded with protobuf (0 < Int64 < Int32)', () {
      // Arrange
      ProtobufInt64 actualProtobufInt64 = ProtobufInt64(BigInt.from(1234567890));

      // Act
      List<int> actualProtobufResult = actualProtobufInt64.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[8, 210, 133, 216, 204, 4];

      expect(actualProtobufResult, expectedProtobufResult);
    });

    test('Should [return bytes] representing Int64 encoded with protobuf (0 < Int32 > Int64)', () {
      // Arrange
      ProtobufInt64 actualProtobufInt64 = ProtobufInt64(BigInt.parse('12345678901234567890'));

      // Act
      List<int> actualProtobufResult = actualProtobufInt64.encode(1);

      // Assert
      List<int> expectedProtobufResult = <int>[8, 210, 149, 252, 216, 206, 177, 170, 170, 171, 1];

      expect(actualProtobufResult, expectedProtobufResult);
    });
  });

  group('Tests of ProtobufInt64.hasDefaultValue()', () {
    test('Should [return TRUE] when [int64 == 0]', () {
      // Arrange
      ProtobufInt64 actualProtobufInt64 = ProtobufInt64(BigInt.zero);

      // Act
      bool actualResult = actualProtobufInt64.hasDefaultValue();

      // Assert
      expect(actualResult, true);
    });

    test('Should [return FALSE] when [int64 != 0]', () {
      // Arrange
      ProtobufInt64 actualProtobufInt64 = ProtobufInt64(BigInt.from(1));

      // Act
      bool actualResult = actualProtobufInt64.hasDefaultValue();

      // Assert
      expect(actualResult, false);
    });
  });
}
