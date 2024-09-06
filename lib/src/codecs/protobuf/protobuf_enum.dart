import 'package:equatable/equatable.dart';

/// Abstract class representing a Protobuf enumeration with a value and a name.
///
/// https://protobuf.dev/programming-guides/enum/
abstract class ProtobufEnum with EquatableMixin {
  /// The value of the enumeration.
  final int value;

  /// The name of the enumeration.
  final String name;

  /// Constructs a [ProtobufEnum] with the provided value and name.
  const ProtobufEnum(this.value, this.name);

  @override
  List<Object?> get props => <Object?>[value, name];
}
