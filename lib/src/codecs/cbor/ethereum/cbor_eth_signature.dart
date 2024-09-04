import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/src/codecs/cbor/a_cbor_tagged_object.dart';
import 'package:codec_utils/src/codecs/cbor/cbor_special_tag.dart';

/// Metadata for the signature response for Ethereum.
/// https://github.com/ethereum/ercs/blob/master/ERCS/erc-4527.md#cddl-for-eth-signature
class CborEthSignature extends ACborTaggedObject {
  static CborSpecialTag cborSpecialTag = CborSpecialTag.ethSignature;

  /// The identifier for signing request
  final Uint8List requestId;

  /// The signature of the signing request (r,s,v)
  final Uint8List signature;

  /// The device info for providing this signature.
  final String? origin;

  const CborEthSignature({
    required this.requestId,
    required this.signature,
    this.origin,
  });

  factory CborEthSignature.fromSerializedCbor(Uint8List serializedCbor) {
    CborMap cborMap = cborDecode(serializedCbor) as CborMap;
    return CborEthSignature.fromCborMap(cborMap);
  }

  factory CborEthSignature.fromCborMap(CborMap cborMap) {
    CborBytes cborRequestId = cborMap[const CborSmallInt(1)] as CborBytes;
    CborBytes cborSignature = cborMap[const CborSmallInt(2)] as CborBytes;
    CborString? cborOrigin = cborMap[const CborSmallInt(3)] as CborString?;

    return CborEthSignature(
      requestId: Uint8List.fromList(cborRequestId.bytes),
      signature: Uint8List.fromList(cborSignature.bytes),
      origin: cborOrigin?.toString(),
    );
  }

  @override
  CborMap toCborMap({required bool includeTagBool}) {
    return CborMap.of(
      <CborValue, CborValue>{
        const CborSmallInt(1): CborBytes(requestId, tags: <int>[CborSpecialTag.uuid.tag]),
        const CborSmallInt(2): CborBytes(signature),
        if (origin != null) const CborSmallInt(3): CborString(origin!),
      },
      tags: includeTagBool ? <int>[cborSpecialTag.tag] : <int>[],
    );
  }

  @override
  CborSpecialTag getCborSpecialTag() => cborSpecialTag;

  @override
  List<Object?> get props => <Object?>[requestId, signature, origin];
}
