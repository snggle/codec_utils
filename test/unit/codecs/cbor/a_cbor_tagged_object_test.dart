import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/hex/hex_codec.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of ACborTaggedObject.fromSerializedCbor()', () {
    test('Should [return CborCryptoCoinInfo] from serialized CBOR bytes', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode('d90131a201183c0201');

      // Act
      ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      ACborTaggedObject expectedCborTaggedObject = const CborCryptoCoinInfo(type: 60, network: 1);

      expect(actualCborTaggedObject, expectedCborTaggedObject);
    });

    test('Should [return CborCryptoHDKey] from serialized CBOR bytes', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
        'd9012fa503582103ac4a4471ddb01e1d81295172066f9b3d38665a380472befa3375d66054093966045820e60be89322d1022a4408b813e409e43cb5fab61444a3e136eede70501a676bdc06d90130a20186182cf5183cf500f5021a99fa638e081a30346662096954455354204e414d45',
      );

      // Act
      ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      ACborTaggedObject expectedCborTaggedObject = CborCryptoHDKey(
        isMaster: false,
        isPrivate: false,
        keyData: base64Decode('A6xKRHHdsB4dgSlRcgZvmz04Zlo4BHK++jN11mBUCTlm'),
        chainCode: base64Decode('5gvokyLRAipECLgT5AnkPLX6thREo+E27t5wUBpna9w='),
        origin: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 60, hardened: true),
            CborPathComponent(index: 0, hardened: true)
          ],
          sourceFingerprint: 2583323534,
        ),
        parentFingerprint: 808740450,
        name: 'TEST NAME',
      );

      expect(actualCborTaggedObject, expectedCborTaggedObject);
    });

    test('Should [return CborCryptoKeypath] from serialized CBOR bytes', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode('d90130a2018a182cf5183cf500f500f400f4021a975d4df1');

      // Act
      ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      ACborTaggedObject expectedCborTaggedObject = const CborCryptoKeypath(
        components: <CborPathComponent>[
          CborPathComponent(index: 44, hardened: true),
          CborPathComponent(index: 60, hardened: true),
          CborPathComponent(index: 0, hardened: true),
          CborPathComponent(index: 0, hardened: false),
          CborPathComponent(index: 0, hardened: false)
        ],
        sourceFingerprint: 2539474417,
      );

      expect(actualCborTaggedObject, expectedCborTaggedObject);
    });

    test('Should [return CborEthSignRequest] from serialized CBOR bytes', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
        'd90191a501d8255051fdaebda49044ec8b0c45368acee5bf0259014e57656c636f6d6520746f204f70656e536561210a0a436c69636b20746f207369676e20696e20616e642061636365707420746865204f70656e536561205465726d73206f662053657276696365202868747470733a2f2f6f70656e7365612e696f2f746f732920616e64205072697661637920506f6c696379202868747470733a2f2f6f70656e7365612e696f2f70726976616379292e0a0a5468697320726571756573742077696c6c206e6f742074726967676572206120626c6f636b636861696e207472616e73616374696f6e206f7220636f737420616e792067617320666565732e0a0a57616c6c657420616464726573733a0a3078353362663061313837353438373361383130323632356438323235616636613135613433343233630a0a4e6f6e63653a0a31643864326463312d306237632d343736322d613532302d613438356165323631373139030305d90130a2018a182cf5183cf500f500f400f4021a70268fc9065453bf0a18754873a8102625d8225af6a15a43423c',
      );

      // Act
      ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      ACborTaggedObject expectedCborTaggedObject = CborEthSignRequest(
        requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
        signData: base64Decode(
          'V2VsY29tZSB0byBPcGVuU2VhIQoKQ2xpY2sgdG8gc2lnbiBpbiBhbmQgYWNjZXB0IHRoZSBPcGVuU2VhIFRlcm1zIG9mIFNlcnZpY2UgKGh0dHBzOi8vb3BlbnNlYS5pby90b3MpIGFuZCBQcml2YWN5IFBvbGljeSAoaHR0cHM6Ly9vcGVuc2VhLmlvL3ByaXZhY3kpLgoKVGhpcyByZXF1ZXN0IHdpbGwgbm90IHRyaWdnZXIgYSBibG9ja2NoYWluIHRyYW5zYWN0aW9uIG9yIGNvc3QgYW55IGdhcyBmZWVzLgoKV2FsbGV0IGFkZHJlc3M6CjB4NTNiZjBhMTg3NTQ4NzNhODEwMjYyNWQ4MjI1YWY2YTE1YTQzNDIzYwoKTm9uY2U6CjFkOGQyZGMxLTBiN2MtNDc2Mi1hNTIwLWE0ODVhZTI2MTcxOQ==',
        ),
        dataType: CborEthSignDataType.rawBytes,
        derivationPath: const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 60, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: false),
            CborPathComponent(index: 0, hardened: false)
          ],
          sourceFingerprint: 1881575369,
        ),
        address: '0x53bf0a18754873a8102625d8225af6a15a43423c',
      );

      expect(actualCborTaggedObject, expectedCborTaggedObject);
    });

    test('Should [return CborEthSignature] from serialized CBOR bytes', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
        'd90192a201d8255086bf97f8219d499e9ab0c2a4af350683025841f486c6ebd6f3e7bb1ac1d176f078516a191fd610866c2dca0f2f8655d8ce5a6f52dd2bc8787eb90ebd3caa2b28b42f6b0fcdb594d84af1018ec58568ebb2e84000',
      );

      // Act
      ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      ACborTaggedObject expectedCborTaggedObject = CborEthSignature(
        requestId: base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='),
        signature: base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA='),
      );

      expect(actualCborTaggedObject, expectedCborTaggedObject);
    });
  });

  group('Tests of ACborTaggedObject.fromCborMap()', () {
    group('Tests of ACborTaggedObject.fromCborMap() with tagged CBOR map', () {
      test('Should [return CborCryptoCoinInfo] from CborMap', () {
        // Arrange
        CborMap actualCborMap = CborMap(<CborSmallInt, CborValue>{
          const CborSmallInt(1): const CborSmallInt(60),
          const CborSmallInt(2): const CborSmallInt(1),
        }, tags: <int>[
          CborSpecialTag.cryptoCoinInfo.tag
        ]);

        // Act
        ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromCborMap(actualCborMap);

        // Assert
        ACborTaggedObject expectedCborTaggedObject = const CborCryptoCoinInfo(type: 60, network: 1);

        expect(actualCborTaggedObject, expectedCborTaggedObject);
      });

      test('Should [return CborCryptoHDKey] from CborMap', () {
        // Arrange
        CborMap actualCborMap = CborMap(
          <CborSmallInt, CborValue>{
            const CborSmallInt(3): CborBytes(Uint8List.fromList(base64Decode('A6xKRHHdsB4dgSlRcgZvmz04Zlo4BHK++jN11mBUCTlm'))),
            const CborSmallInt(4): CborBytes(Uint8List.fromList(base64Decode('5gvokyLRAipECLgT5AnkPLX6thREo+E27t5wUBpna9w='))),
            const CborSmallInt(6): CborMap(
              <CborSmallInt, CborValue>{
                const CborSmallInt(1): CborList(<CborValue>[
                  const CborSmallInt(44),
                  const CborBool(true),
                  const CborSmallInt(60),
                  const CborBool(true),
                  const CborSmallInt(0),
                  const CborBool(true),
                ]),
                const CborSmallInt(2): CborInt(BigInt.from(2583323534)),
              },
              tags: <int>[CborSpecialTag.cryptoKeypath.tag],
            ),
            const CborSmallInt(8): const CborSmallInt(808740450),
            const CborSmallInt(9): CborString('TEST NAME'),
          },
          tags: <int>[CborSpecialTag.cryptoHDKey.tag],
        );

        // Act
        ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromCborMap(actualCborMap);

        // Assert
        ACborTaggedObject expectedCborTaggedObject = CborCryptoHDKey(
          isMaster: false,
          isPrivate: false,
          keyData: base64Decode('A6xKRHHdsB4dgSlRcgZvmz04Zlo4BHK++jN11mBUCTlm'),
          chainCode: base64Decode('5gvokyLRAipECLgT5AnkPLX6thREo+E27t5wUBpna9w='),
          origin: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 60, hardened: true),
              CborPathComponent(index: 0, hardened: true)
            ],
            sourceFingerprint: 2583323534,
          ),
          parentFingerprint: 808740450,
          name: 'TEST NAME',
        );

        expect(actualCborTaggedObject, expectedCborTaggedObject);
      });

      test('Should [return CborCryptoKeypath] from CborMap', () {
        // Arrange
        CborMap actualCborMap = CborMap(
          <CborSmallInt, CborValue>{
            const CborSmallInt(1): CborList(<CborValue>[
              const CborSmallInt(44),
              const CborBool(true),
              const CborSmallInt(60),
              const CborBool(true),
              const CborSmallInt(0),
              const CborBool(true),
              const CborSmallInt(0),
              const CborBool(false),
              const CborSmallInt(0),
              const CborBool(false),
            ]),
            const CborSmallInt(2): CborInt(BigInt.from(2539474417)),
          },
          tags: <int>[CborSpecialTag.cryptoKeypath.tag],
        );

        // Act
        ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromCborMap(actualCborMap);

        // Assert
        ACborTaggedObject expectedCborTaggedObject = const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 60, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: false),
            CborPathComponent(index: 0, hardened: false)
          ],
          sourceFingerprint: 2539474417,
        );

        expect(actualCborTaggedObject, expectedCborTaggedObject);
      });

      test('Should [return CborEthSignRequest] from CborMap', () {
        // Arrange
        CborMap actualCborMap = CborMap(
          <CborSmallInt, CborValue>{
            const CborSmallInt(1): CborBytes(base64Decode('Uf2uvaSQROyLDEU2is7lvw=='), tags: <int>[CborSpecialTag.uuid.tag]),
            const CborSmallInt(2): CborBytes(base64Decode(
              'V2VsY29tZSB0byBPcGVuU2VhIQoKQ2xpY2sgdG8gc2lnbiBpbiBhbmQgYWNjZXB0IHRoZSBPcGVuU2VhIFRlcm1zIG9mIFNlcnZpY2UgKGh0dHBzOi8vb3BlbnNlYS5pby90b3MpIGFuZCBQcml2YWN5IFBvbGljeSAoaHR0cHM6Ly9vcGVuc2VhLmlvL3ByaXZhY3kpLgoKVGhpcyByZXF1ZXN0IHdpbGwgbm90IHRyaWdnZXIgYSBibG9ja2NoYWluIHRyYW5zYWN0aW9uIG9yIGNvc3QgYW55IGdhcyBmZWVzLgoKV2FsbGV0IGFkZHJlc3M6CjB4NTNiZjBhMTg3NTQ4NzNhODEwMjYyNWQ4MjI1YWY2YTE1YTQzNDIzYwoKTm9uY2U6CjFkOGQyZGMxLTBiN2MtNDc2Mi1hNTIwLWE0ODVhZTI2MTcxOQ==',
            )),
            const CborSmallInt(3): const CborSmallInt(3),
            const CborSmallInt(5): CborMap(
              <CborSmallInt, CborValue>{
                const CborSmallInt(1): CborList(<CborValue>[
                  const CborSmallInt(44),
                  const CborBool(true),
                  const CborSmallInt(60),
                  const CborBool(true),
                  const CborSmallInt(0),
                  const CborBool(true),
                  const CborSmallInt(0),
                  const CborBool(false),
                  const CborSmallInt(0),
                  const CborBool(false),
                ]),
                const CborSmallInt(2): CborInt(BigInt.from(1881575369)),
              },
              tags: <int>[CborSpecialTag.cryptoKeypath.tag],
            ),
            const CborSmallInt(6): CborBytes(HexCodec.decode('0x53bf0a18754873a8102625d8225af6a15a43423c')),
          },
          tags: <int>[CborSpecialTag.ethSignRequest.tag],
        );

        // Act
        ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromCborMap(actualCborMap);

        // Assert
        ACborTaggedObject expectedCborTaggedObject = CborEthSignRequest(
          requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
          signData: base64Decode(
            'V2VsY29tZSB0byBPcGVuU2VhIQoKQ2xpY2sgdG8gc2lnbiBpbiBhbmQgYWNjZXB0IHRoZSBPcGVuU2VhIFRlcm1zIG9mIFNlcnZpY2UgKGh0dHBzOi8vb3BlbnNlYS5pby90b3MpIGFuZCBQcml2YWN5IFBvbGljeSAoaHR0cHM6Ly9vcGVuc2VhLmlvL3ByaXZhY3kpLgoKVGhpcyByZXF1ZXN0IHdpbGwgbm90IHRyaWdnZXIgYSBibG9ja2NoYWluIHRyYW5zYWN0aW9uIG9yIGNvc3QgYW55IGdhcyBmZWVzLgoKV2FsbGV0IGFkZHJlc3M6CjB4NTNiZjBhMTg3NTQ4NzNhODEwMjYyNWQ4MjI1YWY2YTE1YTQzNDIzYwoKTm9uY2U6CjFkOGQyZGMxLTBiN2MtNDc2Mi1hNTIwLWE0ODVhZTI2MTcxOQ==',
          ),
          dataType: CborEthSignDataType.rawBytes,
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 60, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: false),
              CborPathComponent(index: 0, hardened: false)
            ],
            sourceFingerprint: 1881575369,
          ),
          address: '0x53bf0a18754873a8102625d8225af6a15a43423c',
        );

        expect(actualCborTaggedObject, expectedCborTaggedObject);
      });

      test('Should [return CborEthSignature] from CborMap', () {
        // Arrange
        CborMap actualCborMap = CborMap(
          <CborSmallInt, CborValue>{
            const CborSmallInt(1): CborBytes(base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='), tags: <int>[CborSpecialTag.uuid.tag]),
            const CborSmallInt(2): CborBytes(base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA=')),
          },
          tags: <int>[CborSpecialTag.ethSignature.tag],
        );

        // Act
        ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromCborMap(actualCborMap);

        // Assert
        ACborTaggedObject expectedCborTaggedObject = CborEthSignature(
          requestId: base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='),
          signature: base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA='),
        );

        expect(actualCborTaggedObject, expectedCborTaggedObject);
      });
    });

    group('Tests of ACborTaggedObject.fromCborMap() with custom tag', () {
      test('Should [return CborCryptoCoinInfo] from CborMap and custom tag', () {
        // Arrange
        CborMap actualCborMap = CborMap(<CborSmallInt, CborValue>{
          const CborSmallInt(1): const CborSmallInt(60),
          const CborSmallInt(2): const CborSmallInt(1),
        });

        // Act
        ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromCborMap(actualCborMap, customCborSpecialTag: CborSpecialTag.cryptoCoinInfo);

        // Assert
        ACborTaggedObject expectedCborTaggedObject = const CborCryptoCoinInfo(type: 60, network: 1);

        expect(actualCborTaggedObject, expectedCborTaggedObject);
      });

      test('Should [return CborCryptoHDKey] from CborMap and custom tag', () {
        // Arrange
        CborMap actualCborMap = CborMap(
          <CborSmallInt, CborValue>{
            const CborSmallInt(3): CborBytes(Uint8List.fromList(base64Decode('A6xKRHHdsB4dgSlRcgZvmz04Zlo4BHK++jN11mBUCTlm'))),
            const CborSmallInt(4): CborBytes(Uint8List.fromList(base64Decode('5gvokyLRAipECLgT5AnkPLX6thREo+E27t5wUBpna9w='))),
            const CborSmallInt(6): CborMap(
              <CborSmallInt, CborValue>{
                const CborSmallInt(1): CborList(<CborValue>[
                  const CborSmallInt(44),
                  const CborBool(true),
                  const CborSmallInt(60),
                  const CborBool(true),
                  const CborSmallInt(0),
                  const CborBool(true),
                ]),
                const CborSmallInt(2): CborInt(BigInt.from(2583323534)),
              },
              tags: <int>[CborSpecialTag.cryptoKeypath.tag],
            ),
            const CborSmallInt(8): const CborSmallInt(808740450),
            const CborSmallInt(9): CborString('TEST NAME'),
          },
        );

        // Act
        ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromCborMap(actualCborMap, customCborSpecialTag: CborSpecialTag.cryptoHDKey);

        // Assert
        ACborTaggedObject expectedCborTaggedObject = CborCryptoHDKey(
          isMaster: false,
          isPrivate: false,
          keyData: base64Decode('A6xKRHHdsB4dgSlRcgZvmz04Zlo4BHK++jN11mBUCTlm'),
          chainCode: base64Decode('5gvokyLRAipECLgT5AnkPLX6thREo+E27t5wUBpna9w='),
          origin: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 60, hardened: true),
              CborPathComponent(index: 0, hardened: true)
            ],
            sourceFingerprint: 2583323534,
          ),
          parentFingerprint: 808740450,
          name: 'TEST NAME',
        );

        expect(actualCborTaggedObject, expectedCborTaggedObject);
      });

      test('Should [return CborCryptoKeypath] from CborMap and custom tag', () {
        // Arrange
        CborMap actualCborMap = CborMap(
          <CborSmallInt, CborValue>{
            const CborSmallInt(1): CborList(<CborValue>[
              const CborSmallInt(44),
              const CborBool(true),
              const CborSmallInt(60),
              const CborBool(true),
              const CborSmallInt(0),
              const CborBool(true),
              const CborSmallInt(0),
              const CborBool(false),
              const CborSmallInt(0),
              const CborBool(false),
            ]),
            const CborSmallInt(2): CborInt(BigInt.from(2539474417)),
          },
        );

        // Act
        ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromCborMap(actualCborMap, customCborSpecialTag: CborSpecialTag.cryptoKeypath);

        // Assert
        ACborTaggedObject expectedCborTaggedObject = const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 60, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: false),
            CborPathComponent(index: 0, hardened: false)
          ],
          sourceFingerprint: 2539474417,
        );

        expect(actualCborTaggedObject, expectedCborTaggedObject);
      });

      test('Should [return CborEthSignRequest] from CborMap and custom tag', () {
        // Arrange
        CborMap actualCborMap = CborMap(
          <CborSmallInt, CborValue>{
            const CborSmallInt(1): CborBytes(base64Decode('Uf2uvaSQROyLDEU2is7lvw=='), tags: <int>[CborSpecialTag.uuid.tag]),
            const CborSmallInt(2): CborBytes(base64Decode(
              'V2VsY29tZSB0byBPcGVuU2VhIQoKQ2xpY2sgdG8gc2lnbiBpbiBhbmQgYWNjZXB0IHRoZSBPcGVuU2VhIFRlcm1zIG9mIFNlcnZpY2UgKGh0dHBzOi8vb3BlbnNlYS5pby90b3MpIGFuZCBQcml2YWN5IFBvbGljeSAoaHR0cHM6Ly9vcGVuc2VhLmlvL3ByaXZhY3kpLgoKVGhpcyByZXF1ZXN0IHdpbGwgbm90IHRyaWdnZXIgYSBibG9ja2NoYWluIHRyYW5zYWN0aW9uIG9yIGNvc3QgYW55IGdhcyBmZWVzLgoKV2FsbGV0IGFkZHJlc3M6CjB4NTNiZjBhMTg3NTQ4NzNhODEwMjYyNWQ4MjI1YWY2YTE1YTQzNDIzYwoKTm9uY2U6CjFkOGQyZGMxLTBiN2MtNDc2Mi1hNTIwLWE0ODVhZTI2MTcxOQ==',
            )),
            const CborSmallInt(3): const CborSmallInt(3),
            const CborSmallInt(5): CborMap(
              <CborSmallInt, CborValue>{
                const CborSmallInt(1): CborList(<CborValue>[
                  const CborSmallInt(44),
                  const CborBool(true),
                  const CborSmallInt(60),
                  const CborBool(true),
                  const CborSmallInt(0),
                  const CborBool(true),
                  const CborSmallInt(0),
                  const CborBool(false),
                  const CborSmallInt(0),
                  const CborBool(false),
                ]),
                const CborSmallInt(2): CborInt(BigInt.from(1881575369)),
              },
              tags: <int>[CborSpecialTag.cryptoKeypath.tag],
            ),
            const CborSmallInt(6): CborBytes(HexCodec.decode('0x53bf0a18754873a8102625d8225af6a15a43423c')),
          },
        );

        // Act
        ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromCborMap(actualCborMap, customCborSpecialTag: CborSpecialTag.ethSignRequest);

        // Assert
        ACborTaggedObject expectedCborTaggedObject = CborEthSignRequest(
          requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
          signData: base64Decode(
            'V2VsY29tZSB0byBPcGVuU2VhIQoKQ2xpY2sgdG8gc2lnbiBpbiBhbmQgYWNjZXB0IHRoZSBPcGVuU2VhIFRlcm1zIG9mIFNlcnZpY2UgKGh0dHBzOi8vb3BlbnNlYS5pby90b3MpIGFuZCBQcml2YWN5IFBvbGljeSAoaHR0cHM6Ly9vcGVuc2VhLmlvL3ByaXZhY3kpLgoKVGhpcyByZXF1ZXN0IHdpbGwgbm90IHRyaWdnZXIgYSBibG9ja2NoYWluIHRyYW5zYWN0aW9uIG9yIGNvc3QgYW55IGdhcyBmZWVzLgoKV2FsbGV0IGFkZHJlc3M6CjB4NTNiZjBhMTg3NTQ4NzNhODEwMjYyNWQ4MjI1YWY2YTE1YTQzNDIzYwoKTm9uY2U6CjFkOGQyZGMxLTBiN2MtNDc2Mi1hNTIwLWE0ODVhZTI2MTcxOQ==',
          ),
          dataType: CborEthSignDataType.rawBytes,
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 60, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: false),
              CborPathComponent(index: 0, hardened: false)
            ],
            sourceFingerprint: 1881575369,
          ),
          address: '0x53bf0a18754873a8102625d8225af6a15a43423c',
        );

        expect(actualCborTaggedObject, expectedCborTaggedObject);
      });

      test('Should [return CborEthSignature] from CborMap and custom tag', () {
        // Arrange
        CborMap actualCborMap = CborMap(
          <CborSmallInt, CborValue>{
            const CborSmallInt(1): CborBytes(base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='), tags: <int>[CborSpecialTag.uuid.tag]),
            const CborSmallInt(2): CborBytes(base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA=')),
          },
        );

        // Act
        ACborTaggedObject actualCborTaggedObject = ACborTaggedObject.fromCborMap(actualCborMap, customCborSpecialTag: CborSpecialTag.ethSignature);

        // Assert
        ACborTaggedObject expectedCborTaggedObject = CborEthSignature(
          requestId: base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='),
          signature: base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA='),
        );

        expect(actualCborTaggedObject, expectedCborTaggedObject);
      });
    });
  });
}
