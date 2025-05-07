import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/src/codecs/cbor/cbor_special_tag.dart';
import 'package:codec_utils/src/codecs/cbor/solana/cbor_sol_signature.dart';
import 'package:codec_utils/src/codecs/hex/hex_codec.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of CborSolSignature.fromSerializedCbor()', () {
    test('Should [return CborSolSignature] from serialized CBOR bytes (WITH tag)', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
        'd9044ea201d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d025840d4f0a7bcd95bba1fbb1051885054730e3f47064288575aacc102fbbf6a9a14daa066991e360d3e3406c20c00a40973eff37c7d641e5b351ec4a99bfe86f335f7',
      );

      // Act
      CborSolSignature actualCborSolSignature = CborSolSignature.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      CborSolSignature expectedCborSolSignature = CborSolSignature(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signature: base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w=='),
      );

      expect(actualCborSolSignature, expectedCborSolSignature);
    });

    test('Should [return CborSolSignature] from serialized CBOR bytes (WITHOUT tag)', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
        'a201d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d025840d4f0a7bcd95bba1fbb1051885054730e3f47064288575aacc102fbbf6a9a14daa066991e360d3e3406c20c00a40973eff37c7d641e5b351ec4a99bfe86f335f7',
      );

      // Act
      CborSolSignature actualCborSolSignature = CborSolSignature.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      CborSolSignature expectedCborSolSignature = CborSolSignature(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signature: base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w=='),
      );

      expect(actualCborSolSignature, expectedCborSolSignature);
    });
  });

  group('Tests of CborSolSignature.fromCborMap()', () {
    test('Should [return CborSolSignature] from CborMap (WITH tag)', () {
      // Arrange
      CborMap actualCborMap = CborMap(
        <CborSmallInt, CborValue>{
          const CborSmallInt(1): CborBytes(base64Decode('mx3rTTt9S62b3SsNez3LbQ=='), tags: <int>[CborSpecialTag.uuid.tag]),
          const CborSmallInt(2): CborBytes(base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w==')),
        },
        tags: <int>[CborSpecialTag.solSignature.tag],
      );

      // Act
      CborSolSignature actualCborSolSignature = CborSolSignature.fromCborMap(actualCborMap);

      // Assert
      CborSolSignature expectedCborSolSignature = CborSolSignature(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signature: base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w=='),
      );

      expect(actualCborSolSignature, expectedCborSolSignature);
    });

    test('Should [return CborSolSignature] from CborMap (WITHOUT tag)', () {
      // Arrange
      CborMap actualCborMap = CborMap(
        <CborSmallInt, CborValue>{
          const CborSmallInt(1): CborBytes(base64Decode('mx3rTTt9S62b3SsNez3LbQ=='), tags: <int>[CborSpecialTag.uuid.tag]),
          const CborSmallInt(2): CborBytes(base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w==')),
        },
        tags: <int>[],
      );

      // Act
      CborSolSignature actualCborSolSignature = CborSolSignature.fromCborMap(actualCborMap);

      // Assert
      CborSolSignature expectedCborSolSignature = CborSolSignature(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signature: base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w=='),
      );

      expect(actualCborSolSignature, expectedCborSolSignature);
    });
  });

  group('Tests of CborSolSignature.toSerializedCbor()', () {
    test('Should [return serialized CBOR bytes] from CborSolSignature (WITH tag)', () {
      // Arrange
      CborSolSignature actualCborSolSignature = CborSolSignature(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signature: base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w=='),
      );

      // Act
      Uint8List actualSerializedCborBytes = actualCborSolSignature.toSerializedCbor(includeTagBool: true);

      // Assert
      Uint8List expectedSerializedCborBytes = HexCodec.decode(
        'd9044ea201d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d025840d4f0a7bcd95bba1fbb1051885054730e3f47064288575aacc102fbbf6a9a14daa066991e360d3e3406c20c00a40973eff37c7d641e5b351ec4a99bfe86f335f7',
      );

      expect(actualSerializedCborBytes, expectedSerializedCborBytes);
    });

    test('Should [return serialized CBOR bytes] from CborSolSignature (WITHOUT tag)', () {
      // Arrange
      CborSolSignature actualCborSolSignature = CborSolSignature(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signature: base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w=='),
      );

      // Act
      Uint8List actualSerializedCborBytes = actualCborSolSignature.toSerializedCbor(includeTagBool: false);

      // Assert
      Uint8List expectedSerializedCborBytes = HexCodec.decode(
        'a201d825509b1deb4d3b7d4bad9bdd2b0d7b3dcb6d025840d4f0a7bcd95bba1fbb1051885054730e3f47064288575aacc102fbbf6a9a14daa066991e360d3e3406c20c00a40973eff37c7d641e5b351ec4a99bfe86f335f7',
      );

      expect(actualSerializedCborBytes, expectedSerializedCborBytes);
    });
  });

  group('Tests of CborSolSignature.toCborMap()', () {
    test('Should [return CborMap] from CborSolSignature (WITH tag)', () {
      // Arrange
      CborSolSignature actualCborSolSignature = CborSolSignature(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signature: base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w=='),
      );

      // Act
      CborMap actualCborMap = actualCborSolSignature.toCborMap(includeTagBool: true);

      // Assert
      CborMap expectedCborMap = CborMap(
        <CborSmallInt, CborValue>{
          const CborSmallInt(1): CborBytes(base64Decode('mx3rTTt9S62b3SsNez3LbQ=='), tags: <int>[CborSpecialTag.uuid.tag]),
          const CborSmallInt(2): CborBytes(base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w==')),
        },
        tags: <int>[CborSpecialTag.solSignature.tag],
      );

      expect(actualCborMap, expectedCborMap);
    });

    test('Should [return CborMap] from CborSolSignature (WITHOUT tag)', () {
      // Arrange
      CborSolSignature actualCborSolSignature = CborSolSignature(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signature: base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w=='),
      );

      // Act
      CborMap actualCborMap = actualCborSolSignature.toCborMap(includeTagBool: false);

      // Assert
      CborMap expectedCborMap = CborMap(
        <CborSmallInt, CborValue>{
          const CborSmallInt(1): CborBytes(base64Decode('mx3rTTt9S62b3SsNez3LbQ=='), tags: <int>[CborSpecialTag.uuid.tag]),
          const CborSmallInt(2): CborBytes(base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w==')),
        },
        tags: <int>[CborSpecialTag.solSignature.tag],
      );

      expect(actualCborMap, expectedCborMap);
    });
  });

  group('Tests of CborSolSignature.getCborSpecialTag()', () {
    test('Should [return CborSpecialTag.solSignature] from CborSolSignature', () {
      // Arrange
      CborSolSignature actualCborSolSignature = CborSolSignature(
        requestId: base64Decode('mx3rTTt9S62b3SsNez3LbQ=='),
        signature: base64Decode('1PCnvNlbuh+7EFGIUFRzDj9HBkKIV1qswQL7v2qaFNqgZpkeNg0+NAbCDACkCXPv83x9ZB5bNR7EqZv+hvM19w=='),
      );

      // Act
      CborSpecialTag actualCborSpecialTag = actualCborSolSignature.getCborSpecialTag();

      // Assert
      CborSpecialTag expectedCborSpecialTag = CborSpecialTag.solSignature;

      expect(actualCborSpecialTag, expectedCborSpecialTag);
    });
  });
}
