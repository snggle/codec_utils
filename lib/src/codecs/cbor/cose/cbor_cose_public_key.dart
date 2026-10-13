import 'dart:typed_data';

import 'package:cbor/cbor.dart';

class CborCosePublicKey {
  final Uint8List x;
  final Uint8List y;

  const CborCosePublicKey({
    required this.x,
    required this.y,
  });

  CborMap toCborMap() {
    return CborMap.of(
      <CborValue, CborValue>{
        const CborSmallInt(1): const CborSmallInt(2),
        const CborSmallInt(3): const CborSmallInt(-7),
        const CborSmallInt(-1): const CborSmallInt(1),
        const CborSmallInt(-2): CborBytes(x),
        const CborSmallInt(-3): CborBytes(y),
      },
    );
  }

  Uint8List toSerializedCbor() {
    return Uint8List.fromList(cborEncode(toCborMap()));
  }
}