import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/src/codecs/cbor/a_cbor_tagged_object.dart';
import 'package:codec_utils/src/codecs/cbor/cbor_special_tag.dart';

/// Metadata for the signature response for Solana.
///
/// There is a discrepancy between the Keystone documentation (the first link below) showing the parameter requestId as required
/// and actual implementation in their code which leaves it optional (the second link below).
/// There is no information on how null values should be handled or what would happen if we received them.
/// This implementation follows Keystone's actual implementation.
///
/// https://dev.keyst.one/docs/integration-tutorial-advanced/solana#extract-signature
/// https://github.com/KeystoneHQ/keystone-sdk-base/blob/master/packages/ur-registry-sol/src/SolSignature.ts
class CborSolSignature extends ACborTaggedObject {
  static const CborSpecialTag cborSpecialTag = CborSpecialTag.solSignature;

  /// The requestId from sign request
  final Uint8List? requestId;

  /// The serialized signature in hex string
  final Uint8List signature;

  const CborSolSignature({
    required this.requestId,
    required this.signature,
  });

  factory CborSolSignature.fromSerializedCbor(Uint8List serializedCbor) {
    CborMap cborMap = cborDecode(serializedCbor) as CborMap;
    return CborSolSignature.fromCborMap(cborMap);
  }

  factory CborSolSignature.fromCborMap(CborMap cborMap) {
    CborBytes? cborRequestId = cborMap[const CborSmallInt(1)] as CborBytes?;
    CborBytes cborSignature = cborMap[const CborSmallInt(2)] as CborBytes;

    return CborSolSignature(
      requestId: cborRequestId != null ? Uint8List.fromList(cborRequestId.bytes) : null,
      signature: Uint8List.fromList(cborSignature.bytes),
    );
  }

  @override
  CborMap toCborMap({required bool includeTagBool}) {
    return CborMap.of(
      <CborValue, CborValue>{
        const CborSmallInt(1): CborBytes(requestId!, tags: <int>[CborSpecialTag.uuid.tag]),
        const CborSmallInt(2): CborBytes(signature),
      },
      tags: includeTagBool ? <int>[cborSpecialTag.tag] : <int>[],
    );
  }

  @override
  CborSpecialTag getCborSpecialTag() => cborSpecialTag;

  @override
  List<Object?> get props => <Object?>[requestId, signature];
}
