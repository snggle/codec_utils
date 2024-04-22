// Class was shaped by the influence of JavaScript key sources including:
// "bc-ur" Copyright (c) 2021 NGRAVE
// https://github.com/ngraveio/bc-ur
//
// MIT License
//
// Copyright (c) 2021 NGRAVE
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:typed_data';

import 'package:codec_utils/src/codecs/bytewords/bytewords_style.dart';
import 'package:codec_utils/src/codecs/hex/hex_codec.dart';
import 'package:codec_utils/src/utils/crc32.dart';

/// [BytewordsCodec] class is designed for encoding and decoding data using the Bytewords format.
///
/// Bytewords is a method for representing binary data in a human-readable and easily transcribe word format.
/// This class provides functionality to transform binary data into Bytewords and back.
class BytewordsCodec {
  /// String containing a concatenated list of 256 four-letter bytewords used for encoding.
  static const String _bytewords =
      'ableacidalsoapexaquaarchatomauntawayaxisbackbaldbarnbeltbetabiasbluebodybragbrewbulbbuzzcalmcashcatschefcityclawcodecolacookcostcruxcurlcuspcyandarkdatadaysdelidicedietdoordowndrawdropdrumdulldutyeacheasyechoedgeepicevenexamexiteyesfactfairfernfigsfilmfishfizzflapflewfluxfoxyfreefrogfuelfundgalagamegeargemsgiftgirlglowgoodgraygrimgurugushgyrohalfhanghardhawkheathelphighhillholyhopehornhutsicedideaidleinchinkyintoirisironitemjadejazzjoinjoltjowljudojugsjumpjunkjurykeepkenokeptkeyskickkilnkingkitekiwiknoblamblavalazyleaflegsliarlimplionlistlogoloudloveluaulucklungmainmanymathmazememomenumeowmildmintmissmonknailnavyneednewsnextnoonnotenumbobeyoboeomitonyxopenovalowlspaidpartpeckplaypluspoempoolposepuffpumapurrquadquizraceramprealredorichroadrockroofrubyruinrunsrustsafesagascarsetssilkskewslotsoapsolosongstubsurfswantacotasktaxitenttiedtimetinytoiltombtoystriptunatwinuglyundouniturgeuservastveryvetovialvibeviewvisavoidvowswallwandwarmwaspwavewaxywebswhatwhenwhizwolfworkyankyawnyellyogayurtzapszerozestzinczonezoom';

  /// The fixed length (4 characters) of each byteword in the [_bytewords] string.
  static const int _bytewordLength = 4;

  /// The minimum length of bytewords to be considered for encoding, providing flexibility in encoding strategies.
  static const int _minimalBytewordLength = 2;

  /// The total number of bytewords available, allowing each word to uniquely represent a byte value.
  static const int _bytewordsNum = 256;

  /// Decodes Bytewords back into binary data.
  static String encode(Uint8List data, BytewordsStyle bytewordsStyle) {
    switch (bytewordsStyle) {
      case BytewordsStyle.standard:
        return _encodeWithSeparator(data, ' ');
      case BytewordsStyle.uri:
        return _encodeWithSeparator(data, '-');
      case BytewordsStyle.minimal:
        return _encodeMinimal(data);
      default:
        throw Exception('Invalid style ${bytewordsStyle}');
    }
  }

  /// Encodes binary data into Bytewords
  static Uint8List decode(String data, BytewordsStyle bytewordsStyle) {
    switch (bytewordsStyle) {
      case BytewordsStyle.standard:
        return _decode(data, ' ', _bytewordLength);
      case BytewordsStyle.uri:
        return _decode(data, '-', _bytewordLength);
      case BytewordsStyle.minimal:
        return _decode(data, '', _minimalBytewordLength);
      default:
        throw Exception('Invalid style ${bytewordsStyle}');
    }
  }

  /// Encodes binary data into Bytewords with a separator between each word.
  static String _encodeWithSeparator(Uint8List data, String separator) {
    Uint8List crcAppendedData = _addCRC(data);
    List<String> result = <String>[];
    for (int i = 0; i < crcAppendedData.length; i++) {
      result.add(_getWord(crcAppendedData[i]));
    }

    return result.join(separator);
  }

  /// Encodes binary data into Bytewords with a minimal representation.
  static String _encodeMinimal(Uint8List data) {
    Uint8List crcAppendedData = _addCRC(data);
    List<String> result = <String>[];
    for (int i = 0; i < crcAppendedData.length; i++) {
      result.add(_getMinimalWord(crcAppendedData[i]));
    }

    return result.join();
  }

  /// Adds a CRC32 checksum to the data.
  static Uint8List _addCRC(Uint8List data) {
    String dataHex = HexCodec.encode(data);
    String crc = CRC32.getHex(data);

    String dataWithCrc = '$dataHex$crc';
    return HexCodec.decode(dataWithCrc);
  }

  /// Decodes Bytewords back into binary data.
  static Uint8List _decode(String data, String separator, int wordLength) {
    List<String> words = wordLength == _bytewordLength ? data.split(separator) : _partition(data, 2);
    String decodedData = words.map((String word) => _decodeWord(word, wordLength)).join('');

    if (decodedData.length < 5) {
      throw Exception('Invalid Bytewords: invalid decoded string length: ${decodedData.length}');
    }

    List<int> decodedDataBytes = HexCodec.decode(decodedData);
    List<int> body = decodedDataBytes.sublist(0, decodedDataBytes.length - 4);
    String bodyChecksum = HexCodec.encode(decodedDataBytes.sublist(body.length));

    String checksum = CRC32.getHex(body);

    if (checksum != bodyChecksum) {
      throw Exception('Invalid Bytewords: Invalid checksum. Expected $checksum, got $bodyChecksum');
    }

    return Uint8List.fromList(body);
  }

  /// Partitions a string into chunks of the specified [size].
  static List<String> _partition(String data, int size) {
    RegExp pattern = RegExp('.{1,$size}');
    return pattern.allMatches(data).map((Match m) => m.group(0)!).toList();
  }

  /// Decodes a single Byteword into a byte value.
  static String _decodeWord(String word, int wordLength) {
    if (word.length != wordLength) {
      throw Exception('Invalid word length ${word.length}');
    }

    int dim = 26;

    // Since the first and last letters of each Byteword are unique,
    // we can use them as indexes into a two-dimensional lookup table.
    // This table is generated lazily.
    List<int> bytewordsLookUpTable = List<int>.generate(dim * dim, (int i) => -1);

    for (int i = 0; i < _bytewordsNum; i++) {
      String byteword = _getWord(i);
      int x = byteword[0].codeUnitAt(0) - 'a'.codeUnitAt(0);
      int y = byteword[3].codeUnitAt(0) - 'a'.codeUnitAt(0);
      int offset = y * dim + x;
      bytewordsLookUpTable[offset] = i;
    }

    // If the coordinates generated by the first and last letters are out of bounds,
    // or the lookup table contains -1 at the coordinates, then the word is not valid.
    int x = word[0].toLowerCase().codeUnitAt(0) - 'a'.codeUnitAt(0);
    int y = word[wordLength == 4 ? 3 : 1].toLowerCase().codeUnitAt(0) - 'a'.codeUnitAt(0);

    if ((x < 0 || x >= dim) || (y < 0 || y >= dim)) {
      throw Exception('Invalid Bytewords: Invalid word');
    }

    int offset = y * dim + x;
    int value = bytewordsLookUpTable[offset];

    if (value == -1) {
      throw Exception('Invalid Bytewords: Value not in lookup table');
    }

    // If we're decoding a full four-letter word, verify that the two middle letters are correct.
    if (wordLength == _bytewordLength) {
      String byteword = _getWord(value);
      String c1 = word[1].toLowerCase();
      String c2 = word[2].toLowerCase();

      if (c1 != byteword[1] || c2 != byteword[2]) {
        throw Exception('Invalid Bytewords: invalid middle letters of word');
      }
    }

    return value.toRadixString(16).padLeft(2, '0');
  }

  /// Returns the shortened Byteword corresponding to the given byte value.
  static String _getMinimalWord(int index) {
    String byteword = _getWord(index);

    return '${byteword[0]}${byteword[_bytewordLength - 1]}';
  }

  /// Returns the Byteword corresponding to the given byte value.
  static String _getWord(int index) {
    return _bytewords.substring(index * _bytewordLength, (index * _bytewordLength) + _bytewordLength);
  }
}
