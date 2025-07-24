// This class was primarily influenced by:
// Copyright 2020 Harm Aarts
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/bech32/bech32_constants.dart';
import 'package:codec_utils/src/codecs/bech32/bech32_utils.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_bech32_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_hrp_exception.dart';

/// A utility class for encoding [Bech32] objects into valid Bech32 strings.
///
/// This encoder converts a [Bech32] instance (which contains a human-readable part (HRP)
/// and a data payload) into a properly formatted Bech32 string, as specified in
/// BIP 173 and BIP 350.
class Bech32Encoder {
  /// Encodes a [Bech32] object [bech32] into a valid Bech32 string.
  String encode(Bech32 bech32, [int maxLength = Bech32Constants.maxInputLength]) {
    String hrp = bech32.hrp.toLowerCase();
    List<int> uint5List = bech32.uint5List;
    int length = hrp.length + uint5List.length + Bech32Constants.separator.length + Bech32Constants.checksumLength;

    if (length > maxLength) {
      throw InvalidBech32Exception('Bech32 is too long: ${hrp.length + uint5List.length + 1 + Bech32Constants.checksumLength}');
    }

    if (hrp.isEmpty) {
      throw InvalidHrpException('HRP is empty');
    }

    List<int> checkSummedListUint5List = uint5List + _createChecksum(hrp, uint5List);

    return hrp + Bech32Constants.separator + checkSummedListUint5List.map((int element) => Bech32Constants.charList[element]).join();
  }

  /// Computes a 6-byte checksum for the given [hrp] and [uint5List],
  /// following Bech32 checksum rules (BIP 173).
  ///
  /// Returns a [Uint8List] representing the 6 checksum bytes.
  List<int> _createChecksum(String hrp, List<int> uint5List) {
    List<int> payloadUint5List = Bech32Utils.expandHrp(hrp) + uint5List + <int>[0, 0, 0, 0, 0, 0];
    int polymodValue = Bech32Utils.calculatePolymodChecksum(payloadUint5List) ^ 1;

    List<int> checksumUint5List = <int>[0, 0, 0, 0, 0, 0];

    for (int i = 0; i < checksumUint5List.length; i++) {
      checksumUint5List[i] = (polymodValue >> (5 * (5 - i))) & 31;
    }
    return checksumUint5List;
  }
}
