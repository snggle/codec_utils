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

import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/bytewords/bytewords_codec.dart';
import 'package:codec_utils/src/codecs/bytewords/bytewords_style.dart';
import 'package:codec_utils/src/codecs/fountain/decoder/fountain_decoder.dart';
import 'package:codec_utils/src/codecs/fountain/encoder/fountain_encoder_part.dart';
import 'package:codec_utils/src/codecs/uniform_resource/ur_parsed_part.dart';
import 'package:codec_utils/src/codecs/uniform_resource/ur_sequence_component.dart';
import 'package:codec_utils/src/codecs/uniform_resource/ur_utils.dart';

/// The [URDecoder] class is responsible for decoding data encoded in the "UR" format,
/// often used for transferring compact binary data across various platforms.
class URDecoder {
  /// The prefix used to identify UR encoded data. It is placed at the start of a string to indicate UR format.
  static const String _prefix = 'ur:';

  /// The internal decoder used for decoding parts of a multi-part UR encoded string.
  final FountainDecoder _fountainDecoder = FountainDecoder();

  /// Stores the expected type of the UR data being decoded. Takes the value after first part received.
  String? _expectedType;

  /// Stores the result of the UR decoding process, once the full data has been reconstructed.
  UR? _result;

  /// Processes a single encoded string part of a UR, contributing to the reconstruction of the full data.
  void receivePart(String part) {
    URParsedPart urParsedPart = _parse(part);
    _expectedType ??= urParsedPart.type;

    if (urParsedPart.hasType(_expectedType!) == false) {
      return;
    }

    if (urParsedPart.isSinglePartUR) {
      _result = _decodePart(urParsedPart);
      return;
    }

    if (urParsedPart.components.length != 2) {
      throw Exception('Cannot parse received part: Invalid Components Length');
    }

    String sequence = urParsedPart.components.first;
    String fragment = urParsedPart.components.last;

    List<int> cbor = BytewordsCodec.decode(fragment, BytewordsStyle.minimal);

    URSequenceComponent urSequenceComponent = _parseSequenceComponent(sequence);
    FountainEncoderPart fountainEncoderPart = FountainEncoderPart.fromCborPayload(cbor);

    bool numberMatchBool = urSequenceComponent.sequenceNumber == fountainEncoderPart.sequenceNumber;
    bool lengthMatchBool = urSequenceComponent.sequenceLength == fountainEncoderPart.sequenceLength;

    if (numberMatchBool == false || lengthMatchBool == false) {
      return;
    }

    _fountainDecoder.receivePart(fountainEncoderPart);

    if (_fountainDecoder.isComplete) {
      Uint8List? cborPayload = _fountainDecoder.resultMessage();
      _result = UR(type: urParsedPart.type, serializedCbor: cborPayload!);
    }
  }

  /// Returns the fully decoded URRegistryRecord if the decoding process is complete, otherwise, returns null
  ACborTaggedObject? buildCborTaggedObject() {
    UR? ur = buildUR();
    if (ur != null) {
      CborMap cborMap = cborDecode(ur.serializedCbor) as CborMap;
      CborSpecialTag cborSpecialTag = CborSpecialTag.fromType(ur.type);

      return ACborTaggedObject.fromCborMap(cborMap, customCborSpecialTag: cborSpecialTag);
    } else {
      return null;
    }
  }

  /// Returns the fully decoded UR if the decoding process is complete, otherwise, returns null
  UR? buildUR() {
    return _result;
  }

  /// Retrieves the current progress of the decoding process as a fraction from 0.0 to 1.0.
  double get progress {
    if (isComplete) {
      return 1.0;
    }
    return _fountainDecoder.progress;
  }

  /// Estimates the percentage of the decoding process completed, based on parts received.
  double get estimatedPercentComplete {
    if (isComplete) {
      return 1.0;
    }

    return _fountainDecoder.estimatedPercentComplete;
  }

  /// Returns whether the decoding process has received all parts and the data is fully reconstructed.
  bool get isComplete {
    return _result != null || _fountainDecoder.isComplete;
  }

  /// Provides the expected number of parts in the UR sequence, if known.
  int? get expectedPartCount {
    // If the UR has only one fragment, the fountain decoder is not used. Therefore, it will always return null.
    // For this reason, if the decoder result is known, but the fountain decoder still returns null, expectedPartCount is equal 1.
    if (isComplete && _fountainDecoder.expectedPartCount == null) {
      return 1;
    }
    return _fountainDecoder.expectedPartCount;
  }

  /// Parses a single part string into a [URParsedPart]
  URParsedPart _parse(String part) {
    String partLowercase = part.toLowerCase();
    String partPrefix = partLowercase.substring(0, 3);

    if (partPrefix != _prefix) {
      throw Exception('Cannot parse received part: Invalid Scheme (prefix). UR values should start with "ur:"');
    }

    List<String> components = partLowercase.substring(3).split('/');
    String type = components.first;

    if (components.length < 2) {
      throw Exception('Cannot parse received part: UR value should be <type>/<data> or <type>/<sequence>/<data>');
    }

    if (URUtils.isValidURType(type) == false) {
      throw Exception('Cannot parse received part: UR type may contain only "abcdefghijklmnopqrstuvwxyz0123456789-" characters');
    }

    return URParsedPart(type: type, components: components.sublist(1));
  }

  /// Decodes a [URParsedPart] into a [UR], which is part of reconstructing the full UR from its components.
  UR _decodePart(URParsedPart urParsedPart) {
    List<int> cbor = BytewordsCodec.decode(urParsedPart.components[0], BytewordsStyle.minimal);
    return UR(type: urParsedPart.type, serializedCbor: Uint8List.fromList(cbor));
  }

  /// Parses a string sequence to identify its components, used in reconstructing the UR from parts.
  URSequenceComponent _parseSequenceComponent(String sequence) {
    List<String> sequenceComponents = sequence.split('-');
    if (sequenceComponents.length != 2) {
      throw Exception('Cannot parse received part: Sequence component should be <number>-<total>');
    }

    int number = int.parse(sequenceComponents.first);
    int length = int.parse(sequenceComponents.last);

    if (number < 1 || length < 1) {
      throw Exception('Cannot parse received part: Sequence values cannot be less than 1');
    }

    return URSequenceComponent(sequenceNumber: number, sequenceLength: length);
  }
}
