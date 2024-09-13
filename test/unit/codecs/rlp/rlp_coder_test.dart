import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of RLPCoder.encode()', () {
    test('Should [return bytes] representing RLP-encoded bytes', () {
      // Arrange
      RLPList actualRLPList = RLPList(<IRLPElement>[
        RLPBytes(Uint8List.fromList(<int>[1, 2, 3, 4, 5])),
        RLPBytes(Uint8List.fromList(<int>[7, 91, 205, 21])),
        RLPList(<IRLPElement>[
          RLPBytes(Uint8List.fromList(<int>[5, 4, 3, 2, 1])),
          RLPBytes(Uint8List.fromList(<int>[21, 205, 91, 7])),
        ]),
      ]);

      // Act
      Uint8List actualRLPBytes = RLPCodec.encode(actualRLPList);

      // Assert
      Uint8List expectedRLPBytes = base64Decode('14UBAgMEBYQHW80Vy4UFBAMCAYQVzVsH');

      expect(actualRLPBytes, expectedRLPBytes);
    });
  });

  group('Tests of RLPCoder.decode()', () {
    test('Should [return RLPList] from given RLP-encoded bytes', () {
      // Arrange
      Uint8List actualRLPBytes = base64Decode('14UBAgMEBYQHW80Vy4UFBAMCAYQVzVsH');

      // Act
      IRLPElement actualRLPElement = RLPCodec.decode(actualRLPBytes);

      // Assert
      IRLPElement expectedRLPElement = RLPList(<IRLPElement>[
        RLPBytes(Uint8List.fromList(<int>[1, 2, 3, 4, 5])),
        RLPBytes(Uint8List.fromList(<int>[7, 91, 205, 21])),
        RLPList(<IRLPElement>[
          RLPBytes(Uint8List.fromList(<int>[5, 4, 3, 2, 1])),
          RLPBytes(Uint8List.fromList(<int>[21, 205, 91, 7])),
        ]),
      ]);

      expect(actualRLPElement, expectedRLPElement);
    });

    test('Should [return RLPBytes] from given RLP-encoded bytes', () {
      // Arrange
      Uint8List actualRLPBytes = base64Decode('hQECAwQF');

      // Act
      IRLPElement actualRLPElement = RLPCodec.decode(actualRLPBytes);

      // Assert
      IRLPElement expectedRLPElement = RLPBytes(Uint8List.fromList(<int>[1, 2, 3, 4, 5]));

      expect(actualRLPElement, expectedRLPElement);
    });
  });
}
