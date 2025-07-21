import 'dart:typed_data';

class ByteReader {
  final Uint8List data;
  int _offset = 0;

  ByteReader(this.data);

  void leftShiftBy(int count) {
    if (_offset < count) {
      throw RangeError('Offset out of bounds');
    }
    _offset -= count;
  }

  int rightShift() => rightShiftBy(1)[0];

  Uint8List rightShiftBy(int count) {
    if (_offset + count > data.length) {
      throw RangeError('Offset out of bounds');
    }
    Uint8List bytes = data.sublist(_offset, _offset + count);
    _offset += count;
    return bytes;
  }

  int get offset => _offset;
}
