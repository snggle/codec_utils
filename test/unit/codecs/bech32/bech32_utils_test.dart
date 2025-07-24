import 'package:codec_utils/src/codecs/bech32/bech32_utils.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tests of Bech32Utils.calculatePolymodChecksum()', () {
    test('Should [return polymod checksum] for given data', () {
      // Arrange
      List<int> actualInputUint5List = <int>[3, 3, 0, 2, 3];

      // Act
      int actualResult = Bech32Utils.calculatePolymodChecksum(actualInputUint5List);

      // Assert
      int expectedResult = 36798531;

      expect(actualResult, expectedResult);
    });
  });

  group('Tests of Bech32Utils.expandHrp()', () {
    test('Should [return expended HRP] for given data', () {
      // Arrange
      String actualHrp = 'bc';

      // Act
      List<int> actualUint5List = Bech32Utils.expandHrp(actualHrp);

      // Assert
      List<int> expectedUint5List = <int>[3, 3, 0, 2, 3];

      expect(actualUint5List, expectedUint5List);
    });
  });
}
