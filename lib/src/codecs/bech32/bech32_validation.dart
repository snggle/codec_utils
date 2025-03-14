import 'dart:typed_data';

class Bech32Validation {
  static const int maxInputLength = 90;
  static const int checksumLength = 6;
  static const String separator = '1';
  static const List<String> charList = <String>[
    'q',
    'p',
    'z',
    'r',
    'y',
    '9',
    'x',
    '8',
    'g',
    'f',
    '2',
    't',
    'v',
    'd',
    'w',
    '0',
    's',
    '3',
    'j',
    'n',
    '5',
    '4',
    'k',
    'h',
    'c',
    'e',
    '6',
    'm',
    'u',
    'a',
    '7',
    'l',
  ];

  static const List<int> _generator = <int>[
    0x3b6a57b2,
    0x26508e6d,
    0x1ea119fa,
    0x3d4233dd,
    0x2a1462b3,
  ];

  bool isChecksumTooShort(int checksumLength, String input) {
    return checksumLength < 0;
  }

  bool hasInvalidChars(List<int> dataList) {
    return dataList.any((int element) => element == -1);
  }

  bool isPrefixTooShort(int separatorPosition) {
    return separatorPosition == 0;
  }

  bool isChecksumValid(String hrp, Uint8List dataUint8List, Uint8List checksumUint8List) {
    return _verifyChecksum(hrp, Uint8List.fromList(dataUint8List + checksumUint8List));
  }

  bool isMixedCase(String input) {
    return input.toLowerCase() != input && input.toUpperCase() != input;
  }

  bool hasInvalidSeparator(String input) {
    return input.lastIndexOf(separator) == -1;
  }

  bool hasInvalidPrefixChars(String hrp) {
    return hrp.codeUnits.any((int element) => element < 33 || element > 126);
  }

  Uint8List createChecksum(String hrp, Uint8List dataUint8List) {
    Uint8List valuesList = Uint8List.fromList(_expandHrp(hrp) + dataUint8List + <int>[0, 0, 0, 0, 0, 0]);
    int polymodUint8List = _polymod(valuesList) ^ 1;

    Uint8List resultList = Uint8List.fromList(<int>[0, 0, 0, 0, 0, 0]);

    for (int i = 0; i < resultList.length; i++) {
      resultList[i] = (polymodUint8List >> (5 * (5 - i))) & 31;
    }
    return resultList;
  }

  bool _verifyChecksum(String hrp, Uint8List checksumDataList) {
    return _polymod(_expandHrp(hrp) + checksumDataList) == 1;
  }

  int _polymod(List<int> valuesList) {
    int checksum = 1;
    for (int element in valuesList) {
      int highBit = checksum >> 25;
      checksum = (checksum & 0x1ffffff) << 5 ^ element;
      for (int i = 0; i < _generator.length; i++) {
        if ((highBit >> i) & 1 == 1) {
          checksum ^= _generator[i];
        }
      }
    }
    return checksum;
  }

  Uint8List _expandHrp(String hrp) {
    List<int> resultList = hrp.codeUnits.map((int element) => element >> 5).toList();
    resultList = resultList + <int>[0];
    resultList = resultList + hrp.codeUnits.map((int element) => element & 31).toList();
    return Uint8List.fromList(resultList);
  }
}
