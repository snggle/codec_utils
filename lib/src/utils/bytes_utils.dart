import 'dart:typed_data';

class BytesUtils {
  /// Converts a list of integers from one bit-grouping to another.
  ///
  /// This is operation is used to convert between 8-bit bytes and 5-bit groups.
  ///
  /// - [inputBytesList]: The input list of integers (e.g., 8-bit bytes or 5-bit groups).
  /// - [inputBitLength]: The bit length of each element in [dataList] (e.g., 8 for bytes, 5 for Bech32).
  /// - [outputBitLength]: The desired bit length of each element in the output list (e.g., 5 for Bech32, 8 for bytes).
  /// - [padBool]: If `true`, the result will be padded with zeros to ensure all bits are consumed.
  ///   If `false`, padding is disallowed, and an error will be thrown if excess
  static Uint8List convertBits(List<int> inputBytesList, int inputBitLength, int outputBitLength, {bool allowPaddingBool = true}) {
    int acc = 0;
    int bits = 0;
    List<int> outputBytesList = <int>[];
    int outputBitMask = (1 << outputBitLength) - 1;

    for (int inputByte in inputBytesList) {
      if (inputByte < 0 || (inputByte >> inputBitLength) != 0) {
        throw FormatException('Invalid value $inputBitLength');
      }
      acc = (acc << inputBitLength) | inputByte;
      bits += inputBitLength;
      while (bits >= outputBitLength) {
        bits -= outputBitLength;
        outputBytesList.add((acc >> bits) & outputBitMask);
      }
    }
    if (allowPaddingBool) {
      if (bits > 0) {
        outputBytesList.add((acc << (outputBitLength - bits)) & outputBitMask);
      } else if (bits >= inputBitLength) {
        throw const FormatException('Excess bits require padding, but padding is disallowed.');
      } else if (((acc << (outputBitLength - bits)) & outputBitMask) != 0) {
        throw const FormatException('Non-zero padding bits detected.');
      }
    }
    return Uint8List.fromList(outputBytesList);
  }
}
