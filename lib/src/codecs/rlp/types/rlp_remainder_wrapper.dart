// Class was shaped by the influence of JavaScript key sources including:
// https://github.com/ethereumjs/ethereumjs-monorepo/tree/master/packages/rlp
//
// Mozilla Public License Version 2.0
part of '../rlp_codec.dart';

/// Wraps an RLP-encoded element along with remainder data that was a part of the initial decoding process.
/// This class handles cases where RLP data is parsed incrementally and there might be leftover bytes after parsing the main content.
class RLPRemainderWrapper extends Equatable {
  /// The RLP element that has been decoded.
  final IRLPElement data;

  /// The remainder of the data that was included in the initial RLP decoding.
  /// This can include extra bytes that follow the primary encoded element, which might be part of subsequent encodings.
  final Uint8List remainder;

  /// Constructs an [RLPRemainderWrapper] with the specified decoded RLP element and the remainder of the data.
  const RLPRemainderWrapper({
    required this.data,
    required this.remainder,
  });

  @override
  List<Object?> get props => <Object>[data, remainder];
}
