import 'package:codec_utils/src/utils/xoshiro.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of Xoshiro.nextBool()', () {
    Xoshiro actualXoshiro = Xoshiro(<int>[72, 0, 0, 2, 161, 142, 51, 6]);

    test('Should [return TRUE] (1st round)', () {
      // Act
      bool actualBool = actualXoshiro.nextBool();

      // Assert
      expect(actualBool, true);
    });

    test('Should [return FALSE] (2nd round)', () {
      // Act
      bool actualBool = actualXoshiro.nextBool();

      // Assert
      expect(actualBool, false);
    });

    test('Should [return FALSE] (3rd round)', () {
      // Act
      bool actualBool = actualXoshiro.nextBool();

      // Assert
      expect(actualBool, false);
    });
  });

  group('Tests of Xoshiro.nextDouble()', () {
    Xoshiro actualXoshiro = Xoshiro(<int>[72, 0, 0, 2, 161, 142, 51, 6]);

    test('Should [return 0.4670721227028558>] (1st round)', () {
      // Act
      double actualDouble = actualXoshiro.nextDouble();

      // Assert
      expect(actualDouble, 0.4670721227028558);
    });

    test('Should [return 0.6745635485744226] (2nd round)', () {
      // Act
      double actualDouble = actualXoshiro.nextDouble();

      // Assert
      expect(actualDouble, 0.6745635485744226);
    });

    test('Should [return 0.5859201782428961] (3rd round)', () {
      // Act
      double actualDouble = actualXoshiro.nextDouble();

      // Assert
      expect(actualDouble, 0.5859201782428961);
    });
  });

  group('Tests of Xoshiro.nextInt()', () {
    Xoshiro actualXoshiro = Xoshiro(<int>[72, 0, 0, 2, 161, 142, 51, 6]);

    test('Should [return 0] (1st round)', () {
      // Act
      int actualDouble = actualXoshiro.nextInt(1);

      // Assert
      expect(actualDouble, 0);
    });

    test('Should [return 1] (2nd round)', () {
      // Act
      int actualDouble = actualXoshiro.nextInt(1);

      // Assert
      expect(actualDouble, 1);
    });

    test('Should [return 1] (3rd round)', () {
      // Act
      int actualDouble = actualXoshiro.nextInt(1);

      // Assert
      expect(actualDouble, 1);
    });
  });
}
