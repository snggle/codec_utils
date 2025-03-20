//This class was primarily influenced by:
// Copyright 2015, the Dart project authors.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
// * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following
// disclaimer in the documentation and/or other materials provided
// with the distribution.
// * Neither the name of Google LLC nor the names of its
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
import 'dart:typed_data';

import 'package:codec_utils/src/utils/sha/hash/a_hash_sink.dart';
import 'package:codec_utils/src/utils/sha/hash/digest.dart';

/// [ASha32BitSink] provides hashing logic for SHA256. It processes input data in 512-bit chunks, expanding them into a 64-entry message schedule using bitwise operations. The class applies transformations, including bit rotations, modular additions, and logical operations.
abstract class ASha32BitSink extends AHashSink {
  static const List<int> _roundConstantsList = <int>[
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, //
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
  ];

  final Uint32List _extendedUint32List = Uint32List(64);
  final Uint32List _digestUint32List;

  ASha32BitSink(Sink<Digest> sink, this._digestUint32List) : super(sink, 16);

  @override
  Uint32List get digestUint32List => _digestUint32List;

  @override
  void updateHash(Uint32List inputUint32List) {
    for (int i = 0; i < 16; i++) {
      _extendedUint32List[i] = inputUint32List[i];
    }
    for (int i = 16; i < 64; i++) {
      _extendedUint32List[i] = _applyAdd32(_applyAdd32(_applySmallSigma1(_extendedUint32List[i - 2]), _extendedUint32List[i - 7]),
          _applyAdd32(_applySmallSigma0(_extendedUint32List[i - 15]), _extendedUint32List[i - 16]));
    }

    int aHash = _digestUint32List[0];
    int bHash = _digestUint32List[1];
    int cHash = _digestUint32List[2];
    int dHash = _digestUint32List[3];
    int eHash = _digestUint32List[4];
    int fHash = _digestUint32List[5];
    int gHash = _digestUint32List[6];
    int hHash = _digestUint32List[7];

    for (int i = 0; i < 64; i++) {
      int tmp1 = _applyAdd32(_applyAdd32(hHash, _applyBigSigma1(eHash)),
          _applyAdd32(_applyChoiceBits(eHash, fHash, gHash), _applyAdd32(_roundConstantsList[i], _extendedUint32List[i])));

      int tmp2 = _applyAdd32(_applyBigSigma0(aHash), _applyMajorityBits(aHash, bHash, cHash));

      hHash = gHash;
      gHash = fHash;
      fHash = eHash;
      eHash = _applyAdd32(dHash, tmp1);
      dHash = cHash;
      cHash = bHash;
      bHash = aHash;
      aHash = _applyAdd32(tmp1, tmp2);
    }
    _digestUint32List[0] = _applyAdd32(aHash, _digestUint32List[0]);
    _digestUint32List[1] = _applyAdd32(bHash, _digestUint32List[1]);
    _digestUint32List[2] = _applyAdd32(cHash, _digestUint32List[2]);
    _digestUint32List[3] = _applyAdd32(dHash, _digestUint32List[3]);
    _digestUint32List[4] = _applyAdd32(eHash, _digestUint32List[4]);
    _digestUint32List[5] = _applyAdd32(fHash, _digestUint32List[5]);
    _digestUint32List[6] = _applyAdd32(gHash, _digestUint32List[6]);
    _digestUint32List[7] = _applyAdd32(hHash, _digestUint32List[7]);
  }

  int _applyChoiceBits(int xHash, int yHash, int zHash) {
    return (xHash & yHash) ^ ((~xHash & AHashSink.mask32) & zHash);
  }

  int _applyMajorityBits(int xHash, int yHash, int zHash) {
    return (xHash & yHash) ^ (xHash & zHash) ^ (yHash & zHash);
  }

  int _applyBigSigma0(int bits) {
    return _rotationRight32(2, bits) ^ _rotationRight32(13, bits) ^ _rotationRight32(22, bits);
  }

  int _applyBigSigma1(int bits) {
    return _rotationRight32(6, bits) ^ _rotationRight32(11, bits) ^ _rotationRight32(25, bits);
  }

  int _applySmallSigma0(int bits) {
    return _rotationRight32(7, bits) ^ _rotationRight32(18, bits) ^ (bits >> 3);
  }

  int _applySmallSigma1(int bits) {
    return _rotationRight32(17, bits) ^ _rotationRight32(19, bits) ^ (bits >> 10);
  }

  int _applyAdd32(int hash, int operand) {
    return (hash + operand) & AHashSink.mask32;
  }

  int _rotationRight32(int bits, int value) {
    return (value >> bits) | ((value << (32 - bits)) & AHashSink.mask32);
  }
}
