// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  final String? status;
  final String? message;
  final Data? data;

  LoginModel({
    this.status,
    this.message,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final int? userId;
  final String? username;
  final String? email;
  final String? role;
  final String? passwordHash;
  final String? countryCode;
  final dynamic phoneNumber;
  final String? token;
  final int? privacy;
  final int? kycStatus;
  final String? status;
  final DateTime? createdAt;
  final dynamic updatedAt;
  final dynamic deletedAt;

  Data({
    this.userId,
    this.username,
    this.email,
    this.role,
    this.passwordHash,
    this.countryCode,
    this.phoneNumber,
    this.token,
    this.privacy,
    this.kycStatus,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    username: json["username"],
    email: json["email"],
    role: json["role"],
    passwordHash: json["password_hash"],
    countryCode: json["country_code"],
    phoneNumber: json["phone_number"],
    token: json["token"],
    privacy: json["privacy"],
    kycStatus: json["kyc_status"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "username": username,
    "email": email,
    "role": role,
    "password_hash": passwordHash,
    "country_code": countryCode,
    "phone_number": phoneNumber,
    "token": token,
    "privacy": privacy,
    "kyc_status": kycStatus,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
  };
}
