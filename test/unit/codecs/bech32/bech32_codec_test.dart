import 'dart:convert';

import 'package:codec_utils/src/codecs/bech32/bech32_codec.dart';
import 'package:codec_utils/src/codecs/bech32/bech32_pair.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of Bech32Codec.encode()', () {
    test('Should [return String] encoded by Bech32', () {
      // Arrange
      Bech32Pair actualBech32Pair = Bech32Pair(hrp: 'crypto', data: base64Decode('KxmiVli7oFEs8N5rjnzLtw7eym0='));

      // Act
      String actualEncodedData = Bech32Codec.encode(actualBech32Pair);

      // Assert
      String expectedEncodedData = 'crypto19vv6y4jchws9zt8sme4culxtku8dajndgyhdm2';

      expect(actualEncodedData, expectedEncodedData);
    });
  });

  group('Tests of Bech32Codec.decode()', () {
    test('Should [return Bech32Pair] decoded by Bech32', () {
      // Arrange
      String actualDataToDecode = 'crypto19vv6y4jchws9zt8sme4culxtku8dajndgyhdm2';

      // Act
      Bech32Pair actualBech32Pair = Bech32Codec.decode(actualDataToDecode);

      // Assert
      Bech32Pair expectedBech32Pair = Bech32Pair(hrp: 'crypto', data: base64Decode('KxmiVli7oFEs8N5rjnzLtw7eym0='));

      expect(actualBech32Pair, expectedBech32Pair);
    });
  });
}
