import 'dart:typed_data';

import 'package:codec_utils/src/utils/sha/hash/digest_sink.dart';
import 'package:codec_utils/src/utils/sha/sha256/sha256_sink.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

// ignore_for_file: cascade_invocations
void main() {
  group('Tests of Sha256Sink.updateHash()', () {
    test('Should [return hash] constructed from given data', () {
      // Arrange
      String actualDataToHash = 'abcdefghijklmnopqrstuvwxyz';
      Uint32List actualUint32List = Uint32List.fromList(actualDataToHash.codeUnits);
      DigestSink actualDigestSink = DigestSink();
      Sha256Sink actualSha256Sink = Sha256Sink(actualDigestSink);

      // Act
      actualSha256Sink.updateHash(actualUint32List);

      Uint32List actualDigestUint32List = actualSha256Sink.digestUint32List;

      // Assert
      Uint32List expectedDigestUint32List =
          Uint32List.fromList(<int>[402731661, 1055510437, 791927637, 2947656330, 1514833154, 2081851324, 3567160327, 163114491]);

      expect(actualDigestUint32List, expectedDigestUint32List);
    });
  });
}
