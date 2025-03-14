import 'dart:convert';
import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/bech32/bech32_validation.dart';

class Bech32Decoder extends Converter<String, Bech32Pair> {
  static const int maxChecksumLength = Bech32Validation.checksumLength;
  static const String separator = Bech32Validation.separator;
  static const List<String> charList = Bech32Validation.charList;

  @override
  Bech32Pair convert(String input, [int maxInputLength = Bech32Validation.maxInputLength]) {
    if (input.length > maxInputLength) {
      throw Exception('Bech32 is to long: ${input.length} > 90');
    }
    if (Bech32Validation().isMixedCase(input)) {
      throw Exception('The hrp should be either all lower or all upper case: $input');
    }
    if (Bech32Validation().hasInvalidSeparator(input)) {
      throw Exception('Bech32 has invalid separator at position: ${input.lastIndexOf(separator)}');
    }

    int separatorPosition = input.lastIndexOf(separator);

    if (Bech32Validation().isChecksumTooShort(separatorPosition, input)) {
      throw Exception('Checksum is to short: ${input.length} < 6');
    }

    if (Bech32Validation.)

    input.toLowerCase();

    String hrp = input.substring(0, separatorPosition);
    String data = input.substring(separatorPosition + 1, input.length - maxChecksumLength);
    String checksum = input.substring(input.length - maxChecksumLength);

    Uint8List uint8List = Uint8List.fromList(data.split('').map((String element) {
      return charList.indexOf(element);
    }).toList());

    List<int> checksumByteList = checksum.split('').map((String element) {
      return charList.indexOf(element);
    }).toList();

    return Bech32Pair(hrp: hrp, data: uint8List);
  }
}
