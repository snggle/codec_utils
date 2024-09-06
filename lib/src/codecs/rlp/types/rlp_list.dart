// Class was shaped by the influence of JavaScript key sources including:
// https://github.com/ethereumjs/ethereumjs-monorepo/tree/master/packages/rlp
//
// Mozilla Public License Version 2.0
part of '../rlp_codec.dart';

/// Represents a list of RLP-encoded elements, allowing for the encoding of structured data using
/// the Recursive Length Prefix (RLP) encoding scheme. This class is useful for handling collections of RLP elements.
class RLPList extends Equatable implements IRLPElement {
  /// The list of RLP elements that this [RLPList] encapsulates.
  final List<IRLPElement> data;

  /// Constructs an [RLPList] from a list of [IRLPElement] items.
  const RLPList(this.data);

  /// Encodes the entire list of RLP elements into a single [Uint8List] following RLP encoding rules,
  /// which involves encoding each element and then combining them with the overall length prefix.
  @override
  Uint8List encode() {
    BytesBuilder output = BytesBuilder();
    for (IRLPElement rlpElement in data) {
      output.add(rlpElement.encode());
    }
    return Uint8List.fromList(<int>[...RLPUtils.encodeLength(output.length, 192), ...output.toBytes()]);
  }

  /// Retrieves a [BigInt] from a specific index in the list,
  /// assuming the element at that index is of type [RLPBytes].
  BigInt getBigInt(int index) {
    return (data[index] as RLPBytes).toBigInt();
  }

  /// Retrieves a HEX string from a specific index in the list,
  /// assuming the element at that index is of type [RLPBytes].
  String getHex(int index) {
    return (data[index] as RLPBytes).toHex();
  }

  /// Retrieves an [RLPList] from a specific index in the list,
  /// assuming the element at that index is of type [RLPList].
  RLPList getRLPList(int index) {
    return data[index] as RLPList;
  }

  /// Retrieves an [Uint8List] from a specific index in the list,
  /// assuming the element at that index is of type [RLPBytes].
  Uint8List getUint8List(int index) {
    return (data[index] as RLPBytes).data;
  }

  /// Returns the number of elements in the [RLPList].
  int get length => data.length;

  @override
  List<Object?> get props => <Object>[data];
}
