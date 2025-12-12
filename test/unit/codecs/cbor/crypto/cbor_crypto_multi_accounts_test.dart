import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/src/codecs/cbor/cbor_special_tag.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/cbor_crypto_hd_key.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/cbor_crypto_keypath.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/cbor_crypto_multi_accounts.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/metadata/cbor_path_component.dart';
import 'package:codec_utils/src/codecs/hex/hex_codec.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of CborCryptoMultiAccounts.fromSerializedCbor()', () {
    test('Should [return CborCryptoMultiAccounts] from serialized CBOR bytes (WITH tag)', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
          'd9044fa5016865393138316366330281d9012fa203582102eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b06d90130a10188182cf51901f5f500f500f503686b657973746f6e65047828323834373563386438306636633036626166626534366137643137353066336663663235363566370565312e302e32');

      // Act
      CborCryptoMultiAccounts actualCborCryptoMultiAccounts = CborCryptoMultiAccounts.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      CborCryptoMultiAccounts expectedCborCryptoMultiAccounts = CborCryptoMultiAccounts(
        masterFingerprint: 'e9181cf3',
        cryptoHDKeyList: <CborCryptoHDKey>[
          CborCryptoHDKey(
              isMaster: false,
              isPrivate: false,
              keyData: HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b'),
              origin: const CborCryptoKeypath(
                components: <CborPathComponent>[
                  CborPathComponent(index: 44, hardened: true),
                  CborPathComponent(index: 501, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                ],
              )),
        ],
        device: 'keystone',
        deviceId: '28475c8d80f6c06bafbe46a7d1750f3fcf2565f7',
        deviceVersion: '1.0.2',
      );

      expect(actualCborCryptoMultiAccounts, expectedCborCryptoMultiAccounts);
    });

    test('Should [return CborCryptoMultiAccounts] from serialized CBOR bytes (WITHOUT tag)', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
          'a5016865393138316366330281d9012fa203582102eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b06d90130a10188182cf51901f5f500f500f503686b657973746f6e65047828323834373563386438306636633036626166626534366137643137353066336663663235363566370565312e302e32');

      // Act
      CborCryptoMultiAccounts actualCborCryptoMultiAccounts = CborCryptoMultiAccounts.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      CborCryptoMultiAccounts expectedCborCryptoMultiAccounts = CborCryptoMultiAccounts(
        masterFingerprint: 'e9181cf3',
        cryptoHDKeyList: <CborCryptoHDKey>[
          CborCryptoHDKey(
              isMaster: false,
              isPrivate: false,
              keyData: HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b'),
              origin: const CborCryptoKeypath(
                components: <CborPathComponent>[
                  CborPathComponent(index: 44, hardened: true),
                  CborPathComponent(index: 501, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                ],
              )),
        ],
        device: 'keystone',
        deviceId: '28475c8d80f6c06bafbe46a7d1750f3fcf2565f7',
        deviceVersion: '1.0.2',
      );

      expect(actualCborCryptoMultiAccounts, expectedCborCryptoMultiAccounts);
    });
  });

  group('Tests of CborCryptoMultiAccounts.fromCborMap()', () {
    test('Should [return CborCryptoMultiAccounts] from CborMap (WITH tag)', () {
      // Arrange
      CborMap actualCborMap = CborMap(
        <CborSmallInt, CborValue>{
          const CborSmallInt(1): CborString('e9181cf3'),
          const CborSmallInt(2): CborList(<CborValue>[
            CborMap(
              <CborSmallInt, CborValue>{
                const CborSmallInt(1): const CborBool(false),
                const CborSmallInt(2): const CborBool(false),
                const CborSmallInt(3): CborBytes(HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b')),
                const CborSmallInt(6): CborMap(
                  <CborSmallInt, CborValue>{
                    const CborSmallInt(1): CborList(<CborValue>[
                      const CborSmallInt(44),
                      const CborBool(true),
                      const CborSmallInt(501),
                      const CborBool(true),
                      const CborSmallInt(0),
                      const CborBool(true),
                      const CborSmallInt(0),
                      const CborBool(true),
                    ]),
                  },
                  tags: <int>[CborSpecialTag.cryptoKeypath.tag],
                ),
              },
              tags: <int>[CborSpecialTag.cryptoHDKey.tag],
            ),
          ]),
          const CborSmallInt(3): CborString('keystone'),
          const CborSmallInt(4): CborString('28475c8d80f6c06bafbe46a7d1750f3fcf2565f7'),
          const CborSmallInt(5): CborString('1.0.2'),
        },
        tags: <int>[CborSpecialTag.cryptoMultiAccounts.tag],
      );

      // Act
      CborCryptoMultiAccounts actualCborCryptoMultiAccounts = CborCryptoMultiAccounts.fromCborMap(actualCborMap);

      // Assert
      CborCryptoMultiAccounts expectedCborCryptoMultiAccounts = CborCryptoMultiAccounts(
        masterFingerprint: 'e9181cf3',
        cryptoHDKeyList: <CborCryptoHDKey>[
          CborCryptoHDKey(
              isMaster: false,
              isPrivate: false,
              keyData: HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b'),
              origin: const CborCryptoKeypath(
                components: <CborPathComponent>[
                  CborPathComponent(index: 44, hardened: true),
                  CborPathComponent(index: 501, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                ],
              )),
        ],
        device: 'keystone',
        deviceId: '28475c8d80f6c06bafbe46a7d1750f3fcf2565f7',
        deviceVersion: '1.0.2',
      );

      expect(actualCborCryptoMultiAccounts, expectedCborCryptoMultiAccounts);
    });

    test('Should [return CborCryptoMultiAccounts] from CborMap (WITHOUT tag)', () {
      // Arrange
      CborMap actualCborMap = CborMap(
        <CborSmallInt, CborValue>{
          const CborSmallInt(1): CborString('e9181cf3'),
          const CborSmallInt(2): CborList(<CborValue>[
            CborMap(
              <CborSmallInt, CborValue>{
                const CborSmallInt(1): const CborBool(false),
                const CborSmallInt(2): const CborBool(false),
                const CborSmallInt(3): CborBytes(HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b')),
                const CborSmallInt(6): CborMap(
                  <CborSmallInt, CborValue>{
                    const CborSmallInt(1): CborList(<CborValue>[
                      const CborSmallInt(44),
                      const CborBool(true),
                      const CborSmallInt(501),
                      const CborBool(true),
                      const CborSmallInt(0),
                      const CborBool(true),
                      const CborSmallInt(0),
                      const CborBool(true),
                    ]),
                  },
                  tags: <int>[CborSpecialTag.cryptoKeypath.tag],
                ),
              },
              tags: <int>[CborSpecialTag.cryptoHDKey.tag],
            ),
          ]),
          const CborSmallInt(3): CborString('keystone'),
          const CborSmallInt(4): CborString('28475c8d80f6c06bafbe46a7d1750f3fcf2565f7'),
          const CborSmallInt(5): CborString('1.0.2'),
        },
        tags: <int>[],
      );

      // Act
      CborCryptoMultiAccounts actualCborCryptoMultiAccounts = CborCryptoMultiAccounts.fromCborMap(actualCborMap);

      // Assert
      CborCryptoMultiAccounts expectedCborCryptoMultiAccounts = CborCryptoMultiAccounts(
        masterFingerprint: 'e9181cf3',
        cryptoHDKeyList: <CborCryptoHDKey>[
          CborCryptoHDKey(
              isMaster: false,
              isPrivate: false,
              keyData: HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b'),
              origin: const CborCryptoKeypath(
                components: <CborPathComponent>[
                  CborPathComponent(index: 44, hardened: true),
                  CborPathComponent(index: 501, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                ],
              )),
        ],
        device: 'keystone',
        deviceId: '28475c8d80f6c06bafbe46a7d1750f3fcf2565f7',
        deviceVersion: '1.0.2',
      );

      expect(actualCborCryptoMultiAccounts, expectedCborCryptoMultiAccounts);
    });
  });
  group('Tests of CborCryptoMultiAccounts.toCborMap()', () {
    test('Should [return CborMap] from CborCryptoMultiAccounts (WITH tag)', () {
      // Arrange
      CborCryptoMultiAccounts actualCborCryptoMultiAccounts = CborCryptoMultiAccounts(
        masterFingerprint: 'e9181cf3',
        cryptoHDKeyList: <CborCryptoHDKey>[
          CborCryptoHDKey(
              isMaster: false,
              isPrivate: false,
              keyData: HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b'),
              origin: const CborCryptoKeypath(
                components: <CborPathComponent>[
                  CborPathComponent(index: 44, hardened: true),
                  CborPathComponent(index: 501, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                ],
              )),
        ],
        device: 'keystone',
        deviceId: '28475c8d80f6c06bafbe46a7d1750f3fcf2565f7',
        deviceVersion: '1.0.2',
      );

      // Act
      CborMap actualCborMap = actualCborCryptoMultiAccounts.toCborMap(includeTagBool: true);

      // Assert
      CborMap expectedCborMap = CborMap(
        <CborSmallInt, CborValue>{
          const CborSmallInt(1): CborString('e9181cf3'),
          const CborSmallInt(2): CborList(<CborValue>[
            CborMap(
              <CborSmallInt, CborValue>{
                const CborSmallInt(3): CborBytes(HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b')),
                const CborSmallInt(6): CborMap(
                  <CborSmallInt, CborValue>{
                    const CborSmallInt(1): CborList(<CborValue>[
                      const CborSmallInt(44),
                      const CborBool(true),
                      const CborSmallInt(501),
                      const CborBool(true),
                      const CborSmallInt(0),
                      const CborBool(true),
                      const CborSmallInt(0),
                      const CborBool(true),
                    ]),
                  },
                  tags: <int>[CborSpecialTag.cryptoKeypath.tag],
                ),
              },
              tags: <int>[CborSpecialTag.cryptoHDKey.tag],
            ),
          ]),
          const CborSmallInt(3): CborString('keystone'),
          const CborSmallInt(4): CborString('28475c8d80f6c06bafbe46a7d1750f3fcf2565f7'),
          const CborSmallInt(5): CborString('1.0.2'),
        },
        tags: <int>[CborSpecialTag.cryptoMultiAccounts.tag],
      );

      expect(actualCborMap, expectedCborMap);
    });

    test('Should [return CborMap] from CborCryptoMultiAccounts (WITHOUT tag)', () {
      // Arrange
      CborCryptoMultiAccounts actualCborCryptoMultiAccounts = CborCryptoMultiAccounts(
        masterFingerprint: 'e9181cf3',
        cryptoHDKeyList: <CborCryptoHDKey>[
          CborCryptoHDKey(
              isMaster: false,
              isPrivate: false,
              keyData: HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b'),
              origin: const CborCryptoKeypath(
                components: <CborPathComponent>[
                  CborPathComponent(index: 44, hardened: true),
                  CborPathComponent(index: 501, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                ],
              )),
        ],
        device: 'keystone',
        deviceId: '28475c8d80f6c06bafbe46a7d1750f3fcf2565f7',
        deviceVersion: '1.0.2',
      );

      // Act
      CborMap actualCborMap = actualCborCryptoMultiAccounts.toCborMap(includeTagBool: false);

      // Assert
      CborMap expectedCborMap = CborMap(
        <CborSmallInt, CborValue>{
          const CborSmallInt(1): CborString('e9181cf3'),
          const CborSmallInt(2): CborList(<CborValue>[
            CborMap(
              <CborSmallInt, CborValue>{
                const CborSmallInt(3): CborBytes(HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b')),
                const CborSmallInt(6): CborMap(
                  <CborSmallInt, CborValue>{
                    const CborSmallInt(1): CborList(<CborValue>[
                      const CborSmallInt(44),
                      const CborBool(true),
                      const CborSmallInt(501),
                      const CborBool(true),
                      const CborSmallInt(0),
                      const CborBool(true),
                      const CborSmallInt(0),
                      const CborBool(true),
                    ]),
                  },
                  tags: <int>[CborSpecialTag.cryptoKeypath.tag],
                ),
              },
              tags: <int>[CborSpecialTag.cryptoHDKey.tag],
            ),
          ]),
          const CborSmallInt(3): CborString('keystone'),
          const CborSmallInt(4): CborString('28475c8d80f6c06bafbe46a7d1750f3fcf2565f7'),
          const CborSmallInt(5): CborString('1.0.2'),
        },
        tags: <int>[CborSpecialTag.cryptoMultiAccounts.tag],
      );

      expect(actualCborMap, expectedCborMap);
    });
  });

  group('Tests of CborCryptoMultiAccounts.toSerializedCbor()', () {
    test('Should [return CborCryptoMultiAccounts] from serialized CBOR bytes (WITH tag)', () {
      // Arrange
      CborCryptoMultiAccounts actualCborCryptoMultiAccounts = CborCryptoMultiAccounts(
        masterFingerprint: 'e9181cf3',
        cryptoHDKeyList: <CborCryptoHDKey>[
          CborCryptoHDKey(
              isMaster: false,
              isPrivate: false,
              keyData: HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b'),
              origin: const CborCryptoKeypath(
                components: <CborPathComponent>[
                  CborPathComponent(index: 44, hardened: true),
                  CborPathComponent(index: 501, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                ],
              )),
        ],
        device: 'keystone',
        deviceId: '28475c8d80f6c06bafbe46a7d1750f3fcf2565f7',
        deviceVersion: '1.0.2',
      );

      // Act
      Uint8List actualSerializedCborBytes = actualCborCryptoMultiAccounts.toSerializedCbor(includeTagBool: true);

      // Assert
      Uint8List expectedSerializedCborBytes = HexCodec.decode(
          'd9044fa5016865393138316366330281d9012fa203582102eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b06d90130a10188182cf51901f5f500f500f503686b657973746f6e65047828323834373563386438306636633036626166626534366137643137353066336663663235363566370565312e302e32');

      expect(actualSerializedCborBytes, expectedSerializedCborBytes);
    });

    test('Should [return CborCryptoMultiAccounts] from serialized CBOR bytes (WITHOUT tag)', () {
      // Arrange
      CborCryptoMultiAccounts actualCborCryptoMultiAccounts = CborCryptoMultiAccounts(
        masterFingerprint: 'e9181cf3',
        cryptoHDKeyList: <CborCryptoHDKey>[
          CborCryptoHDKey(
              isMaster: false,
              isPrivate: false,
              keyData: HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b'),
              origin: const CborCryptoKeypath(
                components: <CborPathComponent>[
                  CborPathComponent(index: 44, hardened: true),
                  CborPathComponent(index: 501, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                ],
              )),
        ],
        device: 'keystone',
        deviceId: '28475c8d80f6c06bafbe46a7d1750f3fcf2565f7',
        deviceVersion: '1.0.2',
      );

      // Act
      Uint8List actualSerializedCborBytes = actualCborCryptoMultiAccounts.toSerializedCbor(includeTagBool: false);

      // Assert
      Uint8List expectedSerializedCborBytes = HexCodec.decode(
          'a5016865393138316366330281d9012fa203582102eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b06d90130a10188182cf51901f5f500f500f503686b657973746f6e65047828323834373563386438306636633036626166626534366137643137353066336663663235363566370565312e302e32');

      expect(actualSerializedCborBytes, expectedSerializedCborBytes);
    });
  });
  group('Tests of CborCryptoMultiAccounts.getCborSpecialTag()', () {
    test('Should [return CborSpecialTag.cryptoMultiAccounts] from CborCryptoMultiAccounts', () {
      // Arrange
      CborCryptoMultiAccounts actualCborCryptoMultiAccounts = CborCryptoMultiAccounts(
        masterFingerprint: 'e9181cf3',
        cryptoHDKeyList: <CborCryptoHDKey>[
          CborCryptoHDKey(
              isMaster: false,
              isPrivate: false,
              keyData: HexCodec.decode('02eae4b876a8696134b868f88cc2f51f715f2dbedb7446b8e6edf3d4541c4eb67b'),
              origin: const CborCryptoKeypath(
                components: <CborPathComponent>[
                  CborPathComponent(index: 44, hardened: true),
                  CborPathComponent(index: 501, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                  CborPathComponent(index: 0, hardened: true),
                ],
              )),
        ],
        device: 'keystone',
        deviceId: '28475c8d80f6c06bafbe46a7d1750f3fcf2565f7',
        deviceVersion: '1.0.2',
      );

      // Act
      CborSpecialTag actualCborSpecialTag = actualCborCryptoMultiAccounts.getCborSpecialTag();

      // Assert
      CborSpecialTag expectedCborSpecialTag = CborSpecialTag.cryptoMultiAccounts;

      expect(actualCborSpecialTag, expectedCborSpecialTag);
    });
  });
}
