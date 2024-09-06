import 'dart:typed_data';

/// Mixin providing a method to convert an object to a list of bytes compatible with Protobuf.
mixin ProtobufMixin {
  /// Converts the object to a list of bytes compatible with Protobuf.
  Uint8List toProtoBytes();

  /// Converts the object to a JSON object compatible with Protobuf.
  Map<String, dynamic> toProtoJson();
}

/// Extension on List of ProtobufMixin to convert the list of [ProtobufMixin] to a concatenated list of bytes.
extension ProtobufMixinList on List<ProtobufMixin> {
  /// Converts the list of [ProtobufMixin] to a concatenated list of bytes.
  Uint8List toProtoBytes() {
    final List<int> bytes = <int>[];
    for (ProtobufMixin protobufMixin in this) {
      bytes.addAll(protobufMixin.toProtoBytes());
    }
    return Uint8List.fromList(bytes);
  }
}
