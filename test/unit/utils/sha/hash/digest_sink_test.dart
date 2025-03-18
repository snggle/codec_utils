import 'dart:typed_data';

import 'package:codec_utils/src/utils/sha/hash/digest.dart';
import 'package:codec_utils/src/utils/sha/hash/digest_sink.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

// ignore_for_file: cascade_invocations
void main() {
  group('Test of DigestSink.add()', () {
    test('Should [return valueDigest] constructed from given data', () {
      // Arrange
      DigestSink actualDigestSink = DigestSink();
      Digest actualDigest1 = Digest(Uint8List.fromList(<int>[1, 2, 3, 4]));
      Digest actualDigest2 = Digest(Uint8List.fromList(<int>[5, 6, 7, 8]));

      // Act
      actualDigestSink.add(actualDigest1);
      actualDigestSink.add(actualDigest2);
      Digest actualValueDigest = actualDigestSink.valueDigest;

      // Assert
      Digest expectedValueDigest = Digest(Uint8List.fromList(<int>[1, 2, 3, 4]));

      expect(actualValueDigest, expectedValueDigest);
    });
  });
}
