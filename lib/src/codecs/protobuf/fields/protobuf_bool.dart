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

/// Represents a boolean value encoded as an `int` in Protobuf format.
/// This class extends [ProtobufInt32], storing a boolean value as 0 or 1.
class ProtobufBool extends ProtobufInt32 {
  /// The encoding type for this class, set to varint.
  static const ProtobufWireType wireType = ProtobufWireType.varint;

  /// Constructs a [ProtobufBool] object, converting a boolean value to an integer value of 0 or 1.
  // ignore: avoid_positional_boolean_parameters
  const ProtobufBool(bool value) : super(value ? 1 : 0);

  /// Determines whether the value has the default value (false).
  @override
  bool hasDefaultValue() => value == 0;
}
