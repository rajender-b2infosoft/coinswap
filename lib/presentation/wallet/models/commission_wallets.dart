import 'dart:convert';

class WalletResponse {
  final String status;
  final String message;
  final List<Wallet> data;

  WalletResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  // Factory method to parse JSON into WalletResponse object
  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      status: json['status'],
      message: json['message'],
      data: List<Wallet>.from(json['data'].map((wallet) => Wallet.fromJson(wallet))),
    );
  }

  // Method to convert WalletResponse object to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((wallet) => wallet.toJson()).toList(),
    };
  }
}

class Wallet {
  final int id;
  final int userId;
  final String vaultId;
  final String walletType;
  final String walletAddress;
  final String balance;
  final int defaultWallet;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Wallet({
    required this.id,
    required this.userId,
    required this.vaultId,
    required this.walletType,
    required this.walletAddress,
    required this.balance,
    required this.defaultWallet,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Factory method to parse JSON into Wallet object
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      userId: json['user_id'],
      vaultId: json['vault_id'],
      walletType: json['wallet_type'],
      walletAddress: json['wallet_address'],
      balance: json['balance'],
      defaultWallet: json['default'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  // Method to convert Wallet object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'vault_id': vaultId,
      'wallet_type': walletType,
      'wallet_address': walletAddress,
      'balance': balance,
      'default': defaultWallet,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
