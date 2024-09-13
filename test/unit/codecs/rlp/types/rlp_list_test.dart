import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  // Arrange
  RLPList actualRLPList = RLPList(<IRLPElement>[
    RLPBytes(Uint8List.fromList(<int>[1, 2, 3, 4, 5])),
    RLPBytes(Uint8List.fromList(<int>[7, 91, 205, 21])),
    RLPList(<IRLPElement>[
      RLPBytes(Uint8List.fromList(<int>[5, 4, 3, 2, 1])),
      RLPBytes(Uint8List.fromList(<int>[21, 205, 91, 7])),
    ]),
  ]);

  group('Tests of RLPList.encode()', () {
    test('Should [return bytes] representing RLP-encoded list', () {
      // Act
      Uint8List actualRLPBytes = actualRLPList.encode();

      // Assert
      Uint8List expectedRLPBytes = base64Decode('14UBAgMEBYQHW80Vy4UFBAMCAYQVzVsH');

      expect(actualRLPBytes, expectedRLPBytes);
    });
  });

  group('Tests of RLPList.getBigInt()', () {
    test('Should [return BigInt] from given index in RLPList', () {
      // Act
      BigInt actualBigInt = actualRLPList.getBigInt(1);

      // Assert
      BigInt expectedBigInt = BigInt.from(123456789);

      expect(actualBigInt, expectedBigInt);
    });
  });

  group('Tests of RLPList.getHex()', () {
    test('Should [return HEX] from given index in RLPList', () {
      // Act
      String actualHex = actualRLPList.getHex(1);

      // Assert
      String expectedHex = '0x075bcd15';

      expect(actualHex, expectedHex);
    });
  });

  group('Tests of RLPList.getRLPList()', () {
    test('Should [return RLPList] from given index in RLPList', () {
      // Act
      RLPList actualNestedRLPList = actualRLPList.getRLPList(2);

      // Assert
      RLPList expectedNestedRLPList = RLPList(<IRLPElement>[
        RLPBytes(Uint8List.fromList(<int>[5, 4, 3, 2, 1])),
        RLPBytes(Uint8List.fromList(<int>[21, 205, 91, 7])),
      ]);

      expect(actualNestedRLPList, expectedNestedRLPList);
    });
  });

  group('Tests of RLPList.getUint8List()', () {
    test('Should [return Uint8List] from given index in RLPList', () {
      // Act
      Uint8List actualUint8List = actualRLPList.getUint8List(0);

      // Assert
      Uint8List expectedUint8List = Uint8List.fromList(<int>[1, 2, 3, 4, 5]);

      expect(actualUint8List, expectedUint8List);
    });
  });

  group('Tests of RLPList.length getter', () {
    test('Should [return length] of RLPList', () {
      // Act
      int actualLength = actualRLPList.length;

      // Assert
      int expectedLength = 3;

      expect(actualLength, expectedLength);
    });
  });
}
