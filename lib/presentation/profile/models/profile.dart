import 'dart:convert';

class UserProfileResponse {
  final String status;
  final String message;
  final List<UserProfile> data;

  UserProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<UserProfile> userProfileList = list.map((i) => UserProfile.fromJson(i)).toList();

    return UserProfileResponse(
      status: json['status'],
      message: json['message'],
      data: userProfileList,
    );
  }
}

class UserProfile {
  final int? userId;
  final String? username;
  final String? email;
  final String? role;
  final String? passwordHash;
  final String? countryCode;
  final String? phoneNumber;
  final int? privacy;
  final int? kycStatus;
  final int? totalTransactions;
  final String? status;
  final String? token;
  final DateTime? userCreatedAt;
  final String? walletId;
  final dynamic balance;
  final String? walletAddress;
  final String? publicKey;
  final String? privkey;
  final String? seed;
  final String? cryptoType;

  UserProfile({
     this.userId,
     this.username,
     this.email,
     this.role,
     this.passwordHash,
     this.countryCode,
    this.phoneNumber,
     this.privacy,
     this.kycStatus,
     this.totalTransactions,
     this.status,
     this.token,
     this.userCreatedAt,
     this.walletId,
     this.balance,
     this.walletAddress,
     this.publicKey,
     this.privkey,
     this.seed,
     this.cryptoType,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      passwordHash: json['password_hash'],
      countryCode: json['country_code'],
      phoneNumber: json['phone_number'],
      privacy: json['privacy'],
      kycStatus: json['kyc_status'],
      totalTransactions: json['total_transactions'],
      status: json['status'],
      token: json['token'],
      userCreatedAt: DateTime.parse(json['user_created_at']),
      walletId: json['wallet_id'],
      balance: json['balance'],
      walletAddress: json['wallet_address'],
      publicKey: json['public_key'],
      privkey: json['privkey'],
      seed: json['seed'],
      cryptoType: json['crypto_type'],
    );
  }
}
