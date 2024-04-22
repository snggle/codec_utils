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

import 'package:codec_utils/src/codecs/fountain/encoder/fountain_encoder_part.dart';
import 'package:codec_utils/src/codecs/fountain/fountain_utils.dart';
import 'package:codec_utils/src/utils/crc32.dart';

/// The [FountainEncoder] class is responsible for encoding arbitrary data into fragments using a fountain coding approach.
/// Class allows data to be transmitted over unreliable networks by breaking the data into fragments that can be independently reconstructed.
class FountainEncoder {
  /// Stores the original message as bytes.
  /// This is the data that will be encoded into fragments.
  final List<int> _message;

  /// Specifies the maximum length of any single fragment.
  final int _maxFragmentLength;

  /// Specifies the minimum length of any single fragment,
  /// ensuring each fragment has a minimum size.
  final int _minFragmentLength;

  /// The calculated checksum of the original message,
  /// used to verify the integrity of the data upon decoding.
  late final int _checksum;

  /// The length of each fragment, which may vary within
  /// the specified min and max range depending on the encoding strategy.
  late final int _fragmentLength;

  /// The total length of the original message,
  /// used to help in the reassembly of the encoded fragments.
  late final int _messageLength;

  /// A list of generated fragments, each represented as a [Uint8List], which stores parts of the original message.
  late final List<Uint8List> _fragments;

  /// A sequence number that tracks the number of fragments created.
  late int _sequenceNumber;

  /// Creates a new instance of [FountainEncoder] with the specified message.
  FountainEncoder({
    required List<int> message,
    required int maxFragmentLength,
    required int minFragmentLength,
    required int firstSequenceNumber,
  })  : _minFragmentLength = minFragmentLength,
        _maxFragmentLength = maxFragmentLength,
        _message = message {
    _fragmentLength = _findNominalFragmentLength(_message.length, _minFragmentLength, _maxFragmentLength);

    _messageLength = _message.length;
    _fragments = _partitionMessage(_message, _fragmentLength);
    _checksum = CRC32.get(_message);
    _sequenceNumber = firstSequenceNumber;
  }

  /// Indicates whether all parts of the message have been encoded and the process is complete.
  bool get isComplete {
    return _sequenceNumber >= _fragments.length;
  }

  /// Determines if the entire message can be encoded into a single part based on the message and fragment lengths.
  bool get isSinglePart {
    return _fragments.length == 1;
  }

  /// Returns the total length of all the fragments to be created.
  int get fragmentsCount {
    return _fragments.length;
  }

  /// Generates the next part of the encoded message, progressing through the sequence of fragments.
  FountainEncoderPart nextPart() {
    _sequenceNumber = _sequenceNumber + 1;

    List<int> indexes = FountainUtils.chooseFragments(_sequenceNumber, _fragments.length, _checksum);
    List<int> mixedFragment = _mixFragment(indexes);

    return FountainEncoderPart(
      sequenceNumber: _sequenceNumber,
      sequenceLength: _fragments.length,
      messageLength: _messageLength,
      checksum: _checksum,
      fragment: mixedFragment,
    );
  }

  /// Resets the encoder to the initial state, allowing the encoding process to be restarted.
  void reset() {
    _sequenceNumber = 0;
  }

  /// Combines and processes the fragments associated with the given indexes
  List<int> _mixFragment(List<int> indexes) {
    Uint8List result = Uint8List(_fragmentLength);
    for (int index in indexes) {
      result = FountainUtils.bufferXOR(_fragments[index], result);
    }
    return result;
  }

  /// Determines the optimal fragment length within the specified range that best fits the message length.
  int _findNominalFragmentLength(int messageLength, int minFragmentLength, int maxFragmentLength) {
    assert(messageLength > 0, 'Message length must be greater than 0');
    assert(minFragmentLength > 0, 'Minimum fragment length must be greater than 0');
    assert(maxFragmentLength >= minFragmentLength, 'Maximum fragment length must be greater than or equal to minimum fragment length');

    int maxFragmentCount = (messageLength / minFragmentLength).ceil();
    int fragmentLength = 0;

    for (int fragmentCount = 1; fragmentCount <= maxFragmentCount; fragmentCount++) {
      fragmentLength = (messageLength / fragmentCount).ceil();

      if (fragmentLength <= maxFragmentLength) {
        break;
      }
    }

    return fragmentLength;
  }

  /// Partitions the original message into fragments of the specified length, preparing them for encoding.
  List<Uint8List> _partitionMessage(List<int> message, int fragmentLength) {
    List<int> remaining = List<int>.from(message);
    List<Uint8List> fragments = <Uint8List>[];

    while (remaining.isNotEmpty) {
      List<int> fragment = remaining.sublist(0, min(remaining.length, fragmentLength));
      remaining = remaining.length > fragmentLength ? remaining.sublist(fragmentLength) : <int>[];

      List<int> filledFragment = List<int>.filled(fragmentLength, 0)..setRange(0, fragment.length, fragment);
      fragments.add(Uint8List.fromList(filledFragment));
    }

    return fragments;
  }
}
