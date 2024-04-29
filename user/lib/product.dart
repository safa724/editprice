import 'package:user/variant.dart';

class Product {
  final int id;
  final String name;
  final String image;
  final List<Variant> variants;
  bool isAvailable;
  final int category_id; // Add this line for category id

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.variants,
    required this.isAvailable,
    required this.category_id, // Add this line for category id
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<Variant> variantsList = [];
    if (json['variants'] != null) {
      variantsList = List.from(json['variants'])
          .map((variant) => Variant.fromJson(variant))
          .toList();
    }

    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      isAvailable: json['status'] == 1,
      variants: variantsList,
      category_id: json['category_id'], // Modify this line for the actual key in your API response
    );
  }
}
