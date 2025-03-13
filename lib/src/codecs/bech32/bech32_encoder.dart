import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/bech32/bech32_validation.dart';

class Bech32Encoder extends Converter<Bech32Pair, String> {
  String separator = Bech32Validation.separator;
  List<String> charList = Bech32Validation.charList;

  @override
  String convert(Bech32Pair input, [int maxLength = Bech32Validation.maxInputLength]) {
    String hrp = input.hrp;
    Uint8List dataUint8List = input.data;

    if (hrp.length + dataUint8List.length + separator.length + Bech32Validation.checksumLength > maxLength) {}

    hrp.toLowerCase();

    Uint8List checkSummed = Uint8List.fromList(dataUint8List + Bech32Validation().createChecksum(hrp, dataUint8List));

    return hrp + separator + checkSummed.map((int element) => charList[element]).join();
  }
}
