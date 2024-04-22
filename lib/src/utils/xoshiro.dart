// Class was shaped by the influence of JavaScript key sources including:
// "bc-ur" Copyright (c) 2021 NGRAVE
// https://github.com/ngraveio/bc-ur
//
// MIT License
//
// Copyright (c) 2021 NGRAVE
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

import 'dart:math';

import 'package:crypto/crypto.dart';

/// Implements the Xoshiro (xor/shift/rotate) pseudorandom number generator.
class Xoshiro implements Random {
  /// The maximum value for a 64-bit unsigned integer, used in calculations to ensure results stay within 64-bit bounds.
  static BigInt maxUint64 = BigInt.parse('0xFFFFFFFFFFFFFFFF');

  /// The internal state of the generator stored as a list of [BigInt], necessary for the Xoshiro algorithm's computations.
  final List<BigInt> state;

  /// Creates a new instance of [Xoshiro] with the specified seed.
  factory Xoshiro(List<int> seed) {
    Digest digest = sha256.convert(seed);
    List<BigInt> s = List<BigInt>.generate(4, (_) => BigInt.zero);
    for (int i = 0; i < 4; i++) {
      int o = i * 8;
      BigInt v = BigInt.zero;
      for (int n = 0; n < 8; n++) {
        v = (v << 8).toUnsigned(64);
        v = v ^ BigInt.from(digest.bytes[o + n]);
      }
      s[i] = v.toUnsigned(64);
    }
    return Xoshiro._(s);
  }

  /// Creates a new instance of [Xoshiro] with the specified state.
  Xoshiro._(this.state);

  /// Provides a random boolean.
  @override
  bool nextBool() {
    return nextInt(1) == 0;
  }

  /// Provides a random double between 0.0 and 1.0.
  @override
  double nextDouble() {
    return _roll() / (maxUint64 + BigInt.one);
  }

  /// Generates a random integer based on the Xoshiro algorithm's internal state.
  @override
  int nextInt(int max, [int low = 0]) {
    return (nextDouble() * (max - low + 1)).floor() + low;
  }

  /// Generates a random 64-bit unsigned integer based on the Xoshiro algorithm's internal state.
  BigInt _roll() {
    BigInt result = (_rotl(state[1] * BigInt.from(5).toUnsigned(64), 7) * BigInt.from(9)).toUnsigned(64);

    BigInt t = (state[1] << 17).toUnsigned(64);

    state[2] = (state[2] ^ state[0]).toUnsigned(64);
    state[3] = (state[3] ^ state[1]).toUnsigned(64);
    state[1] = (state[1] ^ state[2]).toUnsigned(64);
    state[0] = (state[0] ^ state[3]).toUnsigned(64);

    state[2] = (state[2] ^ t).toUnsigned(64);
    state[3] = _rotl(state[3], 45).toUnsigned(64);

    return result;
  }

  /// Rotates a 64-bit unsigned integer to the left by the specified number of bits.
  BigInt _rotl(BigInt x, int k) {
    return ((x << k).toUnsigned(64)) ^ ((x >> (64 - k)).toUnsigned(64));
  }
}
