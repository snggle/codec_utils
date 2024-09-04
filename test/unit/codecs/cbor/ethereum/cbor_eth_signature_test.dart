import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/src/codecs/cbor/cbor_special_tag.dart';
import 'package:codec_utils/src/codecs/cbor/ethereum/cbor_eth_signature.dart';
import 'package:codec_utils/src/codecs/hex/hex_codec.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of CborEthSignature.fromSerializedCbor()', () {
    test('Should [return CborEthSignature] from serialized CBOR bytes (WITH tag)', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
        'd90192a201d8255086bf97f8219d499e9ab0c2a4af350683025841f486c6ebd6f3e7bb1ac1d176f078516a191fd610866c2dca0f2f8655d8ce5a6f52dd2bc8787eb90ebd3caa2b28b42f6b0fcdb594d84af1018ec58568ebb2e84000',
      );

      // Act
      CborEthSignature actualCborEthSignature = CborEthSignature.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      CborEthSignature expectedCborEthSignature = CborEthSignature(
        requestId: base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='),
        signature: base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA='),
      );

      expect(actualCborEthSignature, expectedCborEthSignature);
    });

    test('Should [return CborEthSignature] from serialized CBOR bytes (WITHOUT tag)', () {
      // Arrange
      Uint8List actualSerializedCborBytes = HexCodec.decode(
        'a201d8255086bf97f8219d499e9ab0c2a4af350683025841f486c6ebd6f3e7bb1ac1d176f078516a191fd610866c2dca0f2f8655d8ce5a6f52dd2bc8787eb90ebd3caa2b28b42f6b0fcdb594d84af1018ec58568ebb2e84000',
      );

      // Act
      CborEthSignature actualCborEthSignature = CborEthSignature.fromSerializedCbor(actualSerializedCborBytes);

      // Assert
      CborEthSignature expectedCborEthSignature = CborEthSignature(
        requestId: base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='),
        signature: base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA='),
      );

      expect(actualCborEthSignature, expectedCborEthSignature);
    });
  });

  group('Tests of CborEthSignature.fromCborMap()', () {
    test('Should [return CborEthSignature] from CborMap (WITH tag)', () {
      // Arrange
      CborMap actualCborMap = CborMap(
        <CborSmallInt, CborValue>{
          const CborSmallInt(1): CborBytes(base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='), tags: <int>[CborSpecialTag.uuid.tag]),
          const CborSmallInt(2): CborBytes(base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA=')),
        },
        tags: <int>[CborSpecialTag.ethSignature.tag],
      );

      // Act
      CborEthSignature actualCborEthSignature = CborEthSignature.fromCborMap(actualCborMap);

      // Assert
      CborEthSignature expectedCborEthSignature = CborEthSignature(
        requestId: base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='),
        signature: base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA='),
      );

      expect(actualCborEthSignature, expectedCborEthSignature);
    });

    test('Should [return CborEthSignature] from CborMap (WITHOUT tag)', () {
      // Arrange
      CborMap actualCborMap = CborMap(
        <CborSmallInt, CborValue>{
          const CborSmallInt(1): CborBytes(base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='), tags: <int>[CborSpecialTag.uuid.tag]),
          const CborSmallInt(2): CborBytes(base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA=')),
        },
        tags: <int>[],
      );

      // Act
      CborEthSignature actualCborEthSignature = CborEthSignature.fromCborMap(actualCborMap);

      // Assert
      CborEthSignature expectedCborEthSignature = CborEthSignature(
        requestId: base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='),
        signature: base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA='),
      );

      expect(actualCborEthSignature, expectedCborEthSignature);
    });
  });

  group('Tests of CborEthSignature.toSerializedCbor()', () {
    test('Should [return serialized CBOR bytes] from CborEthSignature (WITH tag)', () {
      // Arrange
      CborEthSignature actualCborEthSignature = CborEthSignature(
        requestId: base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='),
        signature: base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA='),
      );

      // Act
      Uint8List actualSerializedCborBytes = actualCborEthSignature.toSerializedCbor(includeTagBool: true);

      // Assert
      Uint8List expectedSerializedCborBytes = HexCodec.decode(
        'd90192a201d8255086bf97f8219d499e9ab0c2a4af350683025841f486c6ebd6f3e7bb1ac1d176f078516a191fd610866c2dca0f2f8655d8ce5a6f52dd2bc8787eb90ebd3caa2b28b42f6b0fcdb594d84af1018ec58568ebb2e84000',
      );

      expect(actualSerializedCborBytes, expectedSerializedCborBytes);
    });

    test('Should [return serialized CBOR bytes] from CborEthSignature (WITHOUT tag)', () {
      // Arrange
      CborEthSignature actualCborEthSignature = CborEthSignature(
        requestId: base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='),
        signature: base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA='),
      );

      // Act
      Uint8List actualSerializedCborBytes = actualCborEthSignature.toSerializedCbor(includeTagBool: false);

      // Assert
      Uint8List expectedSerializedCborBytes = HexCodec.decode(
        'a201d8255086bf97f8219d499e9ab0c2a4af350683025841f486c6ebd6f3e7bb1ac1d176f078516a191fd610866c2dca0f2f8655d8ce5a6f52dd2bc8787eb90ebd3caa2b28b42f6b0fcdb594d84af1018ec58568ebb2e84000',
      );

      expect(actualSerializedCborBytes, expectedSerializedCborBytes);
    });
  });

  group('Tests of CborEthSignature.toCborMap()', () {
    test('Should [return CborMap] from CborEthSignature (WITH tag)', () {
      // Arrange
      CborEthSignature actualCborEthSignature = CborEthSignature(
        requestId: base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='),
        signature: base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA='),
      );

      // Act
      CborMap actualCborMap = actualCborEthSignature.toCborMap(includeTagBool: true);

      // Assert
      CborMap expectedCborMap = CborMap(
        <CborSmallInt, CborValue>{
          const CborSmallInt(1): CborBytes(base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='), tags: <int>[CborSpecialTag.uuid.tag]),
          const CborSmallInt(2): CborBytes(base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA=')),
        },
        tags: <int>[CborSpecialTag.ethSignature.tag],
      );

      expect(actualCborMap, expectedCborMap);
    });

    test('Should [return CborMap] from CborEthSignature (WITHOUT tag)', () {
      // Arrange
      CborEthSignature actualCborEthSignature = CborEthSignature(
        requestId: base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='),
        signature: base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA='),
      );

      // Act
      CborMap actualCborMap = actualCborEthSignature.toCborMap(includeTagBool: false);

      // Assert
      CborMap expectedCborMap = CborMap(
        <CborSmallInt, CborValue>{
          const CborSmallInt(1): CborBytes(base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='), tags: <int>[CborSpecialTag.uuid.tag]),
          const CborSmallInt(2): CborBytes(base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA=')),
        },
        tags: <int>[],
      );

      expect(actualCborMap, expectedCborMap);
    });
  });

  group('Tests of CborEthSignature.getCborSpecialTag()', () {
    test('Should [return CborSpecialTag.ethSignature] from CborEthSignature', () {
      // Arrange
      CborEthSignature actualCborEthSignature = CborEthSignature(
        requestId: base64Decode('hr+X+CGdSZ6asMKkrzUGgw=='),
        signature: base64Decode('9IbG69bz57sawdF28HhRahkf1hCGbC3KDy+GVdjOWm9S3SvIeH65Dr08qisotC9rD821lNhK8QGOxYVo67LoQAA='),
      );

      // Act
      CborSpecialTag actualCborSpecialTag = actualCborEthSignature.getCborSpecialTag();

      // Assert
      CborSpecialTag expectedCborSpecialTag = CborSpecialTag.ethSignature;

      expect(actualCborSpecialTag, expectedCborSpecialTag);
    });
  });
}
