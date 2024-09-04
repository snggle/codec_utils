import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/src/codecs/cbor/cbor_special_tag.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/cbor_crypto_coin_info.dart';
import 'package:codec_utils/src/codecs/hex/hex_codec.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of CborCryptoCoinInfo.fromSerializedCbor()', () {
    test('Should [return CborCryptoCoinInfo] from serialized CBOR bytes (WITH tag)', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode('d90131a201183c0201');

      // Act
      CborCryptoCoinInfo actualCborCryptoCoinInfo = CborCryptoCoinInfo.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      CborCryptoCoinInfo expectedCborCryptoCoinInfo = const CborCryptoCoinInfo(type: 60, network: 1);

      expect(actualCborCryptoCoinInfo, expectedCborCryptoCoinInfo);
    });

    test('Should [return CborCryptoCoinInfo] from serialized CBOR bytes (WITHOUT tag)', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode('a201183c0201');

      // Act
      CborCryptoCoinInfo actualCborCryptoCoinInfo = CborCryptoCoinInfo.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      CborCryptoCoinInfo expectedCborCryptoCoinInfo = const CborCryptoCoinInfo(type: 60, network: 1);

      expect(actualCborCryptoCoinInfo, expectedCborCryptoCoinInfo);
    });
  });

  group('Tests of CborCryptoCoinInfo.fromCborMap()', () {
    test('Should [return CborCryptoCoinInfo] from CborMap (WITH tag)', () {
      // Arrange
      CborMap actualCborMap = CborMap(<CborSmallInt, CborValue>{
        const CborSmallInt(1): const CborSmallInt(60),
        const CborSmallInt(2): const CborSmallInt(1),
      }, tags: <int>[
        CborSpecialTag.cryptoCoinInfo.tag
      ]);

      // Act
      CborCryptoCoinInfo actualCborCryptoCoinInfo = CborCryptoCoinInfo.fromCborMap(actualCborMap);

      // Assert
      CborCryptoCoinInfo expectedCborCryptoCoinInfo = const CborCryptoCoinInfo(type: 60, network: 1);

      expect(actualCborCryptoCoinInfo, expectedCborCryptoCoinInfo);
    });

    test('Should [return CborCryptoCoinInfo] from CborMap (WITHOUT tag)', () {
      // Arrange
      CborMap actualCborMap = CborMap(<CborSmallInt, CborValue>{
        const CborSmallInt(1): const CborSmallInt(60),
        const CborSmallInt(2): const CborSmallInt(1),
      }, tags: <int>[]);

      // Act
      CborCryptoCoinInfo actualCborCryptoCoinInfo = CborCryptoCoinInfo.fromCborMap(actualCborMap);

      // Assert
      CborCryptoCoinInfo expectedCborCryptoCoinInfo = const CborCryptoCoinInfo(type: 60, network: 1);

      expect(actualCborCryptoCoinInfo, expectedCborCryptoCoinInfo);
    });
  });

  group('Tests of CborCryptoCoinInfo.toSerializedCbor()', () {
    test('Should [return serialized CBOR bytes] from CborCryptoCoinInfo (WITH tag)', () {
      // Arrange
      CborCryptoCoinInfo actualCborCryptoCoinInfo = const CborCryptoCoinInfo(type: 60, network: 1);

      // Act
      Uint8List actualSerializedCborBytes = actualCborCryptoCoinInfo.toSerializedCbor(includeTagBool: true);

      // Assert
      Uint8List expectedSerializedCborBytes = HexCodec.decode('d90131a201183c0201');

      expect(actualSerializedCborBytes, expectedSerializedCborBytes);
    });

    test('Should [return serialized CBOR bytes] from CborCryptoCoinInfo (WITHOUT tag)', () {
      // Arrange
      CborCryptoCoinInfo actualCborCryptoCoinInfo = const CborCryptoCoinInfo(type: 60, network: 1);

      // Act
      Uint8List actualSerializedCborBytes = actualCborCryptoCoinInfo.toSerializedCbor(includeTagBool: false);

      // Assert
      Uint8List expectedSerializedCborBytes = HexCodec.decode('a201183c0201');

      expect(actualSerializedCborBytes, expectedSerializedCborBytes);
    });
  });

  group('Tests of CborCryptoCoinInfo.toCborMap()', () {
    test('Should [return CborMap] from CborCryptoCoinInfo (WITH tag)', () {
      // Arrange
      CborCryptoCoinInfo actualCborCryptoCoinInfo = const CborCryptoCoinInfo(type: 60, network: 1);

      // Act
      CborMap actualCborMap = actualCborCryptoCoinInfo.toCborMap(includeTagBool: true);

      // Assert
      CborMap expectedCborMap = CborMap(<CborSmallInt, CborValue>{
        const CborSmallInt(1): const CborSmallInt(60),
        const CborSmallInt(2): const CborSmallInt(1),
      }, tags: <int>[
        CborSpecialTag.cryptoCoinInfo.tag
      ]);

      expect(actualCborMap, expectedCborMap);
    });

    test('Should [return CborMap] from CborCryptoCoinInfo (WITHOUT tag)', () {
      // Arrange
      CborCryptoCoinInfo actualCborCryptoCoinInfo = const CborCryptoCoinInfo(type: 60, network: 1);

      // Act
      CborMap actualCborMap = actualCborCryptoCoinInfo.toCborMap(includeTagBool: true);

      // Assert
      CborMap expectedCborMap = CborMap(<CborSmallInt, CborValue>{
        const CborSmallInt(1): const CborSmallInt(60),
        const CborSmallInt(2): const CborSmallInt(1),
      }, tags: <int>[]);

      expect(actualCborMap, expectedCborMap);
    });
  });

  group('Tests of CborCryptoCoinInfo.getCborSpecialTag()', () {
    test('Should [return CborSpecialTag.cryptoCoinInfo] from CborCryptoCoinInfo', () {
      // Arrange
      CborCryptoCoinInfo actualCborCryptoCoinInfo = const CborCryptoCoinInfo(type: 60, network: 1);

      // Act
      CborSpecialTag actualCborSpecialTag = actualCborCryptoCoinInfo.getCborSpecialTag();

      // Assert
      CborSpecialTag expectedCborSpecialTag = CborSpecialTag.cryptoCoinInfo;

      expect(actualCborSpecialTag, expectedCborSpecialTag);
    });
  });
}
