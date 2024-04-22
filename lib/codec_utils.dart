library codec_utils;

/// Defines available CBOR data structures
export 'src/codecs/cbor/export.dart';

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
