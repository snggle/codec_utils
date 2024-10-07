import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';

/// An abstract base class representing a complex Protobuf object.
/// This class extends [AProtobufField], allowing to nest objects within other objects.
abstract class AProtobufObject extends AProtobufField {
  /// Creates an [AProtobufObject] object.
  const AProtobufObject();

  /// Encodes the object into a Protobuf byte field using the given field number.
  /// The object is first converted into bytes and then encoded.
  @override
  List<int> encode(int fieldNumber) {
    return ProtobufBytes(toProtoBytes()).encode(fieldNumber);
  }

  /// Converts the object into a byte array in Protobuf format.
  Uint8List toProtoBytes();

  /// Converts the object into a JSON-compatible map format.
  Map<String, dynamic> toProtoJson();
}
