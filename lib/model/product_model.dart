import 'package:cloud_firestore/cloud_firestore.dart';
import '../entity/product.dart';

class ProductModel extends Product<String> {
  ProductModel({
    required super.id,
    required super.name,
    required super.image,
    required super.price,
    required super.sold,
    required super.views,
    super.description,
  });

  /// ------------------------
  ///  🔥 From Firestore
  /// ------------------------
factory ProductModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data() ?? {};

  return ProductModel(
    id: doc.id,
    name: data["name"] ?? "",
    image: data["image"] ?? "",
    price: (data["price"] as num?)?.toDouble() ?? 0.0,
    sold: data["sold"] ?? 0,
    views: data["views"] ?? 0,
    description: data["description"],
  );
}



  /// ------------------------
  ///  🔥 To Firestore
  /// ------------------------
  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "image": image,
      "price": price,
      "sold": sold,
      "views": views,
      "description": description,
    };
  }

  /// ------------------------
  /// Optional: JSON Use
  /// ------------------------
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"].toString(),
      name: json["name"],
      image: json["image"],
      price: (json["price"] as num).toDouble(),
      sold: json["sold"],
      views: json["views"],
      description: json["description"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "price": price,
      "sold": sold,
      "views": views,
      "description": description,
    };
  }
}
