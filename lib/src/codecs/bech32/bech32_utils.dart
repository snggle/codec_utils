import 'package:codec_utils/src/codecs/bech32/bech32_constants.dart';

class Bech32Utils {
  /// Calculates the polymod checksum value for a list of integers [payloadUint5List].
  static int calculatePolymodChecksum(List<int> payloadUint5List) {
    int checksum = 1;
    for (int element in payloadUint5List) {
      int highBit = checksum >> 25;
      checksum = (checksum & 0x1ffffff) << 5 ^ element;
      for (int i = 0; i < Bech32Constants.generatorList.length; i++) {
        if ((highBit >> i) & 1 == 1) {
          checksum ^= Bech32Constants.generatorList[i];
        }
      }
    }
    return checksum;
  }

  /// Expands the human-readable part (HRP) string [hrp] into a list of integers.
  ///
  /// This transformation is required for checksum calculation as defined
  /// in BIP 173. The HRP is split into higher and lower 5-bit groups, separated by a zero delimiter.
  ///
  /// Returns a [resultUint5List] representing the expanded HRP.
  static List<int> expandHrp(String hrp) {
    List<int> resultUint5List = hrp.codeUnits.map((int element) => element >> 5).toList();
    resultUint5List = resultUint5List + <int>[0];
    resultUint5List = resultUint5List + hrp.codeUnits.map((int element) => element & 31).toList();
    return resultUint5List;
  }
}
