/// Represents various special tags used in CBOR (Concise Binary Object Representation).
/// Each tag is associated with a specific type and numerical identifier.
enum CborSpecialTag {
  uuid(type: 'uuid', tag: 37),
  cryptoHDKey(type: 'crypto-hdkey', tag: 303),
  cryptoKeypath(type: 'crypto-keypath', tag: 304),
  cryptoCoinInfo(type: 'crypto-coin-info', tag: 305),

  // ETH
  ethSignRequest(type: 'eth-sign-request', tag: 401),
  ethSignature(type: 'eth-signature', tag: 402);

  final String type;
  final int tag;

  const CborSpecialTag({
    required this.type,
    required this.tag,
  });

  factory CborSpecialTag.fromTag(int tag) {
    return CborSpecialTag.values.firstWhere((CborSpecialTag type) => type.tag == tag);
  }

  factory CborSpecialTag.fromType(String value) {
    return CborSpecialTag.values.firstWhere((CborSpecialTag type) => type.type == value);
  }
}
