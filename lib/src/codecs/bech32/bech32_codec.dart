import 'dart:typed_data';

import 'package:codec_utils/src/codecs/bech32/bech32_decoder.dart';
import 'package:codec_utils/src/codecs/bech32/bech32_encoder.dart';
import 'package:codec_utils/src/codecs/bech32/bech32_pair.dart';

/// The [Bech32Codec] class is designed for encoding data using the Bech32 encoding scheme.
/// The specification for Bech32 encoding can be found in BIP-0173 and BIP-0350:
/// https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki
/// https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki
class Bech32Codec {
  static String encode(Bech32Pair bech32pair) {
    Uint8List convertedData = _convertBits(bech32pair.data, 8, 5);
    // TODO(dominik): Implement custom Bech32 encoding
    return Bech32Encoder().convert(Bech32Pair(hrp: bech32pair.hrp, data: convertedData));
  }

  static Bech32Pair decode(String bechAddress) {
    Bech32Pair decodedBech32 = Bech32Decoder().convert(bechAddress);
    Uint8List convertedData = _convertBits(decodedBech32.data, 5, 8, padBool: false);

    return Bech32Pair(data: convertedData, hrp: decodedBech32.hrp);
  }

  static Uint8List _convertBits(
    List<int> data,
    int startBitIndex,
    int endBitIndex, {
    bool padBool = true,
  }) {
    int acc = 0;
    int bits = 0;
    List<int> result = <int>[];
    int maxV = (1 << endBitIndex) - 1;

    for (int v in data) {
      if (v < 0 || (v >> startBitIndex) != 0) {
        throw Exception('Got address byte smaller than zero or greater than 2^startBitIndex');
      }
      acc = (acc << startBitIndex) | v;
      bits += startBitIndex;
      while (bits >= endBitIndex) {
        bits -= endBitIndex;
        result.add((acc >> bits) & maxV);
      }
    }

    if (padBool) {
      if (bits > 0) {
        result.add((acc << (endBitIndex - bits)) & maxV);
      }
    } else if (bits >= startBitIndex) {
      throw Exception('Illegal zero padding');
    } else if (((acc << (endBitIndex - bits)) & maxV) != 0) {
      throw Exception('Non zero');
    }

    return Uint8List.fromList(result);
  }
}
