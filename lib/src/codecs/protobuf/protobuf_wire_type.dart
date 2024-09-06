enum ProtobufWireType {
  /// Used for int32, int64, uint32, uint64, sint32, sint64, bool, enum
  varint(0),

  /// Used for fixed64, sfixed64, double
  i64(1),

  /// Used for string, bytes, embedded messages, packed repeated fields
  len(2),

  /// Used for group start (deprecated)
  sgroup(3),

  /// Used for group end (deprecated)
  egroup(4),

  /// Used for fixed32, fixed32, float
  i32(5);

  final int id;

  const ProtobufWireType(this.id);
}
