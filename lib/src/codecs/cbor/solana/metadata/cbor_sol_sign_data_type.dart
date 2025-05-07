/// Metadata for the signing request for Solana.
enum CborSolSignDataType {
  transaction(1),
  message(2);

  final int cborIndex;

  const CborSolSignDataType(this.cborIndex);

  factory CborSolSignDataType.fromCborIndex(int cborIndex) {
    return CborSolSignDataType.values.firstWhere((CborSolSignDataType type) => type.cborIndex == cborIndex);
  }
}
