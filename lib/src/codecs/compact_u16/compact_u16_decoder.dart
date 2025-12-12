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

  /// Decodes the first actual integer value from [byteReader], starting at its current [offset].
  static int decode(ByteReader byteReader) {
    int value = 0;
    int size = 0;
    int shift = 0;
    try {
      for (int i = 0; i < _maxCompactU16EncodingLength; i++) {
        int elem = byteReader.shiftRight();
        size++;
        if (elem == 0 && i != 0) {
          throw Exception('Zero byte found beyond first position');
        }
        if (i == _maxCompactU16EncodingLength - 1 && (elem & 0x80) != 0) {
          throw Exception('Attempted to read past the third byte');
        }
        value |= (elem & 0x7F) << shift;
        shift += 7;
        if ((elem & 0x80) == 0) {
          break;
        }
      }
    } catch (e) {
      byteReader.shiftLeftBy(size);
      rethrow;
    }
    return value;
  }
}
