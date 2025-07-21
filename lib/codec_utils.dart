library codec_utils;

/// The [Base58Codec] class is designed for encoding data using the Base58 encoding scheme.
/// Usage:
///  ```
///  String encodedBase58 = Base58Codec.encodeWithChecksum(<int>[1, 2, 3, 4, 5]);
///  String encodedBase58 = Base58Codec.encode(<int>[1, 2, 3, 4, 5]);
///  Uint8List decodedBase58 = Base58Codec.decode("aXQWBu6W");
///  ```
export 'src/codecs/base/base58_codec.dart';
/// Classes designed for encoding data using the Bech32 encoding scheme.
/// Usage:
///  ```
///  String encodedBech32 = Bech32Codec.encode(Bech32Pair(hrp: 'crypto', data: base64Decode('KxmiVli7oFEs8N5rjnzLtw7eym0=')));
///  Bech32Pair decodedBech32 = Bech32Codec.decode("crypto19vv6y4jchws9zt8sme4culxtku8dajndgyhdm2");
///
///  String encodedSegwit = SegwitBech32Codec.encode('bc', 0, base64Decode('KxmiVli7oFEs8N5rjnzLtw7eym0='));
///  Uint8List decodedSegwit = SegwitBech32Codec.decode("bc1q9vv6y4jchws9zt8sme4culxtku8dajnd5jq660");
///  ```
export 'src/codecs/bech32/export.dart';

export 'src/codecs/byte_reader/byte_reader.dart';
/// Defines available CBOR data structures
export 'src/codecs/cbor/export.dart';

export 'src/codecs/compact_u16/export.dart';
/// The [HexCodec] class is designed for encoding and decoding data using the hexadecimal encoding scheme.
/// Usage:
///  ```
///  String encodedHex = HexCodec.encode(<int>[1, 2, 3, 4, 5]);
///  Uint8List decodedHex = HexCodec.decode("0102030405");
///  ```
export 'src/codecs/hex/hex_codec.dart';
/// Classes for encoding cosmos messages using minimal protobuf encoding.
/// Usage:
///  ```
///  List<int> ProtobufEncoder.encode(1, protobufMessage);
///  ```
export 'src/codecs/protobuf/export.dart';
///  Provides static utility methods for encoding and decoding data using the Recursive Length Prefix (RLP) encoding scheme.
///  Usage:
///   ```
///   Uint8List encodedRlp = RLP.encode(RLPBytes());
///   IRLPElement decodedRlp = RLP.decode(encodedRlp);
///   ```
export 'src/codecs/rlp/rlp_codec.dart';
/// Defines Uniform Resource (UR) object, containing CBOR encoded data from QR code.
/// Usage:
///   ```
///   // Returns UR object with given type and CBOR encoded data
///   UR ur = UR(type: 'crypto-seed', cborPayload: cborData);
///
///   // Returns UR object from given [IURRegistryRecord]
///   Ur ur = UR.fromCborTaggedObject(cborTaggedObject);
///
///   // Returns empty CBOR value
///   Ur ur = UR.empty();
///
///   // Decodes CBOR payload of UR into CBOR value
///   CborValue cborValue = ur.decodeCborPayload();
///   ```
export 'src/codecs/uniform_resource/ur.dart';
/// Provides functionality to decode data from Uniform Resource (UR) format from single or multi UR resource
/// Usage:
///   ```
///   // Construct URDecoder
///   URDecoder urDecoder = URDecoder();
///
///   // After reading UR data from QR code, pass it to URDecoder
///   urDecoder.receivePart(urPart);
///
///   // Check if URDecoder received whole data
///   bool receivedWholeDataBool = urDecoder.isComplete;
///
///   // Return received data as [ICborTaggedObject] if possible
///   ICborTaggedObject? cborTaggedObject = urDecoder.buildCborTaggedObject();
///
///   // Return received data as [UR] if possible
///   UR? ur = urDecoder.buildUR();
///
///   // Return received parts percentage
///   double progress = urDecoder.progress;
///
///   // Return estimated percentage of received data
///   double estimatedPercentComplete = urDecoder.estimatedPercentComplete;
///
///   // Return total parts count expected in current transfer
///   int expectedPartCount = urDecoder.expectedPartCount;
///   ```
export 'src/codecs/uniform_resource/ur_decoder.dart';
/// Provides functionality to encode data into Uniform Resource (UR) format
/// Usage:
///   ```
///   // Construct UREncoder
///   UREncoder urEncoder = UREncoder(ur: ur);
///
///   // Encode whole data to transfer into UR format
///   List<String> parts = urEncoder.encodeWhole();
///
///   // Return total parts count expected in current transfer
///   int fragmentsCount = urEncoder.fragmentsCount;
///
///   // Encode next part of data to transfer into UR format
///   String part = urEncoder.nextPart();
///
///   // Return whether all parts were encoded
///   bool transferCompletedBool = urEncoder.isComplete;
///
///   // Reset UREncoder to start encoding from beginning
///   urEncoder.reset();
///   ```
export 'src/codecs/uniform_resource/ur_encoder.dart';
