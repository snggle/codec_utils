import 'package:bech32/bech32.dart';

mixin Bech32Validation {
  static const int maxInputLength = 90;
  static const int checksumLength = 6;

  bool isChecksumTooShort(int separatorPosition, String input) {
    return (input.length - separatorPosition - 1 - checksumLength) < 0;
  }

  bool hasInvalidChars(List<int> dataList) {
    return dataList.any((int element) => element == -1);
  }

  bool isPrefixTooShort(int separatorPosition) {
    return separatorPosition == 0;
  }

  bool isChecksumValid(String prefix, List<int> dataList, List<int> checksumList) {
    return _verifyChecksum(prefix, dataList + checksumList);
  }

  bool isMixedCase(String input) {
    return input.toLowerCase() != input && input.toUpperCase() != input;
  }

  bool hasInvalidSeparator(String input) {
    return input.lastIndexOf(separator) == -1;
  }

  bool hasInvalidPrefixChars(String prefix) {
    return prefix.codeUnits.any((int element) => element < 33 || element > 126);
  }

  bool _verifyChecksum(String prefix, List<int> checksumDataList) {
    return _polymod(_expandPrefix(prefix) + checksumDataList) == 1;
  }

  int _polymod(List<int> valuesList) {
    int checksum = 1;
    for (int element in valuesList) {
      int highBit = checksum >> 25;
      checksum = (checksum & 0x1ffffff) << 5 ^ element;
      for (int i = 0; i < generator.length; i++) {
        if ((highBit >> i) & 1 == 1) {
          checksum ^= generator[i];
        }
      }
    }
    return checksum;
  }

  List<int> _expandPrefix(String prefix) {
    List<int> resultList = prefix.codeUnits.map((int element) => element >> 5).toList();
    resultList = resultList + <int>[0];
    resultList = resultList + prefix.codeUnits.map((int element) => element & 31).toList();
    return resultList;
  }
}
