import 'dart:typed_data';

class CompactU16Encoder {
  final List<int> _bytes;

  CompactU16Encoder() : _bytes = <int>[];

  static Uint8List encode(int value) {
    if (value == 0) {
      return Uint8List.fromList(<int>[0]);
    }

    List<int> bytes = <int>[];
    int rawValue = value;
    while (true) {
      int byte = rawValue & 0x7F;
      rawValue >>= 7;

      bytes.add(rawValue == 0 ? byte : byte | 0x80);
      if (rawValue == 0) {
        break;
      }
    }
    return Uint8List.fromList(bytes);
  }

  Uint8List toBytes() => Uint8List.fromList(_bytes);
}
