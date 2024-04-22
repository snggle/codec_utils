import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/src/codecs/cbor/a_cbor_tagged_object.dart';
import 'package:codec_utils/src/codecs/cbor/cbor_special_tag.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/cbor_crypto_coin_info.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/cbor_crypto_keypath.dart';

/// An HD key is either a master key or a derived key.
/// A master key is always private, has no use or derivation information and always includes a chain code.
///
/// A derived key may be private or public, has an optional chain code, and may carry additional metadata about its use and derivation.
/// To maintain isomorphism with BIP32 and allow keys to be derived from this key [chainCode], [origin], and [parentFingerprint] must be present.
/// If [origin] contains only a single derivation step and also contains [sourceFingerprint]
/// then [parentFingerprint] MUST be identical to [sourceFingerprint] or may be omitted.
///
/// https://github.com/BlockchainCommons/Research/blob/master/papers/bcr-2020-007-hdkey.md#cddl-for-hdkey
class CborCryptoHDKey extends ACborTaggedObject {
  static const CborSpecialTag cborSpecialTag = CborSpecialTag.cryptoHDKey;

  /// Defines whether the key is a master key or a derived key.
  final bool isMaster;

  /// Defines whether the key is private or public. Used only for derived-key.
  final bool isPrivate;

  /// Key data bytes. Depending on the value of [isPrivate] this may be a private or public key.
  final Uint8List keyData;

  /// Stores the chain code. Used for both: master-key and derived-key.
  /// Should be omitted if no further keys may be derived from this key.
  final Uint8List? chainCode;

  /// Defines how the key is to be used (network and its type: eg. Bitcoin and Testnet) .
  final CborCryptoCoinInfo? useInfo;

  /// Defines the derivation path of the key.
  final CborCryptoKeypath? origin;

  /// Defines what children should/can be derived from this.
  final CborCryptoKeypath? children;

  /// The fingerprint of this key's direct ancestor
  final int? parentFingerprint;

  /// A short name for the key
  final String? name;

  /// Additional note (optional)
  ///   - "account.standard" : BIP44 Standard account
  ///   - "account.ledger_live" : Ledger Live account
  ///   - "account.ledger_legacy" : Ledger Legacy account
  final String? note;

  const CborCryptoHDKey({
    required this.isMaster,
    required this.isPrivate,
    required this.keyData,
    this.chainCode,
    this.useInfo,
    this.origin,
    this.children,
    this.parentFingerprint,
    this.name,
    this.note,
  });

  factory CborCryptoHDKey.fromSerializedCbor(Uint8List serializedCbor) {
    CborMap cborMap = cborDecode(serializedCbor) as CborMap;
    return CborCryptoHDKey.fromCborMap(cborMap);
  }

  factory CborCryptoHDKey.fromCborMap(CborMap cborMap) {
    CborBool? cborIsMaster = cborMap[const CborSmallInt(1)] as CborBool?;
    CborBool? cborIsPrivate = cborMap[const CborSmallInt(2)] as CborBool?;
    CborBytes cborKeyData = cborMap[const CborSmallInt(3)] as CborBytes;
    CborBytes? cborChainCode = cborMap[const CborSmallInt(4)] as CborBytes?;
    CborMap? cborUseInfo = cborMap[const CborSmallInt(5)] as CborMap?;
    CborMap? cborOrigin = cborMap[const CborSmallInt(6)] as CborMap?;
    CborMap? cborChildren = cborMap[const CborSmallInt(7)] as CborMap?;
    CborSmallInt? cborParentFingerprint = cborMap[const CborSmallInt(8)] as CborSmallInt?;
    CborString? cborName = cborMap[const CborSmallInt(9)] as CborString?;
    CborString? cborNote = cborMap[const CborSmallInt(10)] as CborString?;

    return CborCryptoHDKey(
      isMaster: cborIsMaster?.value ?? false,
      isPrivate: cborIsPrivate?.value ?? false,
      keyData: Uint8List.fromList(cborKeyData.bytes),
      chainCode: cborChainCode != null ? Uint8List.fromList(cborChainCode.bytes) : null,
      useInfo: cborUseInfo != null ? CborCryptoCoinInfo.fromCborMap(cborUseInfo) : null,
      origin: cborOrigin != null ? CborCryptoKeypath.fromCborMap(cborOrigin) : null,
      children: cborChildren != null ? CborCryptoKeypath.fromCborMap(cborChildren) : null,
      parentFingerprint: cborParentFingerprint?.value,
      name: cborName?.toString(),
      note: cborNote?.toString(),
    );
  }

  @override
  CborMap toCborMap({required bool includeTagBool}) {
    return CborMap.of(
      <CborValue, CborValue>{
        if (isMaster == true) const CborSmallInt(1): CborBool(isMaster),
        if (isPrivate == true) const CborSmallInt(2): CborBool(isPrivate),
        const CborSmallInt(3): CborBytes(Uint8List.fromList(keyData)),
        if (chainCode != null) const CborSmallInt(4): CborBytes(Uint8List.fromList(chainCode!)),
        if (useInfo != null) const CborSmallInt(5): useInfo!.toCborMap(includeTagBool: true),
        if (origin != null) const CborSmallInt(6): origin!.toCborMap(includeTagBool: true),
        if (children != null) const CborSmallInt(7): children!.toCborMap(includeTagBool: true),
        if (parentFingerprint != null) const CborSmallInt(8): CborSmallInt(parentFingerprint!),
        if (name != null) const CborSmallInt(9): CborString(name!),
        if (note != null) const CborSmallInt(10): CborString(note!),
      },
      tags: includeTagBool ? <int>[cborSpecialTag.tag] : <int>[],
    );
  }

  @override
  CborSpecialTag getCborSpecialTag() => cborSpecialTag;

  @override
  List<Object?> get props => <Object?>[isMaster, isPrivate, keyData, chainCode, useInfo, origin, children, parentFingerprint, name, note];
}
