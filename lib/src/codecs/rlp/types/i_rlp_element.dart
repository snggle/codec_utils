part of '../rlp_codec.dart';

/// An interface class representing an element that can be encoded using the Recursive Length Prefix (RLP) encoding scheme.
/// RLP is primarily used in Ethereum for encoding structured data (like transactions and blocks) into a byte array,
/// facilitating data serialization and deserialization.
///
/// Subclasses of [IRLPElement] should implement the [encode] method to specify how the element should be encoded
/// into a [Uint8List] according to RLP specifications.
abstract class IRLPElement {
  /// Encodes this element into a `Uint8List` using the RLP encoding scheme.
  /// Implement this method to define how each specific subclass should be encoded.
  Uint8List encode();
}
