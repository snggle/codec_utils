import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/src/codecs/cbor/a_cbor_tagged_object.dart';
import 'package:codec_utils/src/codecs/cbor/cbor_special_tag.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/cbor_crypto_keypath.dart';
import 'package:codec_utils/src/codecs/cbor/ethereum/metadata/cbor_eth_sign_data_type.dart';
import 'package:codec_utils/src/codecs/hex/hex_codec.dart';

/// Metadata for the signing request for Ethereum.
/// https://github.com/ethereum/ercs/blob/master/ERCS/erc-4527.md#cddl-for-eth-sign-request
class CborEthSignRequest extends ACborTaggedObject {
  static CborSpecialTag cborSpecialTag = CborSpecialTag.ethSignRequest;

  /// Data to be signed by offline signer, currently it can be unsigned transaction or typed data.
  /// For unsigned transactions it will be the rlp encoding for unsigned
  /// transaction data and ERC 712 typed data it will be the bytes of json string.
  final Uint8List signData;

  /// The type of data to be signed, listed in [EthSignDataType]
  final CborEthSignDataType dataType;

  /// The key path of the private key to sign the data
  final CborCryptoKeypath derivationPath;

  /// Chain id of ethereum related blockchain.
  /// Each ethereum-based chain has its own file CAIP-2.json containing the chain id.
  final int chainId;

  /// The identifier for signing request
  final Uint8List? requestId;

  /// Ethereum address of the signing type for verification purposes which is optional
  final String? address;

  /// The origin of this sign request, like wallet name
  final String? origin;

  const CborEthSignRequest({
    required this.signData,
    required this.dataType,
    required this.derivationPath,
    this.chainId = 1,
    this.requestId,
    this.address,
    this.origin,
  });

  factory CborEthSignRequest.fromSerializedCbor(Uint8List serializedCbor) {
    CborMap cborMap = cborDecode(serializedCbor) as CborMap;
    return CborEthSignRequest.fromCborMap(cborMap);
  }

  factory CborEthSignRequest.fromCborMap(CborMap cborMap) {
    CborBytes cborRequestId = cborMap[const CborSmallInt(1)] as CborBytes;
    CborBytes cborSignData = cborMap[const CborSmallInt(2)] as CborBytes;
    CborSmallInt? cborDataType = cborMap[const CborSmallInt(3)] as CborSmallInt?;
    CborSmallInt? cborChainId = cborMap[const CborSmallInt(4)] as CborSmallInt?;
    CborMap cborDerivationPath = cborMap[const CborSmallInt(5)] as CborMap;
    CborBytes? cborAddress = cborMap[const CborSmallInt(6)] as CborBytes?;
    CborString? cborOrigin = cborMap[const CborSmallInt(7)] as CborString?;

    return CborEthSignRequest(
      requestId: Uint8List.fromList(cborRequestId.bytes),
      signData: Uint8List.fromList(cborSignData.bytes),
      dataType: cborDataType != null ? CborEthSignDataType.fromCborIndex(cborDataType.value) : CborEthSignDataType.fromCborIndex(1),
      chainId: cborChainId?.value ?? 1,
      derivationPath: CborCryptoKeypath.fromCborMap(cborDerivationPath),
      address: cborAddress != null ? HexCodec.encode(cborAddress.bytes, includePrefixBool: true) : null,
      origin: cborOrigin?.toString(),
    );
  }

  @override
  CborMap toCborMap({required bool includeTagBool}) {
    return CborMap.of(
      <CborValue, CborValue>{
        if (requestId != null) const CborSmallInt(1): CborBytes(Uint8List.fromList(requestId!), tags: <int>[CborSpecialTag.uuid.tag]),
        const CborSmallInt(2): CborBytes(Uint8List.fromList(signData)),
        const CborSmallInt(3): CborSmallInt(dataType.cborIndex),
        if (chainId != 1) const CborSmallInt(4): CborSmallInt(chainId),
        const CborSmallInt(5): derivationPath.toCborMap(includeTagBool: true),
        if (address != null) const CborSmallInt(6): CborBytes(HexCodec.decode(address!)),
        if (origin != null) const CborSmallInt(7): CborString(origin!),
      },
      tags: includeTagBool ? <int>[cborSpecialTag.tag] : <int>[],
    );
  }

  @override
  CborSpecialTag getCborSpecialTag() => cborSpecialTag;

  @override
  List<Object?> get props => <Object?>[requestId, signData, dataType, chainId, derivationPath, address, origin];
}
