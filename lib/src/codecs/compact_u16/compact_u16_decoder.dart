import 'dart:typed_data';

/// CompactU16 is a compact, variable-length encoding for 16-bit unsigned integers (u16).
/// It is designed to save space when serializing small integers by using fewer bytes for smaller values.
/// The implementation is inspired by the variable-length quantity (VLQ) encoding used in formats like Protocol Buffers.
///
/// Code partially based on:
/// https://github.com/espresso-cash/espresso-cash-public/blob/master/packages/solana/lib/src/encoder/compact_u16.dart
/// https://github.com/anza-xyz/agave/blob/v2.1.13/short-vec/src/lib.rs
class CompactU16Decoder {
  /// Determines how many bytes are used to represent a compact value.
  static int decodeLength(Uint8List bytes, int offset) {
    int length = 0;
    while (offset + length < bytes.length) {
      int byte = bytes[offset + length];
      length++;
      if ((byte & 0x80) == 0) {
        break;
      }
    }
    return length;
  }

  /// Decodes the actual integer value from [bytes] starting at [offset] with known [length].
  static int decodeValue(Uint8List bytes, int offset, int length) {
    int result = 0;
    int shift = 0;
    for (int i = 0; i < length; i++) {
      int byte = bytes[offset + i];
      result |= (byte & 0x7F) << shift;
      shift += 7;
    }
    return result;
  }
}
