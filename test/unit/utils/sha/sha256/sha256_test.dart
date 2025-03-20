import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/src/utils/sha/hash/digest.dart';
import 'package:codec_utils/src/utils/sha/sha256/sha256.dart';
import 'package:test/test.dart';

/// For calculating [expectedHashString] an online calculator was used: https://emn178.github.io/online-tools/sha256.html
void main() {
  group('Tests of Sha256.convert()', () {
    test('Should [return hash] constructed from given data', () {
      // Arrange
      Uint8List actualDataToHash = utf8.encode('123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~');

      // Act
      Digest actualDigest = Sha256().convert(actualDataToHash);
      String actualHashString = base64Encode(actualDigest.byteList);

      // Assert
      String expectedHashString = '3wD7XtFKJSyhir71QWYpVt043ekXhh67rrDyHE+EsiQ=';

      expect(actualHashString, expectedHashString);
    });
  });
}
