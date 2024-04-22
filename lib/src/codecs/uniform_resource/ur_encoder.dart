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

import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/bytewords/bytewords_codec.dart';
import 'package:codec_utils/src/codecs/bytewords/bytewords_style.dart';
import 'package:codec_utils/src/codecs/fountain/encoder/fountain_encoder.dart';
import 'package:codec_utils/src/codecs/fountain/encoder/fountain_encoder_part.dart';

/// The [UREncoder] class is designed for encoding data into the "UR" format,
/// widely used for transferring compact binary data efficiently across various platforms.
/// This class specifically handles the transformation of UR data into encoded parts leveraging a fountain coding scheme.
class UREncoder {
  /// Holds the UR instance that contains the data to be encoded. This UR object is the primary data source for the encoding process.
  final UR _ur;

  /// An instance of FountainEncoder, initialized with the UR data, used for encoding the data into multiple parts.
  /// This encoder ensures that the data can be transmitted in parts and reconstructed even if some parts are missing or received out of order.
  late final FountainEncoder _fountainEncoder;

  /// Creates a new UREncoder instance with the specified UR data and optional encoding parameters.
  UREncoder({
    required UR ur,
    int firstSequenceNumber = 0,
    int maxFragmentLength = 100,
    int minFragmentLength = 10,
  }) : _ur = ur {
    _fountainEncoder = FountainEncoder(
      message: _ur.serializedCbor,
      firstSequenceNumber: firstSequenceNumber,
      maxFragmentLength: maxFragmentLength,
      minFragmentLength: minFragmentLength,
    );
  }

  /// Encodes all portions of the UR data into a list of strings, each representing a part of the encoded data.
  List<String> encodeWhole() {
    reset();
    return List<String>.generate(fragmentsCount, (_) => nextPart());
  }

  /// Returns the total number of fragments that the UR data has been encoded into.
  int get fragmentsCount => _fountainEncoder.fragmentsCount;

  /// Generates the next part of the encoded UR data, useful in multi-part transmission scenarios.
  String nextPart() {
    FountainEncoderPart fountainEncoderPart = _fountainEncoder.nextPart();

    if (_fountainEncoder.isSinglePart) {
      return _encodeSinglePart(_ur);
    } else {
      return _encodePart(_ur.type, fountainEncoderPart);
    }
  }

  bool get isComplete {
    return _fountainEncoder.isComplete;
  }

  /// Resets the encoder to the initial state, allowing the UR data to be re-encoded from the beginning.
  void reset() {
    _fountainEncoder.reset();
  }

  /// Encodes a single [UR] object into a string, typically representing one complete piece of data without segmentation.
  String _encodeSinglePart(UR ur) {
    String bodyComponent = BytewordsCodec.encode(ur.serializedCbor, BytewordsStyle.minimal);

    return _encodeUR(<String>[ur.type, bodyComponent]);
  }

  /// Encodes a single part of the [UR] data using the specified type and a segment of the fountain encoder output.
  String _encodePart(String type, FountainEncoderPart fountainEncoderPart) {
    String sequenceComponent = '${fountainEncoderPart.sequenceNumber}-${fountainEncoderPart.sequenceLength}';
    String bodyComponent = BytewordsCodec.encode(fountainEncoderPart.toCborPayload(), BytewordsStyle.minimal);

    return _encodeUR(<String>[type, sequenceComponent, bodyComponent]);
  }

  /// Constructs a UR string from a list of path components, assembling them into a structured UR format.
  String _encodeUR(List<String> pathComponents) {
    return _encodeUri('ur', pathComponents);
  }

  /// Encodes complete UR String with the specified scheme and path components.
  String _encodeUri(String scheme, List<String> pathComponents) {
    String path = pathComponents.join('/');
    return <String>[scheme, path].join(':').toUpperCase();
  }
}
