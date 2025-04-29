import 'dart:convert';

OrderDetail orderDetailFromJson(String str) => OrderDetail.fromJson(json.decode(str));

String orderDetailToJson(OrderDetail data) => json.encode(data.toJson());

class OrderDetail {
  int quantity;
  int orderId;
  int productId;

  OrderDetail({
    required this.quantity,
    required this.orderId,
    required this.productId,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    quantity: json["quantity"],
    orderId: json["order_id"],
    productId: json["product_id"],
  );

  Map<String, dynamic> toJson() => {
    "quantity": quantity,
    "order_id": orderId,
    "product_id": productId,
  };
}
