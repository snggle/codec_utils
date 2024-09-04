import 'package:codec_utils/src/codecs/fountain/encoder/fountain_encoder.dart';
import 'package:codec_utils/src/codecs/fountain/encoder/fountain_encoder_part.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of FountainEncoder process', () {
    group('Tests for single-part fountain', () {
      FountainEncoder actualFountainEncoder = FountainEncoder(
        message: List<int>.generate(30, (int i) => i),
        minFragmentLength: 5,
        maxFragmentLength: 300,
        firstSequenceNumber: 0,
      );

      test('Should [return initial values] if no parts received', () {
        // Assert
        expect(actualFountainEncoder.isComplete, false);
        expect(actualFountainEncoder.isSinglePart, true);
        expect(actualFountainEncoder.fragmentsCount, 1);
      });

      test('Should [return FountainEncoderPart]', () {
        // Act
        FountainEncoderPart actualFountainEncoderPart = actualFountainEncoder.nextPart();

        // Assert
        FountainEncoderPart expectedFountainEncoderPart = const FountainEncoderPart(
          sequenceNumber: 1,
          sequenceLength: 1,
          messageLength: 30,
          checksum: 3311820632,
          fragment: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29],
        );

        expect(actualFountainEncoderPart, expectedFountainEncoderPart);
        expect(actualFountainEncoder.isComplete, true);
        expect(actualFountainEncoder.isSinglePart, true);
        expect(actualFountainEncoder.fragmentsCount, 1);
      });
    });

    group('Tests for multi-part fountain', () {
      FountainEncoder actualFountainEncoder = FountainEncoder(
        message: List<int>.generate(30, (int i) => i),
        minFragmentLength: 5,
        maxFragmentLength: 10,
        firstSequenceNumber: 0,
      );

      test('Should [return initial values] if no parts received', () {
        // Assert
        expect(actualFountainEncoder.isComplete, false);
        expect(actualFountainEncoder.isSinglePart, false);
        expect(actualFountainEncoder.fragmentsCount, 3);
      });

      test('Should [return 1st FountainEncoderPart]', () {
        // Act
        FountainEncoderPart actualFountainEncoderPart = actualFountainEncoder.nextPart();

        // Assert
        FountainEncoderPart expectedFountainEncoderPart = const FountainEncoderPart(
          sequenceNumber: 1,
          sequenceLength: 3,
          messageLength: 30,
          checksum: 3311820632,
          fragment: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
        );

        expect(actualFountainEncoderPart, expectedFountainEncoderPart);
        expect(actualFountainEncoder.isComplete, false);
        expect(actualFountainEncoder.isSinglePart, false);
        expect(actualFountainEncoder.fragmentsCount, 3);
      });

      test('Should [return 2nd FountainEncoderPart]', () {
        // Act
        FountainEncoderPart actualFountainEncoderPart = actualFountainEncoder.nextPart();

        // Assert
        FountainEncoderPart expectedFountainEncoderPart = const FountainEncoderPart(
          sequenceNumber: 2,
          sequenceLength: 3,
          messageLength: 30,
          checksum: 3311820632,
          fragment: <int>[10, 11, 12, 13, 14, 15, 16, 17, 18, 19],
        );

        expect(actualFountainEncoderPart, expectedFountainEncoderPart);
        expect(actualFountainEncoder.isComplete, false);
        expect(actualFountainEncoder.isSinglePart, false);
        expect(actualFountainEncoder.fragmentsCount, 3);
      });

      test('Should [return 3rd FountainEncoderPart]', () {
        // Act
        FountainEncoderPart actualFountainEncoderPart = actualFountainEncoder.nextPart();

        // Assert
        FountainEncoderPart expectedFountainEncoderPart = const FountainEncoderPart(
          sequenceNumber: 3,
          sequenceLength: 3,
          messageLength: 30,
          checksum: 3311820632,
          fragment: <int>[20, 21, 22, 23, 24, 25, 26, 27, 28, 29],
        );

        expect(actualFountainEncoderPart, expectedFountainEncoderPart);
        expect(actualFountainEncoder.isComplete, true);
        expect(actualFountainEncoder.isSinglePart, false);
        expect(actualFountainEncoder.fragmentsCount, 3);
      });
    });
  });
}
