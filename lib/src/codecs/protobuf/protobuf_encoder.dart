// Class was shaped by the influence of several key sources including:
// "cosmos_sdk" - Copyright 2023 MRTNETWORK
// https://github.com/mrtnetwork/cosmos_sdk
//
// BSD 3-Clause License
//
// Copyright 2023 MRTNETWORK
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// * Neither the name of the copyright holder nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'dart:convert';

import 'package:codec_utils/src/codecs/protobuf/protobuf_any.dart';
import 'package:codec_utils/src/codecs/protobuf/protobuf_enum.dart';
import 'package:codec_utils/src/codecs/protobuf/protobuf_mixin.dart';
import 'package:codec_utils/src/codecs/protobuf/protobuf_wire_type.dart';

/// Class for encoding messages using minimal protobuf encoding.
class ProtobufEncoder {
  static final BigInt _maxInt64 = BigInt.parse('7FFFFFFFFFFFFFFF', radix: 16);
  static final BigInt _minInt64 = BigInt.parse('8000000000000000', radix: 16);

  static const int int32BitLength = 31;

  /// Encode a protobuf field with the given [fieldNumber] and [value].
  static List<int> encode(int fieldNumber, dynamic value) {
    if (value == null) {
      return <int>[];
    }

    switch (value) {
      case bool boolValue:
        return _encodeBool(fieldNumber, boolValue);
      case ProtobufEnum protobufEnum:
        return _encodeInt(fieldNumber, protobufEnum.value);
      case ProtobufAny cosmosAny:
        return _encodeBytes(fieldNumber, cosmosAny.packAny());
      case ProtobufMixin protobufMixin:
        return _encodeBytes(fieldNumber, protobufMixin.toProtoBytes());
      case int intValue:
        return _encodeInt(fieldNumber, intValue);
      case BigInt bigInt:
        return _encodeBigInt(fieldNumber, bigInt);
      case List<int> listInt:
        return _encodeBytes(fieldNumber, listInt);
      case String string:
        return _encodeBytes(fieldNumber, utf8.encode(string));
      case List<dynamic> list:
        return _encodeList(fieldNumber, list);
      case Map<dynamic, dynamic> map:
        return _encodeMap(fieldNumber, map);
      default:
        throw FormatException('Unsupported type: ${value.runtimeType}');
    }
  }

  /// Encode a boolean with the given [fieldNumber] and [value].
  static List<int> _encodeBool(int fieldNumber, bool value) {
    return _encodeInt(fieldNumber, value ? 1 : 0);
  }

  /// Encode an [int] with the given [fieldNumber]
  static List<int> _encodeInt(int fieldNumber, int value) {
    List<int> result = <int>[];
    int tag = _createTag(fieldNumber, ProtobufWireType.varint);

    result.addAll(_encodeVarint32(tag));
    if (value.isNegative) {
      BigInt zigzag = (BigInt.from(value) & _maxInt64) | _minInt64;
      result.addAll(_encodeVarintBigInt(zigzag));
      return result;
    }
    result.addAll(_encodeVarint32(value));

    return result;
  }

  /// Encode a [BigInt] with the given [fieldNumber] and [value].
  static List<int> _encodeBigInt(int fieldNumber, BigInt value) {
    List<int> result = <int>[];

    int tag = _createTag(fieldNumber, ProtobufWireType.varint);
    BigInt mybeZigZag = value;
    if (value.isNegative) {
      mybeZigZag = (value & _maxInt64) | _minInt64;
    }

    // Encode the tag and value into varint format
    result
      ..addAll(_encodeVarint32(tag))
      ..addAll(_encodeVarintBigInt(mybeZigZag));
    return result;
  }

  /// Encode a byte array with the given [fieldNumber] and [value].
  static List<int> _encodeBytes(int fieldNumber, List<int> value) {
    List<int> result = <int>[
      ..._encodeLength(fieldNumber, value.length),
      ...value,
    ];

    return result;
  }

  /// Encode a list with the given [fieldNumber] and [value].
  static List<int> _encodeList(int fieldNumber, List<dynamic> value) {
    if (value.isEmpty) {
      return <int>[];
    }
    List<int> result = <int>[];
    for (dynamic element in value) {
      result.addAll(encode(fieldNumber, element));
    }
    return result;
  }

  /// Encode a [Map] with the given [fieldNumber] and [value].
  static List<int> _encodeMap(int fieldNumber, Map<dynamic, dynamic> value) {
    List<int> result = <int>[];
    for (MapEntry<dynamic, dynamic> i in value.entries) {
      List<int> key = encode(1, i.key);
      List<int> val = encode(2, i.value);
      result
        ..addAll(_encodeLength(fieldNumber, key.length + val.length))
        ..addAll(key)
        ..addAll(val);
    }
    return result;
  }

  /// Encode length of the data for the given [fieldNumber] and [value].
  static List<int> _encodeLength(int fieldNumber, int value) {
    int tag = _createTag(fieldNumber, ProtobufWireType.len);
    return <int>[..._encodeVarint32(tag), ..._encodeVarint32(value)];
  }

  /// Encode a 32-bit varint with the given [inputValue].
  static List<int> _encodeVarint32(int inputValue) {
    int value = inputValue;
    List<int> result = <int>[];
    while (value > 0x7F) {
      result.add((value & 0x7F) | 0x80);
      value >>= 7;
    }
    result.add(value);
    return result;
  }

  /// Utility function to encode a 64-bit varint.
  static List<int> _encodeVarintBigInt(BigInt inputValue) {
    BigInt value = inputValue;
    List<int> result = <int>[];
    while (value > BigInt.from(0x7F)) {
      result.add((value & BigInt.from(0x7F) | BigInt.from(0x80)).toInt());
      value >>= 7;
    }
    result.add(value.toInt());
    return result;
  }

  static int _createTag(int fieldNumber, ProtobufWireType protobufWireType) {
    return (fieldNumber << 3) | protobufWireType.id;
  }
}
