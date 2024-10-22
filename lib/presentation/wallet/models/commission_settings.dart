class CommissionSettingsResponse {
  final String status;
  final String message;
  final List<CommissionData> data;

  CommissionSettingsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CommissionSettingsResponse.fromJson(Map<String, dynamic> json) {
    return CommissionSettingsResponse(
      status: json['status'],
      message: json['message'],
      data: List<CommissionData>.from(
        json['data'].map((commission) => CommissionData.fromJson(commission)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((commission) => commission.toJson()).toList(),
    };
  }
}

class CommissionData {
  final int id;
  final String cryptoType;
  final int fromRange;
  final int toRange;
  final double commissionRate;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;

  CommissionData({
    required this.id,
    required this.cryptoType,
    required this.fromRange,
    required this.toRange,
    required this.commissionRate,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CommissionData.fromJson(Map<String, dynamic> json) {
    return CommissionData(
      id: json['id'],
      cryptoType: json['crrypto_type'],
      fromRange: json['from_range'],
      toRange: json['to_range'],
      commissionRate: json['commission_rate'].toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updaed_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'crrypto_type': cryptoType,
      'from_range': fromRange,
      'to_range': toRange,
      'commission_rate': commissionRate,
      'created_at': createdAt,
      'updaed_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
