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

import 'package:codec_utils/codec_utils.dart';
import 'package:codec_utils/src/codecs/protobuf/protobuf_utils.dart';

/// Represents a 64-bit integer value in Protobuf format.
/// This class extends [AProtobufField] and is responsible for encoding 64-bit integers using Protobuf varint encoding scheme.
class ProtobufInt64 extends AProtobufField {
  /// The encoding type for this class, set to varint.
  static const ProtobufWireType wireType = ProtobufWireType.varint;

  /// The 64-bit integer value stored by this Protobuf field.
  final BigInt value;

  /// Constructs a [ProtobufInt64] object with the given BigInt value.
  const ProtobufInt64(this.value);

  /// Encodes the 64-bit integer value along with its field number using varint encoding.
  /// Applies ZigZag encoding for negative numbers to optimize their representation.
  @override
  List<int> encode(int fieldNumber) {
    List<int> result = <int>[];

    int tag = ProtobufUtils.createTag(fieldNumber, wireType);
    result.addAll(ProtobufUtils.encodeVarint32(tag));

    BigInt maybeZigZag = value;
    if (value.isNegative) {
      maybeZigZag = (value & ProtobufUtils.maxInt64) | ProtobufUtils.minInt64;
    }

    result.addAll(ProtobufUtils.encodeVarint64(maybeZigZag));
    return result;
  }

  /// Determines whether the value has the default value (0).
  @override
  bool hasDefaultValue() => value == BigInt.zero;

  @override
  List<Object?> get props => <Object?>[value];
}
