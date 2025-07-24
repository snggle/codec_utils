import 'package:codec_utils/src/utils/bytes_utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tests of BytesUtils.convertBits()', () {
    test('Should [return converted bits] from 8 to 5 with padding', () {
      // Arrange
      List<int> actualInputList = <int>[255];

      // Act
      List<int> actualOutputList = BytesUtils.convertBits(actualInputList, 8, 5, allowPaddingBool: true);

      // Assert
      List<int> expectedOutputList = <int>[31, 28];

      expect(actualOutputList, expectedOutputList);
    });

    test('Should [return converted bits] from 8 to 5 without padding', () {
      // Arrange
      List<int> actualInputList = <int>[30];

      // Act
      List<int> actualOutputList = BytesUtils.convertBits(actualInputList, 8, 5, allowPaddingBool: false);

      // Assert
      List<int> expectedOutputList = <int>[3];

      expect(actualOutputList, expectedOutputList);
    });

    test('Should [return converted bits] from 5 to 8 with padding', () {
      // Arrange
      List<int> actualInputList = <int>[3, 30];

      // Act
      List<int> actualOutputList = BytesUtils.convertBits(actualInputList, 5, 8, allowPaddingBool: true);

      // Assert
      List<int> expectedOutputList = <int>[31, 128];

      expect(actualOutputList, expectedOutputList);
    });

    test('Should [throw FormatException] for invalid input', () {
      // Arrange
      List<int> actualInputList = <int>[-1];

      // Assert
      expect(() => BytesUtils.convertBits(actualInputList, 8, 5, allowPaddingBool: true), throwsA(isA<FormatException>()));
    });

    test('Should [throw FormatException] for invalid input', () {
      // Arrange
      List<int> actualInputList = <int>[256];

      // Assert
      expect(() => BytesUtils.convertBits(actualInputList, 8, 5, allowPaddingBool: true), throwsA(isA<FormatException>()));
    });
  });
}
