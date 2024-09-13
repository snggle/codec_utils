// Class was shaped by the influence of JavaScript key sources including:
// https://github.com/ethereumjs/ethereumjs-monorepo/tree/master/packages/rlp
//
// Mozilla Public License Version 2.0

import 'dart:typed_data';

import 'package:codec_utils/src/codecs/hex/hex_codec.dart';
import 'package:codec_utils/src/utils/big_int_utils.dart';
import 'package:equatable/equatable.dart';

part 'types/i_rlp_element.dart';

part 'types/rlp_bytes.dart';

part 'types/rlp_list.dart';

part 'types/rlp_remainder_wrapper.dart';

part 'rlp_utils.dart';

/// Provides static utility methods for encoding and decoding data using the Recursive Length Prefix (RLP) encoding scheme.
/// RLP is a serialization technique used primarily in the Ethereum protocol to encode nested arrays of binary data,
/// and it's crucial for encoding transactions, blocks, and other structured data.
class RLPCodec {
  /// Encodes an [IRLPElement] into a [Uint8List]. This method allows for converting structured data that implements
  /// the [IRLPElement] interface into a format suitable for transmission or storage.
  static Uint8List encode(IRLPElement input) {
    return input.encode();
  }

  /// Decodes a [Uint8List] into an [IRLPElement]. This method is responsible for interpreting RLP-encoded byte data,
  /// reconstructing the original structured data from its serialized form.
  static IRLPElement decode(Uint8List input) {
    RLPRemainderWrapper decodedRLP = _decode(input);
    if (decodedRLP.remainder.isNotEmpty) {
      throw Exception('Invalid RLP: input was not fully decoded');
    }

    return decodedRLP.data;
  }

  /// Contains a functionality to decode RLP-encoded data incrementally, returning the decoded element along with the remaining data.
  static RLPRemainderWrapper _decode(Uint8List input) {
    int firstByte = input[0];

    if (firstByte <= 0x7f) {
      // Single byte, same as itself
      return RLPRemainderWrapper(data: RLPBytes(input.sublist(0, 1)), remainder: input.sublist(1));
    } else if (firstByte <= 0xb7) {
      // String with length 0-55 bytes
      int length = firstByte - 0x7f;
      Uint8List data = firstByte == 128 ? Uint8List(0) : input.sublist(1, length);
      if (length == 2 && data[0] < 128) {
        throw Exception('Invalid RLP encoding: invalid prefix, single byte < 128 are not prefixed');
      }

      return RLPRemainderWrapper(data: RLPBytes(data), remainder: input.sublist(length));
    } else if (firstByte <= 0xbf) {
      // String with length > 55 bytes
      int lengthOfLength = firstByte - 0xb6;
      if (input.length - 1 < lengthOfLength) {
        throw Exception('Invalid RLP: not enough bytes for string length');
      }
      int length = _decodeLength(input.sublist(1, lengthOfLength));
      if (length <= 55) {
        throw Exception('Invalid RLP: expected string length to be greater than 55');
      }

      return RLPRemainderWrapper(
        data: RLPBytes(input.sublist(lengthOfLength, length + lengthOfLength)),
        remainder: input.sublist(length + lengthOfLength),
      );
    } else if (firstByte <= 0xf7) {
      // List with total payload < 55 bytes
      int length = firstByte - 0xbf;
      Uint8List innerRemainder = input.sublist(1, length);
      List<IRLPElement> decoded = <IRLPElement>[];
      while (innerRemainder.isNotEmpty) {
        RLPRemainderWrapper decodedElement = _decode(innerRemainder);
        decoded.add(decodedElement.data);
        innerRemainder = decodedElement.remainder;
      }

      return RLPRemainderWrapper(data: RLPList(decoded), remainder: input.sublist(length));
    } else {
      // List with total payload >= 55 bytes
      int lengthOfLength = firstByte - 0xf6;
      int length = _decodeLength(input.sublist(1, lengthOfLength));
      if (length < 56) {
        throw Exception('Invalid RLP: encoded list too short');
      }
      int totalLength = lengthOfLength + length;
      if (totalLength > input.length) {
        throw Exception('Invalid RLP: total length is larger than the data');
      }

      Uint8List innerRemainder = input.sublist(lengthOfLength, totalLength);
      List<IRLPElement> decoded = <IRLPElement>[];

      while (innerRemainder.isNotEmpty) {
        RLPRemainderWrapper decodedElement = _decode(innerRemainder);
        decoded.add(decodedElement.data);
        innerRemainder = decodedElement.remainder;
      }

      return RLPRemainderWrapper(data: RLPList(decoded), remainder: input.sublist(totalLength));
    }
  }

  /// Decodes the encoded length of a data element from a given RLP-encoded byte array.
  static int _decodeLength(Uint8List v) {
    if (v[0] == 0) {
      throw Exception('Invalid RLP: extra zeros');
    }
    return int.parse(HexCodec.encode(v), radix: 16);
  }
}
