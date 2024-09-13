import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/src/codecs/bech32/segwit_bech32_codec.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of SegwitBech32Codec.encode()', () {
    test('Should [return String] encoded by Bech32 (Segwit version)', () {
      // Arrange
      Uint8List actualDataToEncode = base64Decode('KxmiVli7oFEs8N5rjnzLtw7eym0=');

      // Act
      String actualEncodedData = SegwitBech32Codec.encode('bc', 0, actualDataToEncode);

      // Assert
      String expectedEncodedData = 'bc1q9vv6y4jchws9zt8sme4culxtku8dajnd5jq660';

      expect(actualEncodedData, expectedEncodedData);
    });
  });

  group('Tests of SegwitBech32Codec.decode()', () {
    test('Should [return String] encoded by Bech32 (Segwit version)', () {
      // Arrange
      String actualDataToDecode = 'bc1q9vv6y4jchws9zt8sme4culxtku8dajnd5jq660';

      // Act
      Uint8List actualDecodedData = SegwitBech32Codec.decode(actualDataToDecode);

      // Assert
      Uint8List expectedDecodedData = base64Decode('KxmiVli7oFEs8N5rjnzLtw7eym0=');

      expect(actualDecodedData, expectedDecodedData);
    });
  });
}
