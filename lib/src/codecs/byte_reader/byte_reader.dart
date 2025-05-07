import 'dart:typed_data';

/// A helper class used for sequential reading of bytes from a [Uint8List] with [_offset] tracking.
class ByteReader {
  final Uint8List data;
  int _offset = 0;

  ByteReader(this.data);

  int get offset => _offset;

  /// Moves the [_offset] backward by [count] bytes.
  void shiftLeftBy(int count) {
    if (_offset < count) {
      throw Exception('Offset out of bounds');
    }
    _offset -= count;
  }

  /// Reads 1 byte the at current [_offset] and moves the [_offset] forward by 1 byte.
  int shiftRight() => shiftRightBy(1)[0];

  /// Reads [count] bytes starting at the current [_offset] and moves the [_offset] forward by [count] bytes.
  Uint8List shiftRightBy(int count) {
    if (_offset + count > data.length) {
      throw Exception('Offset out of bounds');
    }
    Uint8List bytes = data.sublist(_offset, _offset + count);
    _offset += count;
    return bytes;
  }
}
