import 'dart:typed_data';

import 'package:codec_utils/src/codecs/protobuf/protobuf_encoder.dart';
import 'package:codec_utils/src/codecs/protobuf/protobuf_mixin.dart';
import 'package:equatable/equatable.dart';

/// The Any message type lets you use messages as embedded types without having their .proto definition.
/// An Any contains an arbitrary serialized message as bytes, along with a URL that acts as a globally
/// unique identifier for and resolves to that message’s type.
///
/// https://protobuf.dev/programming-guides/proto3/#any
class ProtobufAny with ProtobufMixin, EquatableMixin {
  /// The URL type of the Protobuf message.
  final String typeUrl;

  /// Constructs a [ProtobufAny] with the provided type amino and type URL.
  const ProtobufAny({
    required this.typeUrl,
  });

  /// Packs the Protobuf message into a Uint8List, encoding the typeUrl and the message bytes.
  Uint8List packAny() {
    return Uint8List.fromList(<int>[
      ...ProtobufEncoder.encode(1, typeUrl),
      ...ProtobufEncoder.encode(2, toProtoBytes()),
    ]);
  }

  /// Returns Any type as a Uint8List (empty by default)
  @override
  Uint8List toProtoBytes() => Uint8List(0);

  /// Returns Any type as a Map<String, dynamic> with the type URL.
  @override
  Map<String, dynamic> toProtoJson() => <String, dynamic>{'@type': typeUrl};

  @override
  List<Object?> get props => <Object>[typeUrl];
}
