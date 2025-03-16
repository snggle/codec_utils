import 'dart:typed_data';

import 'package:codec_utils/src/codecs/bech32/bech32_validation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  Bech32Validation actualBech32validation = Bech32Validation();

  group('Tests of Bech32Validation.isChecksumTooShort()', () {
    test('Should [return bool] for too short checksum', () {
      // Arrange
      int actualSeparatorPosition = 5;
      String actualInput = 'crypto1abcd';

      // Act
      bool actualBool = actualBech32validation.isChecksumTooShort(actualSeparatorPosition, actualInput);

      // Assert
      bool expectedBool = true;

      expect(actualBool, expectedBool);
    });

    test('Should [return bool] for valid length of checksum', () {
      // Arrange
      int actualSeparatorPosition = 5;
      String actualInput = 'crypto19vv6y4jchws9zt8sme4culxtku8dajndgyhdm2';

      // Act
      bool actualBool = actualBech32validation.isChecksumTooShort(actualSeparatorPosition, actualInput);

      // Assert
      bool expectedBool = false;

      expect(actualBool, expectedBool);
    });
  });

  group('Tests of Bech32Validation.hasInvalidChars()', () {
    test('Should [return bool] for invalid character', () {
      // Arrange
      List<int> actualDataList = <int>[-1, 255, 10, 20, 255];

      // Act
      bool actualBool = actualBech32validation.hasOutOfRangeChars(actualDataList);

      // Assert
      bool expectedBool = true;

      expect(actualBool, expectedBool);
    });

    test('Should [return bool] for valid characters', () {
      // Arrange
      List<int> actualDataList = <int>[255, 10, 20, 255];

      // Act
      bool actualBool = actualBech32validation.hasOutOfRangeChars(actualDataList);

      // Assert
      bool expectedBool = false;

      expect(actualBool, expectedBool);
    });
  });

  group('Tests of Bech32Validation.isPrefixTooShort()', () {
    test('Should [return bool] for to short prefix', () {
      // Arrange
      int actualSeparatorPosition = 0;

      // Act
      bool actualBool = actualBech32validation.isHrpTooShort(actualSeparatorPosition);

      // Assert
      bool expectedBool = true;

      expect(actualBool, expectedBool);
    });

    test('Should [return bool] for non-empty prefix', () {
      // Act
      bool actualBool = actualBech32validation.isHrpTooShort(5);

      // Assert
      bool expectedBool = false;

      expect(actualBool, expectedBool);
    });
  });

  group('Tests of Bech32Validation.isMixedCase()', () {
    test('Should [return bool] for mixed-case input', () {
      // Act
      bool actualBool = actualBech32validation.isMixedCase('BeCh32');

      // Assert
      bool expectedBool = true;

      expect(actualBool, expectedBool);
    });

    test('Should [return bool] for lowercase input', () {
      // Act
      bool actualBool = actualBech32validation.isMixedCase('bech32');

      // Assert
      bool expectedBool = false;

      expect(actualBool, expectedBool);
    });

    test('Should [return bool] for uppercase input', () {
      // Act
      bool actualBool = actualBech32validation.isMixedCase('BECH32');

      // Assert
      bool expectedBool = false;

      expect(actualBool, expectedBool);
    });
  });

  group('Tests of Bech32Validation.hasInvalidSeparator()', () {
    test('Should [return bool] if input has invalid separator', () {
      // Act
      bool actualBool = actualBech32validation.hasInvalidSeparator('crypty asbas');

      // Assert
      bool expectedBool = true;

      expect(actualBool, expectedBool);
    });

    test('Should [return bool] if separator is present', () {
      // Act
      bool actualBool = actualBech32validation.hasInvalidSeparator('crypto1abcd');

      // Assert
      bool expectedBool = false;

      expect(actualBool, expectedBool);
    });
  });

  group('Tests of Bech32Validation.hasInvalidPrefixChars()', () {
    test('Should [return bool] for invalid prefix characters', () {
      // Act
      bool actualBool = actualBech32validation.hasHrpInvalidChars('\tcrypto');

      // Assert
      bool expectedBool = true;

      expect(actualBool, expectedBool);
    });

    test('Should [return bool] for valid prefix', () {
      // Act
      bool actualBool = actualBech32validation.hasHrpInvalidChars('crypto');

      // Assert
      bool expectedBool = false;

      expect(actualBool, expectedBool);
    });
  });

  group('Tests of Bech32Validation.createChecksum()', () {
    test('Should [return checksum] for a given HRP and data', () {
      // Arrange
      String actualHrp = 'crypto';
      Uint8List actualDataUint8List = Uint8List.fromList(<int>[1, 2, 3, 4, 5]);

      // Act
      Uint8List actualChecksum = actualBech32validation.createChecksum(actualHrp, actualDataUint8List);

      // Assert
      Uint8List expectedChecksum = Uint8List.fromList(<int>[0, 6, 23, 3, 22, 25]);

      expect(actualChecksum, expectedChecksum);
    });
  });

  group('Tests of Bech32Validation.isChecksumValid()', () {
    test('Should [return bool] for valid checksum', () {
      // Arrange
      String actualHrp = 'crypto';
      Uint8List actualDataUint8List = Uint8List.fromList(<int>[1, 2, 3, 4, 5]);

      // Act
      Uint8List actualChecksum = actualBech32validation.createChecksum(actualHrp, actualDataUint8List);
      bool actualBool = actualBech32validation.isChecksumValid(actualHrp, actualDataUint8List, actualChecksum);

      // Assert
      bool expectedBool = true;

      expect(actualBool, expectedBool);
    });

    test('Should [return bool] for for incorrect checksum', () {
      // Arrange
      String actualHrp = 'crypto';
      Uint8List actualDataUint8List = Uint8List.fromList(<int>[1, 2, 3, 4, 5]);
      Uint8List actualChecksum = Uint8List.fromList(<int>[0, 0, 0, 0, 0, 0]);

      // Act
      bool actualBool = actualBech32validation.isChecksumValid(actualHrp, actualDataUint8List, actualChecksum);

      // Assert
      bool expectedBool = false;

      expect(actualBool, expectedBool);
    });
  });
}
