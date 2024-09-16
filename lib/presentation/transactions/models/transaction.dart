class Transaction {
  String status;
  String message;
  List<TransactionData> data;

  Transaction({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      status: json['status'],
      message: json['message'],
      data: List<TransactionData>.from(
          json['data'].map((item) => TransactionData.fromJson(item))
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class TransactionData {
  int id;
  int senderId;
  int receiverId;
  String senderWalletAddress;
  String receiverWalletAddress;
  String transactionType;
  String cryptoType;
  String amount;
  String amountUsd;
  String transactionHash;
  String status;
  String createdAt;
  String? updatedAt;
  String? deletedAt;

  TransactionData({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderWalletAddress,
    required this.receiverWalletAddress,
    required this.transactionType,
    required this.cryptoType,
    required this.amount,
    required this.amountUsd,
    required this.transactionHash,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      senderWalletAddress: json['sender_wallet_address'],
      receiverWalletAddress: json['receiver_wallet_address'],
      transactionType: json['transaction_type'],
      cryptoType: json['crypto_type'],
      amount: json['amount'],
      amountUsd: json['amount_usd'],
      transactionHash: json['transaction_hash'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'sender_wallet_address': senderWalletAddress,
      'receiver_wallet_address': receiverWalletAddress,
      'transaction_type': transactionType,
      'crypto_type': cryptoType,
      'amount': amount,
      'amount_usd': amountUsd,
      'transaction_hash': transactionHash,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
