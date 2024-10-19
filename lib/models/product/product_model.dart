
import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  int? id;
  String? productImage;
  String? productName;
  double? productPrice;
  String? token;

  Product({
    this.id,
    this.productImage,
    this.productName,
    this.productPrice,
    this.token,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    productImage: json["productImage"],
    productName: json["productName"],
    productPrice: json["productPrice"]?.toDouble(),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productImage": productImage,
    "productName": productName,
    "productPrice": productPrice,
    "token": token,
  };
}
