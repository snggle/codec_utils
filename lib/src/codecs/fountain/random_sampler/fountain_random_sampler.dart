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

import 'package:codec_utils/src/codecs/fountain/random_sampler/fountain_random_sampler_alias_data.dart';

/// The [FountainRandomSampler] class provides a mechanism for efficiently sampling from a discrete probability distribution.
class FountainRandomSampler {
  /// A list of probabilities for each outcome, where each probability is a double between 0 and 1. These probabilities must sum to 1.
  final List<double> _probabilities;

  /// An instance of [Random] used to generate random numbers needed for the sampling process.
  final Random _rng;

  /// A precomputed list of indices for the outcomes.
  late final List<int> _indexedOutcomes;

  /// Stores data necessary for the Alias Method, including structures that map probabilities to simplified outcomes.
  late final FountainRandomSamplerAliasData _fountainRandomSamplerAliasData;

  /// Creates a new instance of [FountainRandomSampler].
  FountainRandomSampler({
    required List<double> probabilities,
    required Random rng,
  })  : _rng = rng,
        _probabilities = probabilities {
    int n = _probabilities.length;
    _indexedOutcomes = List<int>.generate(n, (int index) => index);
    _fountainRandomSamplerAliasData = _precomputeAlias(_probabilities, n);
  }

  /// Returns the next sampled outcome based on the provided probabilities.
  int next() {
    int c = (_rng.nextDouble() * _fountainRandomSamplerAliasData.probabilities.length).floor();
    return _indexedOutcomes[(_rng.nextDouble() < _fountainRandomSamplerAliasData.probabilities[c]) ? c : _fountainRandomSamplerAliasData.alias[c]];
  }

  /// Precomputes the alias method for the provided probabilities.
  FountainRandomSamplerAliasData _precomputeAlias(List<double> p, int n) {
    double sum = p.fold(0, (double acc, double val) {
      if (val < 0) {
        throw Exception('Probability must be positive: p[${p.indexOf(val)}]=$val');
      }
      return acc + val;
    });

    if (sum == 0) {
      throw Exception('Probability sum must be greater than zero.');
    }

    List<double> scaledProbabilities = p.map((double prob) => (prob * n) / sum).toList();

    FountainRandomSamplerAliasData randomSamplerAliasData = FountainRandomSamplerAliasData.empty(n);

    List<int> small = <int>[];
    List<int> large = <int>[];
    for (int i = n - 1; i >= 0; i--) {
      if (scaledProbabilities[i] < 1) {
        small.add(i);
      } else {
        large.add(i);
      }
    }

    while (small.isNotEmpty && large.isNotEmpty) {
      int less = small.removeLast();
      int more = large.removeLast();

      randomSamplerAliasData.probabilities[less] = scaledProbabilities[less];
      randomSamplerAliasData.alias[less] = more;

      scaledProbabilities[more] = (scaledProbabilities[more] + scaledProbabilities[less]) - 1;
      if (scaledProbabilities[more] < 1) {
        small.add(more);
      } else {
        large.add(more);
      }
    }
    while (large.isNotEmpty) {
      int index = large.removeLast();
      randomSamplerAliasData.probabilities[index] = 1;
    }
    while (small.isNotEmpty) {
      int index = small.removeLast();

      randomSamplerAliasData.probabilities[index] = 1;
    }
    return randomSamplerAliasData;
  }
}
