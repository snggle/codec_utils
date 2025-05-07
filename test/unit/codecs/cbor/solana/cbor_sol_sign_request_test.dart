import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/src/codecs/cbor/cbor_special_tag.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/cbor_crypto_keypath.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/metadata/cbor_path_component.dart';
import 'package:codec_utils/src/codecs/cbor/solana/cbor_sol_sign_request.dart';
import 'package:codec_utils/src/codecs/cbor/solana/metadata/cbor_sol_sign_data_type.dart';
import 'package:codec_utils/src/codecs/hex/hex_codec.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of CborSolSignRequest.fromSerializedCbor()', () {
    test('Should [return CborSolSignRequest] from serialized CBOR bytes (WITH tag)', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
          'd9044da501d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d02589601000103c8d842a2f17fd7aab608ce2ea535a6e958dffa20caf669b347b911c4171965530f957620b228bae2b94c82ddd4c093983a67365555b737ec7ddc1117e61c72e0000000000000000000000000000000000000000000000000000000000000000010295cc2f1f39f3604718496ea00676d6a72ec66ad09d926e3ece34f565f18d201020200010c0200000000e1f5050000000003d90130a20188182cf51901f5f500f500f5021a075bcd150568736f6c666c6172650601');

      // Act
      CborSolSignRequest actualCborSolSignRequest = CborSolSignRequest.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      CborSolSignRequest expectedCborSolSignRequest = CborSolSignRequest(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signData: base64Decode(
          'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA',
        ),
        derivationPath: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 501, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: true),
          ],
          sourceFingerprint: 123456789,
        ),
        origin: 'solflare',
        dataType: CborSolSignDataType.transaction,
      );

      expect(actualCborSolSignRequest, expectedCborSolSignRequest);
    });

    test('Should [return CborSolSignRequest] from serialized CBOR bytes (WITHOUT tag)', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
          'a501d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d02589601000103c8d842a2f17fd7aab608ce2ea535a6e958dffa20caf669b347b911c4171965530f957620b228bae2b94c82ddd4c093983a67365555b737ec7ddc1117e61c72e0000000000000000000000000000000000000000000000000000000000000000010295cc2f1f39f3604718496ea00676d6a72ec66ad09d926e3ece34f565f18d201020200010c0200000000e1f5050000000003d90130a20188182cf51901f5f500f500f5021a075bcd150568736f6c666c6172650601');

      // Act
      CborSolSignRequest actualCborSolSignRequest = CborSolSignRequest.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      CborSolSignRequest expectedCborSolSignRequest = CborSolSignRequest(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signData: base64Decode(
          'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA',
        ),
        derivationPath: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 501, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: true),
          ],
          sourceFingerprint: 123456789,
        ),
        origin: 'solflare',
        dataType: CborSolSignDataType.transaction,
      );

      expect(actualCborSolSignRequest, expectedCborSolSignRequest);
    });
  });

  group('Tests of CborSolSignRequest.fromCborMap()', () {
    test('Should [return CborSolSignRequest] from CborMap (WITH tag)', () {
      // Arrange
      CborMap actualCborMap = CborMap(
        <CborValue, CborValue>{
          const CborSmallInt(1): CborBytes(base64Decode('mx3rTTt9S62b3SsNez3LbQ=='), tags: <int>[CborSpecialTag.uuid.tag]),
          const CborSmallInt(2): CborBytes(base64Decode(
            'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA',
          )),
          const CborSmallInt(3): const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 501, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: true),
            ],
            sourceFingerprint: 123456789,
          ).toCborMap(includeTagBool: true),
          const CborSmallInt(5): CborString('solflare'),
          const CborSmallInt(6): CborSmallInt(CborSolSignDataType.transaction.cborIndex),
        },
        tags: <int>[CborSpecialTag.solSignRequest.tag],
      );

      // Act
      CborSolSignRequest actualCborSolSignRequest = CborSolSignRequest.fromCborMap(actualCborMap);

      // Assert
      CborSolSignRequest expectedCborSolSignRequest = CborSolSignRequest(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signData: base64Decode(
            'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA'),
        derivationPath: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 501, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: true),
          ],
          sourceFingerprint: 123456789,
        ),
        origin: 'solflare',
        dataType: CborSolSignDataType.transaction,
      );

      expect(actualCborSolSignRequest, expectedCborSolSignRequest);
    });

    test('Should [return CborSolSignRequest] from CborMap (WITHOUT tag)', () {
      // Arrange
      CborMap actualCborMap = CborMap(
        <CborValue, CborValue>{
          const CborSmallInt(1): CborBytes(base64Decode('mx3rTTt9S62b3SsNez3LbQ=='), tags: <int>[CborSpecialTag.uuid.tag]),
          const CborSmallInt(2): CborBytes(base64Decode(
            'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA',
          )),
          const CborSmallInt(3): const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 501, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: true),
            ],
            sourceFingerprint: 123456789,
          ).toCborMap(includeTagBool: true),
          const CborSmallInt(5): CborString('solflare'),
          const CborSmallInt(6): CborSmallInt(CborSolSignDataType.transaction.cborIndex),
        },
      );

      // Act
      CborSolSignRequest actualCborSolSignRequest = CborSolSignRequest.fromCborMap(actualCborMap);

      // Assert
      CborSolSignRequest expectedCborSolSignRequest = CborSolSignRequest(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signData: base64Decode(
            'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA'),
        derivationPath: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 501, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: true),
          ],
          sourceFingerprint: 123456789,
        ),
        origin: 'solflare',
        dataType: CborSolSignDataType.transaction,
      );

      expect(actualCborSolSignRequest, expectedCborSolSignRequest);
    });
  });

  group('Tests of CborSolSignRequest.toSerializedCbor()', () {
    test('Should [return serialized CBOR bytes] from CborSolSignRequest (WITH tag)', () {
      // Arrange
      CborSolSignRequest actualCborSolSignRequest = CborSolSignRequest(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signData: base64Decode(
          'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA',
        ),
        derivationPath: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 501, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: true),
          ],
          sourceFingerprint: 123456789,
        ),
        origin: 'solflare',
        dataType: CborSolSignDataType.transaction,
      );

      // Act
      Uint8List actualSerializedCborBytes = actualCborSolSignRequest.toSerializedCbor(includeTagBool: true);

      // Assert
      Uint8List expectedSerializedCborBytes = HexCodec.decode(
        'd9044da501d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d02589601000103c8d842a2f17fd7aab608ce2ea535a6e958dffa20caf669b347b911c4171965530f957620b228bae2b94c82ddd4c093983a67365555b737ec7ddc1117e61c72e0000000000000000000000000000000000000000000000000000000000000000010295cc2f1f39f3604718496ea00676d6a72ec66ad09d926e3ece34f565f18d201020200010c0200000000e1f5050000000003d90130a20188182cf51901f5f500f500f5021a075bcd150568736f6c666c6172650601',
      );

      expect(actualSerializedCborBytes, expectedSerializedCborBytes);
    });

    test('Should [return serialized CBOR bytes] from CborSolSignRequest (WITHOUT tag)', () {
      // Arrange
      CborSolSignRequest actualCborSolSignRequest = CborSolSignRequest(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signData: base64Decode(
          'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA',
        ),
        derivationPath: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 501, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: true),
          ],
          sourceFingerprint: 123456789,
        ),
        origin: 'solflare',
        dataType: CborSolSignDataType.transaction,
      );

      // Act
      Uint8List actualSerializedCborBytes = actualCborSolSignRequest.toSerializedCbor(includeTagBool: false);

      // Assert
      Uint8List expectedSerializedCborBytes = HexCodec.decode(
        'a501d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d02589601000103c8d842a2f17fd7aab608ce2ea535a6e958dffa20caf669b347b911c4171965530f957620b228bae2b94c82ddd4c093983a67365555b737ec7ddc1117e61c72e0000000000000000000000000000000000000000000000000000000000000000010295cc2f1f39f3604718496ea00676d6a72ec66ad09d926e3ece34f565f18d201020200010c0200000000e1f5050000000003d90130a20188182cf51901f5f500f500f5021a075bcd150568736f6c666c6172650601',
      );

      expect(actualSerializedCborBytes, expectedSerializedCborBytes);
    });
  });

  group('Tests of CborSolSignRequest.toCborMap()', () {
    test('Should [return CborMap] from CborSolSignRequest (WITH tag)', () {
      // Arrange
      CborSolSignRequest actualCborSolSignRequest = CborSolSignRequest(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signData: base64Decode(
            'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA'),
        derivationPath: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 501, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: true),
          ],
          sourceFingerprint: 123456789,
        ),
        origin: 'solflare',
        dataType: CborSolSignDataType.transaction,
      );

      // Act
      CborMap actualCborMap = actualCborSolSignRequest.toCborMap(includeTagBool: true);

      // Assert
      CborMap expectedCborMap = CborMap(
        <CborValue, CborValue>{
          const CborSmallInt(1): CborBytes(base64Decode('mx3rTTt9S62b3SsNez3LbQ=='), tags: <int>[CborSpecialTag.uuid.tag]),
          const CborSmallInt(2): CborBytes(base64Decode(
            'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA',
          )),
          const CborSmallInt(3): const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 501, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: true),
            ],
            sourceFingerprint: 123456789,
          ).toCborMap(includeTagBool: true),
          const CborSmallInt(5): CborString('solflare'),
          const CborSmallInt(6): CborSmallInt(CborSolSignDataType.transaction.cborIndex),
        },
      );

      expect(actualCborMap, expectedCborMap);
    });

    test('Should [return CborMap] from CborSolSignRequest (WITHOUT tag)', () {
      // Arrange
      CborSolSignRequest actualCborSolSignRequest = CborSolSignRequest(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signData: base64Decode(
            'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA'),
        derivationPath: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 501, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: true),
          ],
          sourceFingerprint: 123456789,
        ),
        origin: 'solflare',
        dataType: CborSolSignDataType.transaction,
      );

      // Act
      CborMap actualCborMap = actualCborSolSignRequest.toCborMap(includeTagBool: true);

      // Assert
      CborMap expectedCborMap = CborMap(
        <CborValue, CborValue>{
          const CborSmallInt(1): CborBytes(base64Decode('mx3rTTt9S62b3SsNez3LbQ=='), tags: <int>[CborSpecialTag.uuid.tag]),
          const CborSmallInt(2): CborBytes(base64Decode(
            'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA',
          )),
          const CborSmallInt(3): const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 501, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: true),
            ],
            sourceFingerprint: 123456789,
          ).toCborMap(includeTagBool: true),
          const CborSmallInt(5): CborString('solflare'),
          const CborSmallInt(6): CborSmallInt(CborSolSignDataType.transaction.cborIndex),
        },
      );

      expect(actualCborMap, expectedCborMap);
    });
  });

  group('CborSolSignRequest.getCborSpecialTag()', () {
    test('Should [return CborSpecialTag.solSignRequest] from CborSolSignRequest', () {
      // Arrange
      CborSolSignRequest actualCborSolSignRequest = CborSolSignRequest(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signData: base64Decode(
            'AQABA8jYQqLxf9eqtgjOLqU1pulY3/ogyvZps0e5EcQXGWVTD5V2ILIouuK5TILd1MCTmDpnNlVVtzfsfdwRF+YccuAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABApXMLx8582BHGEluoAZ21qcuxmrQnZJuPs409WXxjSAQICAAEMAgAAAADh9QUAAAAA'),
        derivationPath: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 501, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: true),
          ],
          sourceFingerprint: 123456789,
        ),
        origin: 'solflare',
        dataType: CborSolSignDataType.transaction,
      );

      // Act
      CborSpecialTag actualCborSpecialTag = actualCborSolSignRequest.getCborSpecialTag();

      // Assert
      CborSpecialTag expectedCborSpecialTag = CborSpecialTag.solSignRequest;

      expect(actualCborSpecialTag, expectedCborSpecialTag);
    });
  });
}
