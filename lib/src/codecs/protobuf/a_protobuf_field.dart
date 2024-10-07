import 'package:equatable/equatable.dart';

/// An abstract base class representing a Protobuf field.
/// It provides a common interface for encoding fields and checking for default values.
abstract class AProtobufField with EquatableMixin {
  /// Constructs a [AProtobufField] object.
  const AProtobufField();

  /// Encodes the Protobuf field using the provided field number.
  List<int> encode(int fieldNumber);

  /// Checks if the field has a default value.
  /// By default, returns `false` unless overridden.
  bool hasDefaultValue() => false;
}
