import 'package:equatable/equatable.dart';

/// Class representing a Uniform Resource (UR) sequence component.
class URSequenceComponent extends Equatable {
  /// The sequence number of the UR part.
  final int sequenceNumber;

  /// The total length of the UR.
  final int sequenceLength;

  const URSequenceComponent({required this.sequenceNumber, required this.sequenceLength});

  @override
  List<Object> get props => <Object>[sequenceNumber, sequenceLength];
}
