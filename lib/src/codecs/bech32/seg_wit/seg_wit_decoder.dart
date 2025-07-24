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
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_hrp_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_witness_program_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_witness_version_exception.dart';
import 'package:codec_utils/src/utils/bytes_utils.dart';

/// A utility class for decoding Segregated Witness (SegWit) addresses encoded in Bech32 format.
///
/// The [SegWitDecoder] class provides method to parse a Bech32-encoded string
/// and extract its SegWit-specific fields: human-readable part (HRP), witness version,
/// and witness program (programList).
///
/// The decoder performs steps to ensure the address conforms to
/// BIP 173 and BIP 350 specifications:
///
/// - Verifies that the HRP is supported "bc" for mainnet, "tb" for testnet).
/// - Checks that the witness version is within the valid range (0–16).
/// - Converts the data part from 5-bit groups (Bech32) to 8-bit groups (program data).
/// - Validates that the witness program has an allowed length and structure depending on its version.
///
class SegWitDecoder {
  SegWit decode(String input) {
    Bech32 decodedBech32 = Bech32Decoder().decode(input);

    List<int> convertedUint5List = BytesUtils.convertBits(decodedBech32.uint8List, 8, 5);

    if (decodedBech32.hrp != 'bc' && decodedBech32.hrp != 'tb') {
      throw InvalidHrpException('Invalid hrp ${decodedBech32.hrp}');
    }
    if (convertedUint5List.isEmpty) {
      throw const FormatException('Empty data');
    }

    int witnessVersion = convertedUint5List[0];

    if (witnessVersion > 16) {
      throw InvalidWitnessVersionException('Invalid witness version $witnessVersion');
    }

    Uint8List witnessProgramUint8List = BytesUtils.convertBits(convertedUint5List.sublist(1), 5, 8, allowPaddingBool: false);

    if (witnessProgramUint8List.length < 2) {
      throw InvalidWitnessProgramException('Too short program');
    }
    if (witnessProgramUint8List.length > 40) {
      throw InvalidWitnessProgramException('Too long program');
    }
    if (witnessVersion == 0 && (witnessProgramUint8List.length != 20 && witnessProgramUint8List.length != 32)) {
      throw InvalidWitnessProgramException('Invalid version $witnessVersion and invalid program length ${witnessProgramUint8List.length}');
    }

    return SegWit(decodedBech32.hrp, witnessVersion, witnessProgramUint8List);
  }
}
