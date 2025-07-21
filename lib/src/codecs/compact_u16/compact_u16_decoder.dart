import 'package:codec_utils/src/codecs/byte_reader/byte_reader.dart';

/// CompactU16 is a compact, variable-length encoding for 16-bit unsigned integers (u16).
/// It is designed to save space when serializing small integers by using fewer bytes for smaller values.
/// The implementation is inspired by the variable-length quantity (VLQ) encoding used in formats like Protocol Buffers.
///
/// Code partially based on:
/// https://github.com/espresso-cash/espresso-cash-public/blob/master/packages/solana/lib/src/encoder/compact_u16.dart
/// https://github.com/anza-xyz/agave/blob/v2.1.13/short-vec/src/lib.rs
class CompactU16Decoder {
  static const int _maxCompactU16EncodingLength = 3;

  /// Decodes the actual integer value from [bytes] starting at [offset] with known [length].
  static int decode(ByteReader byteReader) {
    int value = 0;
    int size = 0;
    int shift = 0;
    try {
      for (int i = 0; i < _maxCompactU16EncodingLength; i++) {
        int elem = byteReader.rightShift();
        if (elem == 0 && i != 0) {
          throw Exception('alias (leading zero on non-first byte)');
        }
        if (i == _maxCompactU16EncodingLength - 1 && (elem & 0x80) != 0) {
          throw Exception('Attempted to read past the third byte');
        }
        value |= (elem & 0x7F) << shift;
        size++;
        shift += 7;
        if ((elem & 0x80) == 0) {
          break;
        }
      }

      if (size == 0 || size > _maxCompactU16EncodingLength) {
        throw Exception('Invalid CompactU16 size: $size');
      }
      if (value < 0 || value > 0xFFFF) {
        throw Exception('Invalid CompactU16 length: $value');
      }
    } catch (e) {
      byteReader.leftShiftBy(size);
      rethrow;
    }
    return value;
  }
}
