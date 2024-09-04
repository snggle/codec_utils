import 'dart:typed_data';

/// The [HexCodec] class is designed for encoding and decoding data using the hexadecimal encoding scheme.
class HexCodec {
  /// Encodes the given [data] as a hexadecimal string.
  static String encode(List<int> data, {bool lowercaseBool = true}) {
    List<String> hexString = data.map((int e) => e.toRadixString(16).padLeft(2, '0')).toList();
    String hexData = hexString.join();

    if (lowercaseBool) {
      return hexData.toLowerCase();
    } else {
      return hexData.toUpperCase();
    }
  }

  /// Decodes the given [hex] string into a list of bytes.
  static Uint8List decode(String hex) {
    String tmpHex = hex.toLowerCase();
    if (hex.startsWith('0x')) {
      tmpHex = hex.substring(2);
    }
    List<String> hexString = tmpHex.split('');
    List<String> hexPairs = <String>[];

    for (int i = 0; i < hexString.length; i += 2) {
      String hexPair = hexString[i] + hexString[i + 1];
      hexPairs.add(hexPair);
    }

    List<int> hexPairsInt = hexPairs.map((String e) => int.parse(e, radix: 16)).toList();
    Uint8List hexPairsUint8List = Uint8List.fromList(hexPairsInt);

    return hexPairsUint8List;
  }
}
