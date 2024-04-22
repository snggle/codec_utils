import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/src/codecs/fountain/decoder/fountain_decoder.dart';
import 'package:codec_utils/src/codecs/fountain/encoder/fountain_encoder_part.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of FountainDecoder process', () {
    FountainDecoder actualFountainDecoder = FountainDecoder();

    test('Should [return initial values] if no parts received', () {
      // Arrange
      expect(actualFountainDecoder.resultMessage(), null);
      expect(actualFountainDecoder.progress, 0.0);
      expect(actualFountainDecoder.estimatedPercentComplete, 0.0);
      expect(actualFountainDecoder.isComplete, false);
      expect(actualFountainDecoder.expectedPartCount, null);
    });

    test('Should [return actual values] after 1st fragment received (1/3)', () async {
      // Act
      actualFountainDecoder.receivePart(
        FountainEncoderPart(
          sequenceNumber: 108,
          sequenceLength: 3,
          messageLength: 408,
          checksum: 2710450950,
          fragment: base64Decode(
              '9BrFM2Nev7JuM6pdFIb8RVwQtxw1SwpbWQBiezI0cSQwLSslTjF7JTxYP0MtFg19aSgUcjUiNzJhODstZDNgeDciejUyK3VpJjU7ZTwnRyY8agw5dmETBx8by0IrrU63XTHxUTz/U6lI4Rr9UUfZAQLnBl/WjVlBu3IS9nNObZP8jif1Drktmw=='),
        ),
      );

      // Assert
      expect(actualFountainDecoder.resultMessage(), null);
      expect(actualFountainDecoder.progress, 0.0);
      expect(actualFountainDecoder.estimatedPercentComplete, 0.19047619047619047);
      expect(actualFountainDecoder.isComplete, false);
      expect(actualFountainDecoder.expectedPartCount, 3);
    });

    test('Should [return actual values] after 3rd fragment received (2/3)', () async {
      // Act
      actualFountainDecoder.receivePart(
        FountainEncoderPart(
          sequenceNumber: 292,
          sequenceLength: 3,
          messageLength: 408,
          checksum: 2710450950,
          fragment: base64Decode(
              'MHhkNmM2MzI2NTg1N2M1MWVlNzk0OTY0ZDJmOTg0MzFiMDJkYjg3ZWU3CgpOb25jZToKNzI5NzZhMzktYzI0OS00MzM2LWI5MzUtYTZkYzUxZTYyNzU1AwMF2QEwogGKGCz1GDz1APUA9AD0AhqXXU3xBlTWxjJlhXxR7nlJZNL5hDGwLbh+5w=='),
        ),
      );

      // Assert
      expect(actualFountainDecoder.resultMessage(), null);
      expect(actualFountainDecoder.progress, 0.3333333333333333);
      expect(actualFountainDecoder.estimatedPercentComplete, 0.38095238095238093);
      expect(actualFountainDecoder.isComplete, false);
      expect(actualFountainDecoder.expectedPartCount, 3);
    });

    test('Should [return complete values] after 2nd fragment received (3/3)', () async {
      // Act
      actualFountainDecoder.receivePart(
        FountainEncoderPart(
          sequenceNumber: 252,
          sequenceLength: 3,
          messageLength: 408,
          checksum: 2710450950,
          fragment: base64Decode(
              'lXm8EzMx09sNSop1fPKINS8qmDNaO281KmUDVVtbXlRCRF1ELUhSCzZSaytEZS0PDFlhF0ZWF0UIVFcNClwUWENQE1JVTgdJRxVZCVNELEVUC2VXVhVhZnFoqiFfxCHZfV6DcV+QIN1ogHSEcSC4ciKBYzqlo1NL7BN+mhY6TfKY6lWQfcoXkQ=='),
        ),
      );

      // Assert
      Uint8List expectedResult = base64Decode(
        'pQHYJVAH4Ok7f7JAS5G9BEpPrwpuAlkBTldlbGNvbWUgdG8gT3BlblNlYSEKCkNsaWNrIHRvIHNpZ24gaW4gYW5kIGFjY2VwdCB0aGUgT3BlblNlYSBUZXJtcyBvZiBTZXJ2aWNlIChodHRwczovL29wZW5zZWEuaW8vdG9zKSBhbmQgUHJpdmFjeSBQb2xpY3kgKGh0dHBzOi8vb3BlbnNlYS5pby9wcml2YWN5KS4KClRoaXMgcmVxdWVzdCB3aWxsIG5vdCB0cmlnZ2VyIGEgYmxvY2tjaGFpbiB0cmFuc2FjdGlvbiBvciBjb3N0IGFueSBnYXMgZmVlcy4KCldhbGxldCBhZGRyZXNzOgoweGQ2YzYzMjY1ODU3YzUxZWU3OTQ5NjRkMmY5ODQzMWIwMmRiODdlZTcKCk5vbmNlOgo3Mjk3NmEzOS1jMjQ5LTQzMzYtYjkzNS1hNmRjNTFlNjI3NTUDAwXZATCiAYoYLPUYPPUA9QD0APQCGpddTfEGVNbGMmWFfFHueUlk0vmEMbAtuH7n',
      );

      expect(actualFountainDecoder.resultMessage(), expectedResult);
      expect(actualFountainDecoder.progress, 1.0);
      expect(actualFountainDecoder.estimatedPercentComplete, 1.0);
      expect(actualFountainDecoder.isComplete, true);
      expect(actualFountainDecoder.expectedPartCount, 3);
    });
  });
}
