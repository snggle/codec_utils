import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// A class representing a Segregated Witness (SegWit) address.
///
/// This class holds the human-readable part (HRP), witness version,
/// and witness program list as defined in BIP 173.
///
/// You can use this class to represent or validate SegWit addresses in Bech32 encoding.
class SegWit extends Equatable {
  /// The human-readable part ("bc" for Bitcoin mainnet).
  final String hrp;

  /// The witness version (0–16).
  final int witnessVersion;

  /// The witness program data as a list of integers.
  final Uint8List witnessProgramUint8List;

  const SegWit(this.hrp, this.witnessVersion, this.witnessProgramUint8List);

  @override
  List<Object?> get props => <Object>[hrp, witnessVersion, witnessProgramUint8List];
}
