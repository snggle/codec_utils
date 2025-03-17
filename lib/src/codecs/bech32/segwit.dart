class SegwitPair{
  final String hrp;
  final int version;
  final List<int> programList;

  SegwitPair(this.hrp, this.version, this.programList);

  String get scriptPubKey{
    int v = version == 0 ? version : version + 0x50;
    return (<int>[v, programList.length] + programList).map((int element) => element.toRadixString(16).padLeft(2, '0')).toList().join('');
  }

  List<int> convertBits(List<int> dataList, int from, int to, bool padBool){
    int acc = 0;
    int bits = 0;
    List<int> resultList = <int>[];
  }
}