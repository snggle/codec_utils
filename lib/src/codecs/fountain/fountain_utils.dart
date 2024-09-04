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
import 'dart:typed_data';

import 'package:codec_utils/src/codecs/fountain/random_sampler/fountain_random_sampler.dart';
import 'package:codec_utils/src/utils/xoshiro.dart';

/// Provides utility functions for operations related to fountain encoding and decoding.
class FountainUtils {
  /// Chooses the fragments to be used for encoding a part of the message.
  static List<int> chooseFragments(int sequenceNumber, int sequenceLength, int checksum) {
    // The first `sequenceLength` parts are the "pure" fragments, not mixed with any
    // others. This means that if you only generate the first `sequenceLength` parts,
    // then you have all the parts you need to decode the message.
    if (sequenceNumber <= sequenceLength) {
      return <int>[sequenceNumber - 1];
    } else {
      List<int> seed = <int>[..._intToBytes(sequenceNumber), ..._intToBytes(checksum)];
      Random rng = Xoshiro(seed);
      int degree = _chooseDegree(sequenceLength, rng);
      List<int> indexes = List<int>.generate(sequenceLength, (int index) => index);
      List<int> shuffledIndexes = _shuffle(indexes, rng);

      return shuffledIndexes.sublist(0, degree);
    }
  }

  /// XORs two byte arrays.
  static Uint8List bufferXOR(List<int> a, List<int> b) {
    int length = max(a.length, b.length);
    Uint8List buffer = Uint8List(length);

    for (int i = 0; i < length; ++i) {
      buffer[i] = a[i] ^ b[i];
    }

    return buffer;
  }

  /// Parses an integer into a byte array.
  static Uint8List _intToBytes(int num) {
    ByteData byteData = ByteData(4)..setUint32(0, num, Endian.big);
    return byteData.buffer.asUint8List();
  }

  /// Chooses the degree of the polynomial used to generate the fountain code.
  static int _chooseDegree(int sequenceLength, Random rng) {
    List<double> degreeProbabilities = List<double>.generate(sequenceLength, (int index) => 1 / (index + 1));
    return FountainRandomSampler(probabilities: degreeProbabilities, rng: rng).next() + 1;
  }

  /// Shuffles a list of integers.
  static List<int> _shuffle(List<int> items, Random rng) {
    List<int> remaining = <int>[...items];
    List<int> result = <int>[];

    while (remaining.isNotEmpty) {
      int index = remaining.length - 1 > 0 ? rng.nextInt(remaining.length - 1) : 0;
      int item = remaining[index];

      remaining.removeAt(index);
      result.add(item);
    }

    return result;
  }
}
