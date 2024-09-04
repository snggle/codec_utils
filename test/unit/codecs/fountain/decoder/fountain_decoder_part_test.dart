import 'dart:convert';

import 'package:codec_utils/src/codecs/fountain/decoder/fountain_decoder_part.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of FountainDecoderPart.isSimple getter', () {
    test('Should [return TRUE] if part contains [ONLY ONE index]', () {
      // Arrange
      FountainDecoderPart actualFountainDecoderPart = FountainDecoderPart(
        indexes: const <int>[2],
        fragment: base64Decode(
          'MHhkNmM2MzI2NTg1N2M1MWVlNzk0OTY0ZDJmOTg0MzFiMDJkYjg3ZWU3CgpOb25jZToKNzI5NzZhMzktYzI0OS00MzM2LWI5MzUtYTZkYzUxZTYyNzU1AwMF2QEwogGKGCz1GDz1APUA9AD0AhqXXU3xBlTWxjJlhXxR7nlJZNL5hDGwLbh+5w==',
        ),
      );

      // Act
      bool actualSimpleBool = actualFountainDecoderPart.isSimple;

      // Assert
      expect(actualSimpleBool, true);
    });

    test('Should [return FALSE] if part contains [MORE THAN ONE index]', () {
      // Arrange
      FountainDecoderPart actualFountainDecoderPart = FountainDecoderPart(
        indexes: const <int>[2, 0, 1],
        fragment: base64Decode(
          '9BrFM2Nev7JuM6pdFIb8RVwQtxw1SwpbWQBiezI0cSQwLSslTjF7JTxYP0MtFg19aSgUcjUiNzJhODstZDNgeDciejUyK3VpJjU7ZTwnRyY8agw5dmETBx8by0IrrU63XTHxUTz/U6lI4Rr9UUfZAQLnBl/WjVlBu3IS9nNObZP8jif1Drktmw==',
        ),
      );

      // Act
      bool actualSimpleBool = actualFountainDecoderPart.isSimple;

      // Assert
      expect(actualSimpleBool, false);
    });
  });
}
