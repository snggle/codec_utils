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
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_witness_program_exception.dart';
import 'package:codec_utils/src/codecs/bech32/exceptions/invalid_witness_version_exception.dart';
import 'package:codec_utils/src/utils/bytes_utils.dart';

/// A utility class for encoding Segregated Witness (SegWit) data
/// into a Bech32-encoded address string.
///
/// This encoder takes a [SegWit] object and converts it into a valid
/// Bech32 address string following BIP 173 and BIP 350 specifications.
///
/// ## Validation steps
///
/// Before encoding, the encoder validates:
/// - The witness version is within the valid range (0–16).
/// - The witness program is neither too short nor too long.
/// - The witness program length is compatible with the specified version.
///
/// ## Encoding process
///
/// - Converts the witness program from 8-bit bytes to 5-bit groups (Bech32 data part).
/// - Prefixes the data list with the witness version.
/// - Encodes the final data list together with the human-readable part (HRP)
///   into a Bech32 address string.
class SegWitEncoder {
  String encode(SegWit segWit) {
    int witnessVersion = segWit.witnessVersion;
    Uint8List witnessProgramUint8List = segWit.witnessProgramUint8List;
    if (witnessVersion > 16) {
      throw InvalidWitnessVersionException('Witness version is invalid $witnessVersion');
    }
    if (witnessProgramUint8List.length < 2) {
      throw InvalidWitnessProgramException('Witness program is too short ${witnessProgramUint8List.length}');
    }
    if (witnessProgramUint8List.length > 40) {
      throw InvalidWitnessProgramException('Witness program is too long ${witnessProgramUint8List.length}');
    }
    if (witnessVersion == 0 && (witnessProgramUint8List.length != 20 && witnessProgramUint8List.length != 32)) {
      throw InvalidWitnessProgramException(
          'Program version $witnessVersion and length of witness program ${witnessProgramUint8List.length} are invalid');
    }
    List<int> dataUint5List = BytesUtils.convertBits(witnessProgramUint8List, 8, 5, allowPaddingBool: true);

    List<int> finalUint5List = <int>[witnessVersion] + dataUint5List;

    return Bech32Encoder().encode(Bech32.fromUint5List(segWit.hrp, finalUint5List));
  }
}
