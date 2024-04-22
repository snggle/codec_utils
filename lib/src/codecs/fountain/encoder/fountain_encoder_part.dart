import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// Represents a part of the message encoded by the [FountainEncoder], useful in a transmission system where data
/// may need to be reconstructed from parts received in non-sequential order or from partial transmissions.
class FountainEncoderPart extends Equatable {
  /// The sequence number of this part, indicating its order within the series of encoded parts.
  final int sequenceNumber;

  /// The total number of parts into which the message is divided, essential for reconstructing the entire message.
  final int sequenceLength;

  /// The total length of the original message, used to verify the completeness of the data upon reassembly.
  final int messageLength;

  /// A checksum for the original message, used to verify the integrity of the data when it is decoded.
  final int checksum;

  /// The actual data fragment of this part, containing a segment of the original message's data.
  final List<int> fragment;

  /// Creates a new instance of [FountainEncoderPart]
  const FountainEncoderPart({
    required this.sequenceNumber,
    required this.sequenceLength,
    required this.messageLength,
    required this.checksum,
    required this.fragment,
  });

  /// Creates a [FountainEncoderPart] from a CBOR-encoded payload.
  factory FountainEncoderPart.fromCborPayload(List<int> cborPayload) {
    CborList cborList = cborDecode(cborPayload) as CborList;

    return FountainEncoderPart(
      sequenceNumber: (cborList.elementAt(0) as CborSmallInt).toInt(),
      sequenceLength: (cborList.elementAt(1) as CborSmallInt).toInt(),
      messageLength: (cborList.elementAt(2) as CborSmallInt).toInt(),
      checksum: (cborList.elementAt(3) as CborSmallInt).toInt(),
      fragment: (cborList.elementAt(4) as CborBytes).bytes,
    );
  }

  /// Converts this part into a CBOR-encoded payload.
  Uint8List toCborPayload() {
    CborList cborList = CborList(<CborValue>[
      CborSmallInt(sequenceNumber),
      CborSmallInt(sequenceLength),
      CborSmallInt(messageLength),
      CborSmallInt(checksum),
      CborBytes(Uint8List.fromList(fragment)),
    ]);

    return Uint8List.fromList(cborEncode(cborList));
  }

  @override
  List<Object?> get props => <Object>[sequenceNumber, sequenceLength, messageLength, checksum, fragment];
}
