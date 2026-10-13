import 'dart:typed_data';

import 'package:cbor/cbor.dart';

class CborAttestationObject {
  final Uint8List authenticatorData;

  const CborAttestationObject({
    required this.authenticatorData,
  });

  CborMap toCborMap() {
    return CborMap.of(
      <CborValue, CborValue>{
        CborString('fmt'): CborString('none'),
        CborString('attStmt'): CborMap.of(
          <CborValue, CborValue>{},
        ),
        CborString('authData'): CborBytes(authenticatorData),
      },
    );
  }

  Uint8List toSerializedCbor() {
    return Uint8List.fromList(cborEncode(toCborMap()));
  }
}