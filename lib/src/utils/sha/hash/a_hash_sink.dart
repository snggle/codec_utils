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
import 'dart:typed_data';

import 'package:codec_utils/src/utils/sha/hash/digest.dart';
import 'package:typed_data/typed_buffers.dart';

/// [AHashSink] is a base class for processing streaming hash input efficiently. It handles incoming data in chunks, manages buffering, and ensures correct endian formatting.
abstract class AHashSink implements Sink<List<int>> {
  static const int bitsPerByte = 8;
  static const int bytesPerWord = 4;
  static const int mask32 = 0xFFFFFFFF;

  final Sink<Digest> _sink;
  final Endian _endian;
  final Uint32List _currentUint8List;
  final int _signatureBytes;
  final Uint8Buffer _pendingUint8Buffer = Uint8Buffer();

  int _lengthInBytes = 0;
  bool _closedBool = false;

  AHashSink(this._sink, int chunkSize, {Endian endian = Endian.big, int signaturesBytes = 8})
      : _endian = endian,
        _signatureBytes = signaturesBytes,
        _currentUint8List = Uint32List(chunkSize);

  @override
  void add(List<int> dataList) {
    if (_closedBool) {
      return;
    }
    _lengthInBytes += dataList.length;
    _pendingUint8Buffer.addAll(dataList);
    _applyIterate();
  }

  @override
  void close() {
    if (_closedBool) {
      return;
    }
    _closedBool = true;
    _finalizeData();
    _applyIterate();
    _sink
      ..add(Digest(_applyByteDigest()))
      ..close();
  }

  Uint32List get digestUint32List;

  void updateHash(Uint32List inputUint32List);

  void _applyIterate() {
    ByteData pendingByteData = _pendingUint8Buffer.buffer.asByteData();
    int pendingData = _pendingUint8Buffer.length ~/ _currentUint8List.lengthInBytes;

    for (int i = 0; i < pendingData; i++) {
      for (int j = 0; j < _currentUint8List.length; j++) {
        _currentUint8List[j] = pendingByteData.getUint32(i * _currentUint8List.lengthInBytes + j * bytesPerWord, _endian);
      }
      updateHash(_currentUint8List);
    }

    _pendingUint8Buffer.removeRange(0, pendingData * _currentUint8List.lengthInBytes);
  }

  Uint8List _applyByteDigest() {
    if (_endian == Endian.host) {
      return digestUint32List.buffer.asUint8List();
    }
    Uint32List cacheUint32List = digestUint32List;
    Uint8List digestUint8List = Uint8List(cacheUint32List.lengthInBytes);
    ByteData currentByteData = digestUint8List.buffer.asByteData();
    for (int i = 0; i < cacheUint32List.length; i++) {
      currentByteData.setUint32(i * bytesPerWord, cacheUint32List[i]);
    }
    return digestUint8List;
  }

  void _finalizeData() {
    _pendingUint8Buffer.add(0x80);
    int contentsLength = _lengthInBytes + 1 + _signatureBytes;
    int finalizedLength = _applyRoundUp(contentsLength, _currentUint8List.lengthInBytes);

    for (int i = 0; i < finalizedLength - contentsLength; i++) {
      _pendingUint8Buffer.add(0);
    }

    int lengthInBits = _lengthInBytes * bitsPerByte;
    int offsetOutput = _pendingUint8Buffer.length + (_signatureBytes - 8);

    _pendingUint8Buffer.addAll(Uint8List(_signatureBytes));

    ByteData currentByteData = _pendingUint8Buffer.buffer.asByteData();
    int highBits = lengthInBits ~/ 0x100000000;
    int lowBits = lengthInBits & mask32;

    if (_endian == Endian.big) {
      currentByteData
        ..setUint32(offsetOutput, highBits, _endian)
        ..setUint32(offsetOutput + bytesPerWord, lowBits, _endian);
    } else {
      currentByteData
        ..setUint32(offsetOutput, lowBits, _endian)
        ..setUint32(offsetOutput + bytesPerWord, highBits, _endian);
    }
  }

  int _applyRoundUp(int value, int multiple) {
    return (value + multiple - 1) & -multiple;
  }
}
