class Bech32Constants {
  static const int maxInputLength = 90;
  static const int checksumLength = 6;
  static const String separator = '1';
  static const List<String> charList = <String>[
    'q', 'p', 'z', 'r', 'y', '9', 'x', //
    '8', 'g', 'f', '2', 't', 'v', 'd',
    'w', '0', 's', '3', 'j', 'n', '5',
    '4', 'k', 'h', 'c', 'e', '6', 'm',
    'u', 'a', '7', 'l',
  ];

  static const List<int> generatorList = <int>[
    0x3b6a57b2, 0x26508e6d, 0x1ea119fa, //
    0x3d4233dd, 0x2a1462b3,
  ];
}
