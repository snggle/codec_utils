import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/src/codecs/cbor/a_cbor_tagged_object.dart';
import 'package:codec_utils/src/codecs/cbor/cbor_special_tag.dart';
import 'package:codec_utils/src/codecs/cbor/crypto/cbor_crypto_hd_key.dart';

/// For Solana, crypto-multi-accounts exposes the public keys.
/// This data may be used to generate the desired addresses.
/// Wallets like Solflare may retrieve and parse this data from the animated QR Code we display.
///
/// There is a discrepancy between the Keystone documentation (link below) showing the parameter masterFingerprint as required
/// and our testing results which revealed Solflare actually only requires cryptoHDKeyList.
/// There is no information on how null values should be handled or what would happen if we received them.
///
/// https://dev.keyst.one/docs/integration-tutorial-advanced/solana#connect-with-keystone
class CborCryptoMultiAccounts extends ACborTaggedObject {
  static const CborSpecialTag cborSpecialTag = CborSpecialTag.cryptoMultiAccounts;

  /// A 4 bytes hex string indicates the current mnemonic, e.g. 'f23f9fd2'
  final String? masterFingerprint;

  /// An array of extended public keys
  final List<CborCryptoHDKey> cryptoHDKeyList;

  /// The device name, e.g. 'Keystone'
  final String? device;

  /// The device id, e.g. '28475c8d80f6c06bafbe46a7d1750f3fcf2565f7'
  final String? deviceId;

  /// The device firmware version, e.g. '1.0.2'
  final String? deviceVersion;

  const CborCryptoMultiAccounts({
    required this.cryptoHDKeyList,
    this.masterFingerprint,
    this.device,
    this.deviceId,
    this.deviceVersion,
  });

  factory CborCryptoMultiAccounts.fromSerializedCbor(Uint8List serializedCbor) {
    CborMap cborMap = cborDecode(serializedCbor) as CborMap;
    return CborCryptoMultiAccounts.fromCborMap(cborMap);
  }

  factory CborCryptoMultiAccounts.fromCborMap(CborMap cborMap) {
    CborString? cborFingerprint = cborMap[const CborSmallInt(1)] as CborString?;
    CborList? cborCryptoHDKeyList = cborMap[const CborSmallInt(2)] as CborList?;
    CborString? cborDevice = cborMap[const CborSmallInt(3)] as CborString?;
    CborString? cborDeviceId = cborMap[const CborSmallInt(4)] as CborString?;
    CborString? cborVersion = cborMap[const CborSmallInt(5)] as CborString?;

    return CborCryptoMultiAccounts(
      masterFingerprint: cborFingerprint?.toString(),
      cryptoHDKeyList: cborCryptoHDKeyList?.whereType<CborMap>().map(CborCryptoHDKey.fromCborMap).toList() ?? <CborCryptoHDKey>[],
      device: cborDevice?.toString(),
      deviceId: cborDeviceId?.toString(),
      deviceVersion: cborVersion?.toString(),
    );
  }

  @override
  CborMap toCborMap({required bool includeTagBool}) {
    return CborMap.of(
      <CborValue, CborValue>{
        if (masterFingerprint != null) const CborSmallInt(1): CborString(masterFingerprint!),
        const CborSmallInt(2): CborList(
          cryptoHDKeyList.map((CborCryptoHDKey cryptoHDKey) => cryptoHDKey.toCborMap(includeTagBool: true)).toList(),
        ),
        if (device != null) const CborSmallInt(3): CborString(device!),
        if (deviceId != null) const CborSmallInt(4): CborString(deviceId!),
        if (deviceVersion != null) const CborSmallInt(5): CborString(deviceVersion!),
      },
      tags: includeTagBool ? <int>[cborSpecialTag.tag] : <int>[],
    );
  }

  @override
  CborSpecialTag getCborSpecialTag() => cborSpecialTag;

  @override
  List<Object?> get props => <Object?>[masterFingerprint, cryptoHDKeyList, device, deviceId, deviceVersion];
}
