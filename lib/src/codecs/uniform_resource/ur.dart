import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';
import 'package:equatable/equatable.dart';

/// Represents a Uniform Resource (UR) that encapsulates a specific type and payload.
/// The UR class is typically used to encode data in a compact, binary format suitable for various applications,
/// including but not limited to QR codes and other forms of data transmission.
class UR extends Equatable {
  /// The type of the UR, generally indicating the nature of the data contained in the `cborPayload`.
  /// For example, this could specify the type of document or data structure being represented.
  final String type;

  /// The payload of the UR, stored as a CBOR (Concise Binary Object Representation) encoded binary array.
  /// This is used for efficiently encoding and transmitting data.
  final Uint8List serializedCbor;

  /// Creates a new UR instance with the specified type and CBOR payload.
  const UR({
    required this.type,
    required this.serializedCbor,
  });

  /// Created an empty UR instance.
  UR.empty()
      : type = '',
        serializedCbor = Uint8List(0);

  /// Creates a UR instance from a CBOR value included in the registry
  factory UR.fromCborTaggedObject(ACborTaggedObject cborTaggedObject) {
    String cborType = cborTaggedObject.getCborSpecialTag().type;
    List<int> serializedCbor = cborTaggedObject.toSerializedCbor(includeTagBool: false);
    return UR(type: cborType, serializedCbor: Uint8List.fromList(serializedCbor));
  }

  @override
  List<Object> get props => <Object>[type, serializedCbor];
}
