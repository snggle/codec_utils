import 'package:codec_utils/src/codecs/fountain/encoder/fountain_encoder_part.dart';
import 'package:codec_utils/src/codecs/fountain/fountain_utils.dart';
import 'package:equatable/equatable.dart';

/// Represents a part of the data encoded by a fountain coding scheme.
class FountainDecoderPart extends Equatable {
  /// A list of integers representing the indexes of the original data this part corresponds to.
  final List<int> indexes;

  /// The fragment of data that this part carries.
  /// This is a subset of the original data and is used in conjunction with other parts to reconstruct the full data set.
  final List<int> fragment;

  /// Creates a new instance of FountainDecoderPart with the specified indexes and fragment.
  const FountainDecoderPart({
    required this.indexes,
    required this.fragment,
  });

  /// Creates a [FountainDecoderPart] from a [FountainEncoderPart].
  factory FountainDecoderPart.fromEncoderPart(FountainEncoderPart fountainEncoderPart) {
    List<int> indexes = FountainUtils.chooseFragments(
      fountainEncoderPart.sequenceNumber,
      fountainEncoderPart.sequenceLength,
      fountainEncoderPart.checksum,
    );

    return FountainDecoderPart(
      indexes: indexes,
      fragment: fountainEncoderPart.fragment,
    );
  }

  /// Indicates whether this part is simple, meaning it corresponds to a single index in the original data.
  bool get isSimple {
    return indexes.length == 1;
  }

  @override
  List<Object?> get props => <Object?>[indexes, fragment];
}
