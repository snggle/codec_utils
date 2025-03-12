import 'dart:convert';
import 'dart:typed_data';

import 'package:bech32/bech32.dart';
import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/bech32/bech32_validation.dart';

class Bech32Encoder extends Converter<Bech32Pair, String> with Bech32Validation {
  @override
  String convert(Bech32Pair input, [int maxLength = Bech32Validation.maxInputLength]) {
    String hrp = input.hrp;
    Uint8List dataUint8List = input.data;

    if (hrp.length + dataUint8List.length + separator.length + Bech32Validation.checksumLength > maxLength) {}

    hrp.toLowerCase();
    Uint8List checkSummed = dataUint8List
  }

  List<int> _createChec
}
