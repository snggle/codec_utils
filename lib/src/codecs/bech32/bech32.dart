import 'dart:typed_data';

import 'package:codec_utils/src/utils/bytes_utils.dart';
import 'package:equatable/equatable.dart';

/// Class representing a Bech32 encoded pair
///
/// A Bech32 string consists of two main parts:
/// - The human-readable part (HRP), which indicates the network or context.
/// - The data payload encoded using a 5-bit scheme.
class Bech32 extends Equatable {
  /// The human-readable part (hrp) of the Bech32 encoded pair.
  final String hrp;

  /// The data part of the Bech32 encoded pair.
  final Uint8List uint8List;

  const Bech32(this.hrp, this.uint8List);

  factory Bech32.fromUint5List(String hrp, List<int> uint5List) {
    Uint8List uint8List = BytesUtils.convertBits(uint5List, 5, 8);
    return Bech32(hrp, uint8List);
  }

  List<int> get uint5List {
    return BytesUtils.convertBits(uint8List, 8, 5, allowPaddingBool: false);
  }

  @override
  List<Object?> get props => <Object?>[hrp, uint8List];
}
