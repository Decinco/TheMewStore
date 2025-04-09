import 'dart:convert';

List<ProductStock> productStockFromJson(String str) =>
    List<ProductStock>.from(json.decode(str).map((x) => ProductStock.fromJson(x)));

String productStockToJson(List<ProductStock> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductStock {
  int productId;
  String productName;
  String comments;
  int rating;
  String description;
  double price;
  int stock;
  String productType;
  int expansionId;
  dynamic offerId;
  String image;

  ProductStock({
    required this.productId,
    required this.productName,
    required this.comments,
    required this.rating,
    required this.description,
    required this.price,
    required this.stock,
    required this.productType,
    required this.expansionId,
    required this.offerId,
    required this.image,
  });

  factory ProductStock.fromJson(Map<String, dynamic> json) => ProductStock(
    productId: json["product_id"],
    productName: json["product_name"],
    comments: json["comments"],
    rating: json["rating"],
    description: json["description"],
    price: json["price"],
    stock: json["stock"],
    productType: json["product_type"],
    expansionId: json["expansion_id"],
    offerId: json["offer_id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "product_name": productName,
    "comments": comments,
    "rating": rating,
    "description": description,
    "price": price,
    "stock": stock,
    "product_type": productType,
    "expansion_id": expansionId,
    "offer_id": offerId,
    "image": image,
  };
}
