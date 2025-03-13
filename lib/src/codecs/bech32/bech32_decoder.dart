import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/bech32/bech32_validation.dart';

class Bech32Decoder extends Converter<String, Bech32Pair> {
  String separator = Bech32Validation.separator;
  List<String> charList = Bech32Validation.charList;

  @override
  Bech32Pair convert(String input, [int maxInputLength = Bech32Validation.maxInputLength]) {
    if (input.length > maxInputLength) {}

    int separatorPosition = input.lastIndexOf(separator);
    input.toLowerCase();

    String hrp = input.substring(0, separatorPosition);
    String data = input.substring(separatorPosition + 1, input.length - Bech32Validation.checksumLength);
    String checksum = input.substring(input.length - Bech32Validation.checksumLength);

    Uint8List uint8List = Uint8List.fromList(data.split('').map((String element) {
      return charList.indexOf(element);
    }).toList());

    List<int> checksumByteList = checksum.split('').map((String element) {
      return charList.indexOf(element);
    }).toList();

    return Bech32Pair(hrp: hrp, data: uint8List);
  }
}
