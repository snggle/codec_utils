import 'dart:typed_data';

import 'package:codec_utils/src/codecs/bech32/bech32_validation.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  Bech32Validation actualBech32validation = Bech32Validation();

  group('Bech32Validation Tests', () {
    test('isChecksumTooShort should return true for short checksum', () {
      bool actualBool = actualBech32validation.isChecksumTooShort(5, 'crypto1abcd');

      bool expectedBool = true;

      expect(actualBool, expectedBool);
    });

    test('isChecksumTooShort should return false for valid length', () {
      bool actualBool = actualBech32validation.isChecksumTooShort(5, 'crypto19vv6y4jchws9zt8sme4culxtku8dajndgyhdm2');

      bool expectedBool = false;

      expect(actualBool, expectedBool);
    });

    test('hasInvalidChars should return true for invalid character (-1)', () {
      bool actualBool = actualBech32validation.hasInvalidChars(<int>[-1, 255, 10, 20, 255]);

      bool expectedBool = true;

      expect(actualBool, expectedBool);
    });

    test('hasInvalidChars should return false for valid characters', () {
      bool actualBool = actualBech32validation.hasInvalidChars(<int>[255, 10, 20, 255]);

      bool expectedBool = false;
      expect(actualBool, expectedBool);
    });

    test('isPrefixTooShort should return true for empty prefix', () {
      bool actualBool = actualBech32validation.isPrefixTooShort(0);

      bool expectedBool = true;

      expect(actualBool, expectedBool);
    });

    test('isPrefixTooShort should return false for non-empty prefix', () {
      bool actualBool = actualBech32validation.isPrefixTooShort(5);

      bool expectedBool = false;

      expect(actualBool, expectedBool);
    });

    test('isMixedCase should return true for mixed-case input', () {
      bool actualBool = actualBech32validation.isMixedCase('BeCh32');

      bool expectedBool = true;

      expect(actualBool, expectedBool);
    });

    test('isMixedCase should return false for lowercase input', () {
      bool actualBool = actualBech32validation.isMixedCase('bech32');

      bool expectedBool = false;

      expect(actualBool, expectedBool);
    });

    test('isMixedCase should return false for uppercase input', () {
      expect(actualBech32validation.isMixedCase('BECH32'), isFalse);
    });

    test('hasInvalidSeparator should return true if no separator is present', () {
      expect(actualBech32validation.hasInvalidSeparator('crypto19vv6y4'), isTrue);
    });

    test('hasInvalidSeparator should return false if separator is present', () {
      expect(actualBech32validation.hasInvalidSeparator('crypto1abcd'), isFalse);
    });

    test('hasInvalidPrefixChars should return true for invalid prefix characters', () {
      expect(actualBech32validation.hasInvalidPrefixChars('\tcrypto'), isTrue);
    });

    test('hasInvalidPrefixChars should return false for valid prefix', () {
      expect(actualBech32validation.hasInvalidPrefixChars('crypto'), isFalse);
    });

    test('createChecksum should return valid checksum for a given HRP and data', () {
      String hrp = 'crypto';
      Uint8List data = Uint8List.fromList(<int>[1, 2, 3, 4, 5]);

      Uint8List checksum = actualBech32validation.createChecksum(hrp, data);

      expect(checksum.length, Bech32Validation.checksumLength);
    });

    test('isChecksumValid should return true for valid checksum', () {
      String hrp = 'crypto';
      Uint8List data = Uint8List.fromList(<int>[1, 2, 3, 4, 5]);
      Uint8List checksum = actualBech32validation.createChecksum(hrp, data);

      expect(actualBech32validation.isChecksumValid(hrp, data, checksum), isTrue);
    });

    test('isChecksumValid should return false for incorrect checksum', () {
      String hrp = 'crypto';
      Uint8List data = Uint8List.fromList(<int>[1, 2, 3, 4, 5]);
      Uint8List invalidChecksum = Uint8List.fromList(<int>[0, 0, 0, 0, 0, 0]); // Invalid checksum

      expect(actualBech32validation.isChecksumValid(hrp, data, invalidChecksum), isFalse);
    });
  });
}
