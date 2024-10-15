import 'package:codec_utils/codec_utils.dart';

/// A utility class for various Protobuf-related encoding operations.
/// It provides methods for encoding integers and managing Protobuf field tags.
class ProtobufUtils {
  /// The maximum value for a 64-bit signed integer in Protobuf format.
  static final BigInt maxInt64 = BigInt.parse('7FFFFFFFFFFFFFFF', radix: 16);

  /// The minimum value for a 64-bit signed integer in Protobuf format.
  static final BigInt minInt64 = BigInt.parse('8000000000000000', radix: 16);

  /// Encodes the length of a field along with its field number using varint encoding.
  /// This is used for length-delimited fields.
  static List<int> encodeLength(int fieldNumber, int value) {
    int tag = ProtobufUtils.createTag(fieldNumber, ProtobufWireType.len);
    return <int>[
      ...ProtobufUtils.encodeVarint32(tag),
      ...ProtobufUtils.encodeVarint32(value),
    ];
  }

  /// Creates a Protobuf field tag by combining the field number and wire type.
  static int createTag(int fieldNumber, ProtobufWireType protobufWireType) {
    return (fieldNumber << 3) | protobufWireType.id;
  }

  /// Encodes a 32-bit integer using varint encoding.
  static List<int> encodeVarint32(int inputValue) {
    int value = inputValue;
    List<int> result = <int>[];
    while (value > 0x7F) {
      result.add((value & 0x7F) | 0x80);
      value >>= 7;
    }
    result.add(value);
    return result;
  }

  /// Encodes a 64-bit integer using varint encoding.
  static List<int> encodeVarint64(BigInt inputValue) {
    BigInt value = inputValue;
    List<int> result = <int>[];
    while (value > BigInt.from(0x7F)) {
      result.add((value & BigInt.from(0x7F) | BigInt.from(0x80)).toInt());
      value >>= 7;
    }
    result.add(value.toInt());
    return result;
  }
}
