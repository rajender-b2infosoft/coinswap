class RecentTransactionModel {
  String status;
  String message;
  List<TransactionData> data;

  RecentTransactionModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RecentTransactionModel.fromJson(Map<String, dynamic> json) {
    return RecentTransactionModel(
      status: json['status'],
      message: json['message'],
      data: List<TransactionData>.from(
        json['data'].map((transaction) => TransactionData.fromJson(transaction)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((transaction) => transaction.toJson()).toList(),
    };
  }
}

class TransactionData {
  int id;
  int senderId;
  int receiverId;
  String? senderWalletAddress;
  String? receiverWalletAddress;
  String? transactionType;
  String? requestId;
  String? transactionRequestId;
  String? note;
  String? feePriority;
  String? cryptoType;
  String? network;
  String? amount;
  String? commissionAmount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  TransactionData({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.senderWalletAddress,
    this.receiverWalletAddress,
    this.transactionType,
    this.requestId,
    this.transactionRequestId,
    this.note,
    this.feePriority,
    this.cryptoType,
    this.network,
    this.amount,
    this.commissionAmount,
    this.status,
    this.createdAt,
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
      requestId: json['requestId'] ?? '',
      transactionRequestId: json['transactionRequestId'] ?? '',
      note: json['note'],
      feePriority: json['feePriority'],
      cryptoType: json['crypto_type'],
      network: json['network'],
      amount: json['amount'],
      commissionAmount: json['commission_amount'],
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
      'requestId': requestId,
      'transactionRequestId': transactionRequestId,
      'note': note,
      'feePriority': feePriority,
      'crypto_type': cryptoType,
      'network': network,
      'amount': amount,
      'commission_amount': commissionAmount,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
