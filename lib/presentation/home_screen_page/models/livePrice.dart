class CryptoLivePriceModel {
  final int id;
  final String cryptoType;
  final String price;
  final String usd24hChange;
  final String createdAt;
  final String updatedAt;

  CryptoLivePriceModel({
    required this.id,
    required this.cryptoType,
    required this.price,
    required this.usd24hChange,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CryptoLivePriceModel.fromJson(Map<String, dynamic> json) {
    return CryptoLivePriceModel(
      id: json['id'],
      cryptoType: json['crypto_type'],
      price: json['price'],
      usd24hChange: json['usd_24h_change'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
