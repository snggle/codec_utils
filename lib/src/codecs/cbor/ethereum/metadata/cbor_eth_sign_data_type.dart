/// Metadata for the signing request for Ethereum.
enum CborEthSignDataType {
  /// Legacy transaction rlp encoding of unsigned transaction data
  transactionData(1),

  /// EIP-712 typed signing data
  typedData(2),

  /// For signing message usage, like EIP-191 personal sign data
  rawBytes(3),

  /// EIP-2718 typed transaction of unsigned transaction data
  typedTransaction(4);

  final int cborIndex;

  const CborEthSignDataType(this.cborIndex);

  factory CborEthSignDataType.fromCborIndex(int cborIndex) {
    return CborEthSignDataType.values.firstWhere((CborEthSignDataType type) => type.cborIndex == cborIndex);
  }
}
