import 'dart:typed_data';

class BigIntUtils {
  static Uint8List changeToBytes(BigInt value, {int? length, Endian order = Endian.big}) {
    int byteLength = length ?? _calculateByteLength(value);

    BigInt updatedValue = value;
    BigInt bigMaskEight = BigInt.from(0xff);
    if (updatedValue == BigInt.zero) {
      return Uint8List.fromList(List<int>.filled(byteLength, 0));
    }
    List<int> byteList = List<int>.filled(byteLength, 0);
    for (int i = 0; i < byteLength; i++) {
      byteList[byteLength - i - 1] = (updatedValue & bigMaskEight).toInt();
      updatedValue = updatedValue >> 8;
    }

    if (order == Endian.little) {
      byteList = byteList.reversed.toList();
    }

    return Uint8List.fromList(byteList);
  }

  static BigInt decode(List<int> bytes, {int? bitLength, Endian order = Endian.big}) {
    List<int> tmpBytes = bytes;
    if (order == Endian.little) {
      tmpBytes = List<int>.from(bytes.reversed.toList());
    }

    int bytesBitLength = tmpBytes.length * 8;

    BigInt result = BigInt.zero;
    for (int i = 0; i < tmpBytes.length; i++) {
      result += BigInt.from(tmpBytes[tmpBytes.length - i - 1]) << (8 * i);
    }

    if (bitLength != null && bytesBitLength >= bitLength) {
      result >>= bytesBitLength - bitLength;
    }
    return result;
  }

  static int _calculateByteLength(BigInt value) {
    String valueHex = value.toRadixString(16);
    int byteLength = (valueHex.length + 1) ~/ 2;
    return byteLength;
  }
}
