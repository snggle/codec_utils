import 'dart:typed_data';

/// CompactU16 is a compact, variable-length encoding for 16-bit unsigned integers (u16).
/// It is designed to save space when serializing small integers by using fewer bytes for smaller values.
/// The implementation is inspired by the variable-length quantity (VLQ) encoding used in formats like Protocol Buffers.
///
/// Code partially based on:
/// https://github.com/espresso-cash/espresso-cash-public/blob/master/packages/solana/lib/src/encoder/compact_u16.dart
/// https://github.com/anza-xyz/agave/blob/v2.1.13/short-vec/src/lib.rs
class CompactU16 {
  final List<int> _bytes;

  /// Creates a CompactU16 from a [int] value.
  factory CompactU16(int value) {
    if (value == 0) {
      return zero;
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

    return CompactU16.fromBytes(bytes);
  }

  /// Creates a CompactU16 directly from bytes.
  const CompactU16.fromBytes(this._bytes);

  /// Determines how many bytes are used to represent a compact value.
  static int decodeLength(Uint8List data, int offset) {
    int length = 0;
    while (offset + length < data.length) {
      int byte = data[offset + length];
      length++;
      if ((byte & 0x80) == 0) {
        break;
      }
    }
    return length;
  }

  /// Decodes the actual integer value from [data] starting at [offset] with known [length].
  static int decodeValue(Uint8List data, int offset, int length) {
    int result = 0;
    int shift = 0;
    for (int i = 0; i < length; i++) {
      int byte = data[offset + i];
      result |= (byte & 0x7F) << shift;
      shift += 7;
    }
    return result;
  }

  int get value {
    int result = 0;
    int shift = 0;

    for (int byte in _bytes) {
      result |= (byte & 0x7F) << shift;
      if ((byte & 0x80) == 0) {
        break;
      }
      shift += 7;
    }

    return result;
  }

  int get size => _bytes.length;

  Uint8List toBytes() => Uint8List.fromList(_bytes);

  static const CompactU16 zero = CompactU16.fromBytes(<int>[0]);
}
