// Class was shaped by the influence of several key sources including:
// "blockchain_utils" - Copyright (c) 2010 Mohsen
// https://github.com/mrtnetwork/blockchain_utils/.
//
// BSD 3-Clause License
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'dart:typed_data';

import 'package:codec_utils/src/utils/big_int_utils.dart';
import 'package:crypto/crypto.dart';

/// The [Base58Codec] class is designed for encoding data using the Base58 encoding scheme.
class Base58Codec {
  static const String _bitcoinCheckAlphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

  static String encodeWithChecksum(Uint8List dataBytes) {
    List<int> checksum = _computeChecksum(dataBytes);
    List<int> dataWithChecksum = List<int>.from(<int>[...dataBytes, ...checksum]);
    return encode(Uint8List.fromList(dataWithChecksum));
  }

  static String encode(Uint8List dataBytes) {
    String alphabet = _bitcoinCheckAlphabet;

    BigInt value = BigIntUtils.decode(dataBytes);
    String enc = '';
    while (value > BigInt.zero) {
      BigInt dividedValue = value ~/ BigInt.from(58);
      BigInt modulatedValue = value % BigInt.from(58);

      value = dividedValue;
      enc = alphabet[modulatedValue.toInt()] + enc;
    }

    int zero = 0;
    for (int byte in dataBytes) {
      if (byte == 0) {
        zero++;
      } else {
        break;
      }
    }
    final int leadingZeros = dataBytes.length - (dataBytes.length - zero);

    return (alphabet[0] * leadingZeros) + enc;
  }

  static Uint8List decode(String data) {
    String alphabet = _bitcoinCheckAlphabet;
    BigInt val = BigInt.zero;

    for (int i = 0; i < data.length; i++) {
      String c = data[data.length - 1 - i];
      int charIndex = alphabet.indexOf(c);
      if (charIndex == -1) {
        throw const FormatException('Invalid character in Base58 string');
      }
      val += BigInt.from(charIndex) * BigInt.from(58).pow(i);
    }

    Uint8List bytes = BigIntUtils.changeToBytes(val);

    int padLen = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i] == alphabet[0]) {
        padLen++;
      } else {
        break;
      }
    }

    return Uint8List.fromList(<int>[...List<int>.filled(padLen, 0), ...bytes]);
  }

  static List<int> _computeChecksum(Uint8List dataBytes) {
    Uint8List doubleSha256Digest = Uint8List.fromList(sha256.convert(sha256.convert(dataBytes).bytes).bytes);
    return doubleSha256Digest.sublist(0, 4);
  }
}
