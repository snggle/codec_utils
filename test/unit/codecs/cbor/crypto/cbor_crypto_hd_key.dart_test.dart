import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/src/codecs/cbor/cbor_special_tag.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/cbor_crypto_hd_key.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/cbor_crypto_keypath.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/metadata/cbor_path_component.dart';
import 'package:codec_utils/src/codecs/hex/hex_codec.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of CborCryptoHDKey.fromSerializedCbor()', () {
    test('Should [return CborCryptoHDKey] from serialized CBOR bytes (WITH tag)', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
        'd9012fa503582103ac4a4471ddb01e1d81295172066f9b3d38665a380472befa3375d66054093966045820e60be89322d1022a4408b813e409e43cb5fab61444a3e136eede70501a676bdc06d90130a20186182cf5183cf500f5021a99fa638e081a30346662096954455354204e414d45',
      );

      // Act
      CborCryptoHDKey actualCborCryptoHDKey = CborCryptoHDKey.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      CborCryptoHDKey expectedCborCryptoHDKey = CborCryptoHDKey(
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

      expect(actualCborCryptoHDKey, expectedCborCryptoHDKey);
    });

    test('Should [return CborCryptoHDKey] from serialized CBOR bytes (WITHOUT tag)', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
        'a503582103ac4a4471ddb01e1d81295172066f9b3d38665a380472befa3375d66054093966045820e60be89322d1022a4408b813e409e43cb5fab61444a3e136eede70501a676bdc06d90130a20186182cf5183cf500f5021a99fa638e081a30346662096954455354204e414d45',
      );

      // Act
      CborCryptoHDKey actualCborCryptoHDKey = CborCryptoHDKey.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      CborCryptoHDKey expectedCborCryptoHDKey = CborCryptoHDKey(
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

      expect(actualCborCryptoHDKey, expectedCborCryptoHDKey);
    });
  });

  group('Tests of CborCryptoHDKey.fromCborMap()', () {
    test('Should [return CborCryptoHDKey] from CborMap (WITH tag)', () {
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
      CborCryptoHDKey actualCborCryptoHDKey = CborCryptoHDKey.fromCborMap(actualCborMap);

      // Assert
      CborCryptoHDKey expectedCborCryptoHDKey = CborCryptoHDKey(
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

      expect(actualCborCryptoHDKey, expectedCborCryptoHDKey);
    });

    test('Should [return CborCryptoHDKey] from CborMap (WITHOUT tag)', () {
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
        tags: <int>[],
      );

      // Act
      CborCryptoHDKey actualCborCryptoHDKey = CborCryptoHDKey.fromCborMap(actualCborMap);

      // Assert
      CborCryptoHDKey expectedCborCryptoHDKey = CborCryptoHDKey(
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

      expect(actualCborCryptoHDKey, expectedCborCryptoHDKey);
    });
  });

  group('Tests of CborCryptoHDKey.toSerializedCbor()', () {
    test('Should [return serialized CBOR bytes] from CborCryptoHDKey (WITH tag)', () {
      // Arrange
      CborCryptoHDKey actualCborCryptoHDKey = CborCryptoHDKey(
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

      // Act
      Uint8List actualSerializedCborBytes = actualCborCryptoHDKey.toSerializedCbor(includeTagBool: true);

      // Assert
      Uint8List expectedSerializedCborBytes = HexCodec.decode(
        'd9012fa503582103ac4a4471ddb01e1d81295172066f9b3d38665a380472befa3375d66054093966045820e60be89322d1022a4408b813e409e43cb5fab61444a3e136eede70501a676bdc06d90130a20186182cf5183cf500f5021a99fa638e081a30346662096954455354204e414d45',
      );

      expect(actualSerializedCborBytes, expectedSerializedCborBytes);
    });

    test('Should [return serialized CBOR bytes] from CborCryptoHDKey (WITHOUT tag)', () {
      // Arrange
      CborCryptoHDKey actualCborCryptoHDKey = CborCryptoHDKey(
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

      // Act
      Uint8List actualSerializedCborBytes = actualCborCryptoHDKey.toSerializedCbor(includeTagBool: false);

      // Assert
      Uint8List expectedSerializedCborBytes = HexCodec.decode(
        'a503582103ac4a4471ddb01e1d81295172066f9b3d38665a380472befa3375d66054093966045820e60be89322d1022a4408b813e409e43cb5fab61444a3e136eede70501a676bdc06d90130a20186182cf5183cf500f5021a99fa638e081a30346662096954455354204e414d45',
      );

      expect(actualSerializedCborBytes, expectedSerializedCborBytes);
    });
  });

  group('Tests of CborCryptoHDKey.toCborMap()', () {
    test('Should [return CborMap] from CborCryptoHDKey (WITH tag)', () {
      // Arrange
      CborCryptoHDKey actualCborCryptoHDKey = CborCryptoHDKey(
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

      // Act
      CborMap actualCborMap = actualCborCryptoHDKey.toCborMap(includeTagBool: true);

      // Assert
      CborMap expectedCborMap = CborMap(
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

      expect(actualCborMap, expectedCborMap);
    });

    test('Should [return CborMap] from CborCryptoHDKey (WITHOUT tag)', () {
      // Arrange
      CborCryptoHDKey actualCborCryptoHDKey = CborCryptoHDKey(
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

      // Act
      CborMap actualCborMap = actualCborCryptoHDKey.toCborMap(includeTagBool: false);

      // Assert
      CborMap expectedCborMap = CborMap(
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
          ),
          const CborSmallInt(8): const CborSmallInt(808740450),
          const CborSmallInt(9): CborString('TEST NAME'),
        },
        tags: <int>[],
      );

      expect(actualCborMap, expectedCborMap);
    });
  });

  group('Tests of CborCryptoHDKey.getCborSpecialTag()', () {
    test('Should [return CborSpecialTag.cryptoHDKey] from CborCryptoHDKey', () {
      // Arrange
      CborCryptoHDKey actualCborCryptoHDKey = CborCryptoHDKey(
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

      // Act
      CborSpecialTag actualCborSpecialTag = actualCborCryptoHDKey.getCborSpecialTag();

      // Assert
      CborSpecialTag expectedCborSpecialTag = CborSpecialTag.cryptoHDKey;

      expect(actualCborSpecialTag, expectedCborSpecialTag);
    });
  });
}
