import 'dart:typed_data';

import 'package:codec_utils/src/codecs/compact_u16/compact_u16.dart';

/// A utility class for sequentially reading binary data.
/// Supports decoding [CompactU16] values.
class ByteReader {
  final Uint8List bytes;
  int offset = 0;

  /// Creates a new [ByteReader] for the given [bytes].
  ByteReader(this.bytes);

  /// Reads a single byte from the current offset.
  int readByte() => readBytes(1)[0];

  /// Reads a [numberOfBytes] bytes from the current offset and increments the offset.
  Uint8List readBytes(int numberOfBytes) {
    if (offset + numberOfBytes > bytes.length) {
      throw RangeError('Offset $offset + $numberOfBytes out of bounds.');
    }
    Uint8List readBytes = bytes.sublist(offset, offset + numberOfBytes);
    _incrementOffset(numberOfBytes);
    return readBytes;
  }

  /// Returns the number of bytes used to represent the next [CompactU16] value.
  /// Does NOT increment the offset.
  int decodeCompactU16Length() {
    return CompactU16.decodeLength(bytes, offset);
  }

  /// Decodes a [CompactU16] value from the current position.
  /// Increments the offset past the currently encoded integer.
  int decodeCompactU16Value() {
    final int length = decodeCompactU16Length();
    final int value = CompactU16.decodeValue(bytes, offset, length);
    offset += length;
    return value;
  }

  int _incrementOffset(int numberOfBytes) {
    return offset += numberOfBytes;
  }
}
