import 'package:codec_utils/src/codecs/uniform_resource/ur_parsed_part.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of URParsedPart.hasType()', () {
    test('Should [return TRUE] if UR has expected type', () {
      // Arrange
      URParsedPart actualURParsedPart = const URParsedPart(
        type: 'crypto-keypath',
        components: <String>['taaddyoeadlecsdwykcsfnykaeykaewkaewkaocymshlgtwnvejedtny'],
      );

      // Act
      bool actualTypeMatchBool = actualURParsedPart.hasType('crypto-keypath');

      // Assert
      expect(actualTypeMatchBool, true);
    });

    test('Should [return FALSE] if UR does not have expected type', () {
      // Arrange
      URParsedPart actualURParsedPart = const URParsedPart(
        type: 'crypto-keypath',
        components: <String>['taaddyoeadlecsdwykcsfnykaeykaewkaewkaocymshlgtwnvejedtny'],
      );

      // Act
      bool actualTypeMatchBool = actualURParsedPart.hasType('crypto-hdkey');

      // Assert
      expect(actualTypeMatchBool, false);
    });
  });

  group('Tests of URParsedPart.isSinglePartUR()', () {
    test('Should [return TRUE] if UR is single part', () {
      // Arrange
      URParsedPart actualURParsedPart = const URParsedPart(
        type: 'crypto-keypath',
        components: <String>['taaddyoeadlecsdwykcsfnykaeykaewkaewkaocymshlgtwnvejedtny'],
      );

      // Act
      bool actualIsSinglePartURBool = actualURParsedPart.isSinglePartUR;

      // Assert
      expect(actualIsSinglePartURBool, true);
    });

    test('Should [return FALSE] if UR is multi part', () {
      // Arrange
      URParsedPart actualURParsedPart = const URParsedPart(
        type: 'crypto-hdkey',
        components: <String>['1-4', 'lpadaacsjpcyrkbedymnhdcaonaxhdclaxpsgefyjsutpfckcalydtgyjpamjlndfsetiyhtetaajprnzslkoxkkto'],
      );

      // Act
      bool actualIsSinglePartURBool = actualURParsedPart.isSinglePartUR;

      // Assert
      expect(actualIsSinglePartURBool, false);
    });
  });
}
