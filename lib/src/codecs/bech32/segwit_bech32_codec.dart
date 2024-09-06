import 'dart:typed_data';

import 'package:bech32/bech32.dart';

/// The [SegwitBech32Codec] class is designed for encoding Segregated Witness (SegWit) addresses using the Bech32 encoding scheme,
/// as outlined in BIP-0173 and further refined for SegWit in BIP-0174:
/// https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki
/// https://github.com/bitcoin/bips/blob/master/bip-0174.mediawiki
class SegwitBech32Codec {
  static String encode(String hrp, int witnessVersion, List<int> witnessProgram) {
    // TODO(dominik): Implement custom Segwit encoder
    return const SegwitCodec().encode(Segwit(hrp, witnessVersion, witnessProgram));
  }

  static Uint8List decode(String bechAddress) {
    // TODO(dominik): Implement custom Segwit decoder
    return Uint8List.fromList(const SegwitCodec().decode(bechAddress).program);
  }
}
