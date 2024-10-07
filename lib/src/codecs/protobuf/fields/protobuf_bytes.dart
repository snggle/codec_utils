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

/// Represents a byte array encoded in Protobuf format.
/// This class extends [AProtobufField], storing a list of integers (bytes).
class ProtobufBytes extends AProtobufField {
  /// The wire type for this class, set to len for length-delimited fields.
  static const ProtobufWireType wireType = ProtobufWireType.len;

  /// A list of integers representing the byte data.
  final List<int> value;

  /// Constructs a [ProtobufBytes] object with the given byte list.
  const ProtobufBytes(this.value);

  /// Encodes the field number and byte list into a Protobuf format.
  @override
  List<int> encode(int fieldNumber) {
    List<int> result = <int>[
      ...ProtobufUtils.encodeLength(fieldNumber, value.length),
      ...value,
    ];

    return result;
  }

  /// Checks if the byte list is empty, indicating the default value.
  @override
  bool hasDefaultValue() => value.isEmpty;

  @override
  List<Object?> get props => <Object?>[value];
}
