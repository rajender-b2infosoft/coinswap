class TransactionDetails {
  final int id;
  final int? senderId;
  final int? receiverId;
  final String? senderWalletAddress;
  final String? receiverWalletAddress;
  final String? transactionType;
  final String? requestId;
  final String? transactionRequestId;
  final String? transactionId;
  final String? note;
  final String? feePriority;
  final String? cryptoType;
  final String? convertedCryptoType;
  final String? network;
  final String? amount;
  final String? commissionAmount;
  final String? commissionAddress;
  final String? transactionFee;
  final String? convertedAmount;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  TransactionDetails({
    required this.id,
    this.senderId,
    this.receiverId,
    this.senderWalletAddress,
    this.receiverWalletAddress,
    this.transactionType,
    this.requestId,
    this.transactionRequestId,
    this.transactionId,
    this.note,
    this.feePriority,
    this.cryptoType,
    this.convertedCryptoType,
    this.network,
    this.amount,
    this.commissionAmount,
    this.commissionAddress,
    this.transactionFee,
    this.convertedAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) {
    return TransactionDetails(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      senderWalletAddress: json['sender_wallet_address'],
      receiverWalletAddress: json['receiver_wallet_address'],
      transactionType: json['transaction_type'],
      requestId: json['requestId'],
      transactionRequestId: json['transactionRequestId'],
      transactionId: json['transactionId'],
      note: json['note'],
      feePriority: json['feePriority'],
      cryptoType: json['crypto_type'],
      convertedCryptoType: json['converted_crypto_type'],
      network: json['network'],
      amount: json['amount'],
      commissionAmount: json['commission_amount'],
      commissionAddress: json['commission_address'],
      transactionFee: json['transaction_fee'],
      convertedAmount: json['converted_amount'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }
}
