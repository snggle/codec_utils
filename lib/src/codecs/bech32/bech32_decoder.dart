// This class was primarily influenced by:
// Copyright 2020 Harm Aarts
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/bech32/bech32_constants.dart';
import 'package:codec_utils/src/codecs/bech32/bech32_utils.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_bech32_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_checksum_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_hrp_exception.dart';

/// A utility class for decoding Bech32-encoded strings into [Bech32] objects.
///
/// This decoder validates and parses a Bech32 string into its human-readable part (HRP)
/// and data payload, following the specifications described in BIP 173 and BIP 350.
class Bech32Decoder {
  Bech32 decode(String bechAddress, [int maxInputLength = Bech32Constants.maxInputLength]) {
    if (bechAddress.length > maxInputLength) {
      throw InvalidBech32Exception('Bech32 is too long: ${bechAddress.length} > 90');
    }
    if (bechAddress.toLowerCase() != bechAddress && bechAddress.toUpperCase() != bechAddress) {
      throw InvalidBech32Exception('Bech32 input must be either all lowercase or all uppercase: $bechAddress');
    }
    if (bechAddress.lastIndexOf(Bech32Constants.separator) == -1) {
      throw InvalidBech32Exception('Bech32 string is missing the required separator between HRP and data');
    }

    int separatorPosition = bechAddress.lastIndexOf(Bech32Constants.separator);

    if (bechAddress.length - separatorPosition - 1 - Bech32Constants.checksumLength < 0) {
      throw InvalidChecksumException('Checksum is too short: ${bechAddress.length} < 6');
    }

    if (separatorPosition == 0) {
      throw InvalidHrpException('HRP is too short: $separatorPosition');
    }

    String normalizedInput = bechAddress.toLowerCase();

    String hrp = normalizedInput.substring(0, separatorPosition);
    String data = normalizedInput.substring(separatorPosition + 1, bechAddress.length - Bech32Constants.checksumLength);
    String checksum = normalizedInput.substring(bechAddress.length - Bech32Constants.checksumLength);

    if (hrp.codeUnits.any((int element) => element < 33 || element > 126)) {
      throw InvalidHrpException('HRP contains invalid characters: $hrp');
    }

    List<int> uint5List = data.split('').map((String element) {
      return Bech32Constants.charList.indexOf(element);
    }).toList();

    if (uint5List.any((int element) => element == -1)) {
      throw InvalidBech32Exception('Bech32 has undefined character: ${data[uint5List.indexOf(-1)]}');
    }

    List<int> checksumUint5List = checksum.split('').map((String element) {
      return Bech32Constants.charList.indexOf(element);
    }).toList();

    if (checksumUint5List.any((int element) => element == -1)) {
      int invalidIndex = checksumUint5List.indexOf(-1);
      throw InvalidChecksumException('Checksum contains undefined character at position: ${checksumUint5List[invalidIndex]}');
    }

    List<int> expandedHrpUint5List = Bech32Utils.expandHrp(hrp);

    if (Bech32Utils.calculatePolymodChecksum(expandedHrpUint5List + (uint5List + checksumUint5List)) != 1) {
      throw InvalidChecksumException('Checksum verification failed for input: $bechAddress');
    }

    return Bech32.fromUint5List(hrp, uint5List);
  }
}
