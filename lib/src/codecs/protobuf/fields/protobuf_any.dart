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

import 'dart:typed_data';

import 'package:codec_utils/codec_utils.dart';

/// Represents a Protobuf Any type, which can contain arbitrary Protobuf messages identified by their type URL.
/// https://protobuf.dev/programming-guides/proto3/#any
class ProtobufAny extends AProtobufObject {
  /// A URL that uniquely identifies the type of the contained Protobuf message
  final String typeUrl;

  /// Constructs a [ProtobufAny] object with the specified type URL.
  const ProtobufAny({
    required this.typeUrl,
  });

  /// Encodes the [ProtobufAny] message by encoding both the type URL
  /// and the Protobuf message bytes using the given field number.
  @override
  List<int> encode(int fieldNumber) {
    return ProtobufBytes(ProtobufEncoder.encode(
      <int, AProtobufField>{
        1: ProtobufString(typeUrl),
        2: ProtobufBytes(toProtoBytes()),
      },
    )).encode(fieldNumber);
  }

  /// Converts the contained message to a byte array in Protobuf format.
  @override
  Uint8List toProtoBytes() => Uint8List(0);

  /// Converts the message to a JSON-compatible format, with the type URL included.
  @override
  Map<String, dynamic> toProtoJson() => <String, dynamic>{'@type': typeUrl};

  @override
  List<Object?> get props => <Object>[typeUrl];
}
