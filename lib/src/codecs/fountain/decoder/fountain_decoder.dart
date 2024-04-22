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

import 'package:codec_utils/src/codecs/fountain/decoder/fountain_decoder_part.dart';
import 'package:codec_utils/src/codecs/fountain/encoder/fountain_encoder_part.dart';
import 'package:codec_utils/src/codecs/fountain/fountain_part_dict.dart';
import 'package:codec_utils/src/codecs/fountain/fountain_utils.dart';
import 'package:codec_utils/src/utils/crc32.dart';

/// The [FountainDecoder] class is designed for reconstructing data from parts encoded using a fountain coding scheme.
/// This type of coding is useful for transmitting data across unreliable or noisy channels, where some parts may be lost or arrive out of order,
/// as it allows for data recovery without needing all parts of the original data.
class FountainDecoder {
  /// Tracks the indexes of received parts to ensure that each part
  /// is processed only once and to manage the decoding state.
  final List<int> _receivedPartIndexes = <int>[];

  /// Stores simple (non-mixed) parts that have been decoded but
  /// not yet processed into the final result.
  final List<FountainPartDic> _simpleParts = <FountainPartDic>[];

  /// Holds parts that are queued for processing, facilitating the management
  /// of decoding operations as new parts arrive.
  final List<FountainDecoderPart> _queuedParts = <FountainDecoderPart>[];

  /// Expected checksum of the complete message, used to verify
  /// the integrity of the decoded data.
  int? _expectedChecksum;

  /// Expected length of each fragment or part, crucial for correctly
  /// assembling the decoded data.
  int? _expectedFragmentLength;

  /// Total expected length of the original message, guiding the reassembly
  /// process and helping to determine when decoding is complete.
  int? _expectedMessageLength;

  /// List of part indexes that are expected to be received,
  /// used to determine which parts are still missing.
  List<int>? _expectedPartIndexes;

  /// Counter of how many parts have been processed, assisting
  /// in monitoring the progress of the decoding process.
  int _processedPartsCount = 0;

  /// Holds the result of the decoding process, which is the reconstructed data,
  /// or null if the process is incomplete.
  Uint8List? _result;

  /// Contains mixed parts that have been created during the decoding process
  /// from simpler parts to handle complex decoding scenarios.
  List<FountainPartDic> _mixedParts = <FountainPartDic>[];

  /// Receives a part encoded by a FountainEncoder.
  /// Returns true if the part is valid and processed successfully.
  bool receivePart(FountainEncoderPart fountainEncoderPart) {
    if (isComplete || _isPartValid(fountainEncoderPart) == false) {
      return false;
    }

    FountainDecoderPart fountainDecoderPart = FountainDecoderPart.fromEncoderPart(fountainEncoderPart);
    _queuedParts.add(fountainDecoderPart);

    while (isComplete == false && _queuedParts.isNotEmpty) {
      _processQueuedItem();
    }

    _processedPartsCount += 1;
    return true;
  }

  /// Returns the result of the decoding process as a Uint8List if decoding is complete, otherwise returns an empty list.
  Uint8List? resultMessage() {
    return _result;
  }

  /// Returns the current progress of the decoding process as a fraction from 0.0 to 1.0.
  double get progress {
    if (isComplete) {
      return 1.0;
    }

    if (expectedPartCount == null) {
      return 0.0;
    } else {
      return _receivedPartIndexes.length / expectedPartCount!;
    }
  }

  /// Estimates the percentage of the decoding process completed based on parts received and expected total parts.
  double get estimatedPercentComplete {
    if (isComplete) {
      return 1.0;
    }

    if (expectedPartCount == null) {
      return 0.0;
    } else {
      // Multiply the expectedPartCount by `1.75` as a way to compensate for the facet
      // that "processedPartsCount" also tracks the duplicate parts that have been processed.
      return min(0.99, _processedPartsCount / (expectedPartCount! * 1.75));
    }
  }

  /// Indicates whether the decoding is complete, returning true if the final result is available.
  bool get isComplete => _result != null;

  /// Provides the expected number of parts in the UR sequence, if known, to gauge the completion progress.
  int? get expectedPartCount {
    return _expectedPartIndexes?.length;
  }

  /// Validates a received part against expected parameters and current state, ensuring its relevance and integrity.
  bool _isPartValid(FountainEncoderPart fountainEncoderPart) {
    _expectedPartIndexes ??= List<int>.generate(fountainEncoderPart.sequenceLength, (int index) => index);
    _expectedMessageLength ??= fountainEncoderPart.messageLength;
    _expectedChecksum ??= fountainEncoderPart.checksum;
    _expectedFragmentLength ??= fountainEncoderPart.fragment.length;

    // If this part's values don't match the first part's values, throw away the part
    if (_expectedPartIndexes?.length != fountainEncoderPart.sequenceLength) {
      return false;
    } else if (_expectedMessageLength != fountainEncoderPart.messageLength) {
      return false;
    } else if (_expectedChecksum != fountainEncoderPart.checksum) {
      return false;
    } else if (_expectedFragmentLength != fountainEncoderPart.fragment.length) {
      return false;
    }
    return true;
  }

  /// Processes items that are queued due to out-of-order receipt or pending validation.
  void _processQueuedItem() {
    if (_queuedParts.isEmpty) {
      return;
    }

    FountainDecoderPart fountainDecoderPart = _queuedParts.removeAt(0);
    if (fountainDecoderPart.isSimple) {
      _processSimplePart(fountainDecoderPart);
    } else {
      _processMixedPart(fountainDecoderPart);
    }
  }

  /// Processes a simple part directly into the result, integrating it into the current decoded state.
  void _processSimplePart(FountainDecoderPart fountainDecoderPart) {
    // Don't process duplicate parts
    int fragmentIndex = fountainDecoderPart.indexes.first;
    if (_receivedPartIndexes.contains(fragmentIndex)) {
      return;
    }

    _simpleParts.add(FountainPartDic(key: fountainDecoderPart.indexes, value: fountainDecoderPart));
    _receivedPartIndexes.add(fragmentIndex);

    // If we've received all the parts
    if (_expectedPartIndexes!.every(_receivedPartIndexes.contains)) {
      // Reassemble the message from its fragments
      List<FountainDecoderPart> sortedParts = _simpleParts.map((FountainPartDic fountainPartDic) => fountainPartDic.value).toList()
        ..sort((FountainDecoderPart a, FountainDecoderPart b) => (a.indexes[0] - b.indexes[0]));

      List<int> message = _joinFragments(sortedParts.map((FountainDecoderPart e) => e.fragment).toList(), _expectedMessageLength!);
      int checksum = CRC32.get(message);
      if (checksum == _expectedChecksum) {
        _result = Uint8List.fromList(message);
      }
    } else {
      _reduceMixedBy(fountainDecoderPart);
    }
  }

  /// Processes a mixed part, which might involve combining it with other parts to resolve complex encoding scenarios.
  void _processMixedPart(FountainDecoderPart fountainDecoderPart) {
    // Don't process duplicate parts
    if (_mixedParts.any((FountainPartDic fountainPartDic) {
      for (int i = 0; i < fountainPartDic.key.length; i++) {
        if (fountainPartDic.key[i] != fountainDecoderPart.indexes[i]) {
          return false;
        }
      }
      return true;
    })) {
      return;
    }

    // Reduce this part by all the others
    FountainDecoderPart p2 = _simpleParts.fold(fountainDecoderPart, (FountainDecoderPart acc, FountainPartDic p) => _reducePartByPart(acc, p.value));
    p2 = _mixedParts.fold(p2, (FountainDecoderPart acc, FountainPartDic p) => _reducePartByPart(acc, p.value));

    // If the part is now simple
    if (p2.isSimple) {
      // Add it to the queue
      _queuedParts.add(p2);
    } else {
      _reduceMixedBy(p2);
      _mixedParts.add(FountainPartDic(key: p2.indexes, value: p2));
    }
  }

  /// Joins fragments from different parts into a coherent message, used when all parts of a message are received.
  List<int> _joinFragments(List<List<int>> fragments, int messageLength) {
    return fragments.expand((List<int> e) => e).toList().sublist(0, messageLength);
  }

  /// Reduces the complexity of the mixed parts queue by combining compatible parts to simplify further processing.
  void _reduceMixedBy(FountainDecoderPart fountainDecoderPart) {
    List<FountainPartDic> newMixed = List<FountainPartDic>.empty(growable: true);

    _mixedParts.map((FountainPartDic mixedPart) => _reducePartByPart(mixedPart.value, fountainDecoderPart)).forEach((FountainDecoderPart reducedPart) {
      if (reducedPart.isSimple) {
        _queuedParts.add(reducedPart);
      } else {
        newMixed.add(FountainPartDic(key: reducedPart.indexes, value: reducedPart));
      }
    });

    _mixedParts = newMixed;
  }

  /// Reduces two parts into a single part, simplifying the decoding process by merging data from multiple sources.
  FountainDecoderPart _reducePartByPart(FountainDecoderPart a, FountainDecoderPart b) {
    // If the fragments mixed into `b` are a strict (proper) subset of those in `a`...
    if (b.indexes.every((int index) => a.indexes.contains(index))) {
      List<int> newIndexes = a.indexes.where((int x) => b.indexes.contains(x) == false).toList();
      List<int> newFragment = FountainUtils.bufferXOR(a.fragment, b.fragment);

      return FountainDecoderPart(indexes: newIndexes, fragment: newFragment);
    } else {
      // [a] is not reducible by [b], so return [a]
      return a;
    }
  }
}
