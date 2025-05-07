import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/src/codecs/cbor/a_cbor_tagged_object.dart';
import 'package:codec_utils/src/codecs/cbor/cbor_special_tag.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/cbor_crypto_keypath.dart';
import 'package:codec_utils/src/codecs/cbor/solana/metadata/cbor_sol_sign_data_type.dart';

/// Metadata for the signing request for Solana.
/// https://dev.keyst.one/docs/integration-tutorial-advanced/solana#genereate-the-sign-request
class CborSolSignRequest extends ACborTaggedObject {
  static const CborSpecialTag cborSpecialTag = CborSpecialTag.solSignRequest;

  /// The unsigned transaction data, in hex string
  final Uint8List signData;

  /// The type of data to be signed, listed in [SolSignDataType]
  final CborSolSignDataType dataType;

  /// The key path of the private key to sign the data
  final CborCryptoKeypath derivationPath;

  /// The identifier for signing request
  final Uint8List? requestId;

  /// The address for request this signing
  final Uint8List? address;

  /// The origin of this sign request, like wallet name
  final String? origin;

  const CborSolSignRequest({
    required this.signData,
    required this.dataType,
    required this.derivationPath,
    required this.requestId,
    this.address,
    this.origin,
  });

  factory CborSolSignRequest.fromSerializedCbor(Uint8List serializedCbor) {
    CborMap cborMap = cborDecode(serializedCbor) as CborMap;
    return CborSolSignRequest.fromCborMap(cborMap);
  }

  factory CborSolSignRequest.fromCborMap(CborMap cborMap) {
    CborBytes? cborRequestId = cborMap[const CborSmallInt(1)] as CborBytes?;
    CborBytes cborSignData = cborMap[const CborSmallInt(2)] as CborBytes;
    CborMap cborDerivationPath = cborMap[const CborSmallInt(3)] as CborMap;
    CborBytes? cborAddress = cborMap[const CborSmallInt(4)] as CborBytes?;
    CborString? cborOrigin = cborMap[const CborSmallInt(5)] as CborString?;
    CborSmallInt cborSignType = cborMap[const CborSmallInt(6)] as CborSmallInt;

    return CborSolSignRequest(
      requestId: Uint8List.fromList(cborRequestId!.bytes),
      signData: Uint8List.fromList(cborSignData.bytes),
      dataType: CborSolSignDataType.fromCborIndex(cborSignType.value),
      derivationPath: CborCryptoKeypath.fromCborMap(cborDerivationPath),
      address: cborAddress != null ? Uint8List.fromList(cborAddress.bytes) : null,
      origin: cborOrigin?.toString(),
    );
  }

  @override
  CborMap toCborMap({required bool includeTagBool}) {
    return CborMap.of(
      <CborValue, CborValue>{
        if (requestId != null) const CborSmallInt(1): CborBytes(Uint8List.fromList(requestId!), tags: <int>[CborSpecialTag.uuid.tag]),
        const CborSmallInt(2): CborBytes(Uint8List.fromList(signData)),
        const CborSmallInt(3): derivationPath.toCborMap(includeTagBool: true),
        if (address != null) const CborSmallInt(4): CborBytes(address!),
        if (origin != null) const CborSmallInt(5): CborString(origin!),
        const CborSmallInt(6): CborSmallInt(dataType.cborIndex),
      },
      tags: includeTagBool ? <int>[cborSpecialTag.tag] : <int>[],
    );
  }

  @override
  CborSpecialTag getCborSpecialTag() => cborSpecialTag;

  @override
  List<Object?> get props => <Object?>[
        requestId,
        signData,
        derivationPath,
        address,
        origin,
        dataType,
      ];
}
