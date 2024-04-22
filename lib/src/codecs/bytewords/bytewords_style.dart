/// Defines the encoding styles for Bytewords to adjust the output format according to different needs or specifications.
enum BytewordsStyle {
  /// The standard style uses the default encoding approach, suitable for general purposes.
  standard,

  /// The URI style adapts the encoding to be safe and efficient for use within URIs, possibly altering character usage.
  uri,

  /// The minimal style uses the shortest possible bytewords, focusing on reducing the length of the encoded result.
  minimal,
}
