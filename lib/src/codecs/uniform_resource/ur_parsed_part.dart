import 'package:equatable/equatable.dart';

/// Class representing a parsed part of a Uniform Resource (UR).
class URParsedPart extends Equatable {
  /// The type of the UR part, generally indicating the nature of the data contained in the [components].
  final String type;

  /// The components of the UR part, typically stored as a list of strings.
  /// One length UR part will have a single component (data), while multi-part UR parts will have two components (sequence and data).
  final List<String> components;

  const URParsedPart({required this.type, required this.components});

  /// Checks whether the UR part has the specified type.
  bool hasType(String type) {
    return this.type == type;
  }

  /// Checks whether the UR part is a single part UR.
  bool get isSinglePartUR => components.length == 1;

  @override
  List<Object> get props => <Object>[type, components];
}
