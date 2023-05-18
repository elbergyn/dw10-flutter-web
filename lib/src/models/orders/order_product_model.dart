import 'dart:convert';

class OrderProductModel {
  final int productId;
  final int amount;
  final double totalPrice;

  OrderProductModel(this.productId, this.amount, this.totalPrice);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': productId,
      'amount': amount,
      'total_price': totalPrice,
    };
  }

  factory OrderProductModel.fromMap(Map<String, dynamic> map) {
    return OrderProductModel(
      (map['id'] ?? 0) as int,
      (map['amount'] ?? 0) as int,
      (map['total_price'] ?? 0.0) as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderProductModel.fromJson(String source) =>
      OrderProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
