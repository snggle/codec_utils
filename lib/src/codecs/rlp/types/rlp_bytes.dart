// Class was shaped by the influence of JavaScript key sources including:
// https://github.com/ethereumjs/ethereumjs-monorepo/tree/master/packages/rlp
//
// Mozilla Public License Version 2.0
part of '../rlp_codec.dart';

/// Represents a byte array element that can be encoded using the Recursive Length Prefix (RLP) encoding scheme.
class RLPBytes extends Equatable implements IRLPElement {
  /// The byte data to be encoded.
  final Uint8List data;

  /// Constructs an [RLPBytes] instance directly from [Uint8List] data.
  const RLPBytes(this.data);

  /// Constructs an [RLPBytes] instance from [BigInt] data.
  RLPBytes.fromBigInt(BigInt value) : data = BigIntUtils.changeToBytes(value);

  /// Constructs an [RLPBytes] instance from HEX data.
  RLPBytes.fromHex(String value) : data = HexCodec.decode(value);

  /// Constructs an empty [RLPBytes] instance
  RLPBytes.empty() : data = Uint8List(0);

  /// Encodes the byte array into RLP format. If the data is a single byte less than "0x80", it returns the data directly.
  /// Otherwise, it prepends the length of the data to the data itself, adjusting for RLP encoding requirements.
  @override
  Uint8List encode() {
    if (data.length == 1 && data.first < 128) {
      return data;
    } else {
      return Uint8List.fromList(<int>[...RLPUtils.encodeLength(data.length, 128), ...data]);
    }
  }

  /// Converts the byte array to a [BigInt].
  BigInt toBigInt() {
    return BigIntUtils.decode(data);
  }

  /// Converts the byte array to a HEX string.
  String toHex() {
    return HexCodec.encode(data, includePrefixBool: true);
  }

  @override
  List<Object?> get props => <Object>[data];
}
