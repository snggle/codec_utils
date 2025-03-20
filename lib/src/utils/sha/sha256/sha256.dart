//This class was primarily influenced by:
// Copyright 2015, the Dart project authors.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
// * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following
// disclaimer in the documentation and/or other materials provided
// with the distribution.
// * Neither the name of Google LLC nor the names of its
// contributors may be used to endorse or promote products derived
// from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
import 'dart:convert';

import 'package:codec_utils/src/utils/sha/hash/a_hash.dart';
import 'package:codec_utils/src/utils/sha/hash/digest.dart';
import 'package:codec_utils/src/utils/sha/sha256/sha256_sink.dart';

/// [Sha256] is a singleton implementation of the SHA-256 hashing algorithm - defines the block size.
/// This class, with its implementation of the SHA-256 algorithm, is not compatible with the AMD4Digest class.
class Sha256 extends AHash {
  static const int _bytesPerWord = 4;
  static final Sha256 _sha256 = Sha256._();

  factory Sha256() => _sha256;

  Sha256._();

  @override
  int get blockSize => 16 * _bytesPerWord;

  @override
  ByteConversionSink startChunkedConversion(Sink<Digest> sink) => ByteConversionSink.from(Sha256Sink(sink));
}
