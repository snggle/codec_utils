// Class was shaped by the influence of several key sources including:
// "rlp" Copyright (c) 2018 Max Holman <max@holmn.com>
// https://github.com/maxholman/rlp/
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
part of 'rlp_codec.dart';

/// A utility class providing static methods related to the Recursive Length Prefix (RLP) encoding.
class RLPUtils {
  /// Encodes the length of a data element as part of the RLP encoding process. This method is used to determine
  /// how many bytes are needed to represent the length of the data and to prepend the appropriate prefix according
  /// to the RLP specification.
  static Uint8List encodeLength(int length, int offset) {
    if (length < 56) {
      return Uint8List.fromList(<int>[length + offset]);
    } else {
      Uint8List binaryLength = _convertLengthToBytes(length);
      return Uint8List.fromList(<int>[binaryLength.length + offset + 55, ...binaryLength]);
    }
  }

  /// Converts the specified length to a list of bytes.
  static Uint8List _convertLengthToBytes(int length) {
    if (length == 0) {
      return Uint8List(0);
    }
    return Uint8List.fromList(<int>[..._convertLengthToBytes(length ~/ 256), (length % 256)]);
  }
}
