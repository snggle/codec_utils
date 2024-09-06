import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// Class representing a Bech32 encoded pair
class Bech32Pair extends Equatable {
  /// The human-readable part (hrp) of the Bech32 encoded pair.
  final String hrp;

  /// The data part of the Bech32 encoded pair.
  final Uint8List data;

  /// Creates a [Bech32Pair] with the given [hrp] and [data].
  const Bech32Pair({
    required this.hrp,
    required this.data,
  });

  @override
  List<Object?> get props => <Object?>[hrp, data];
}
