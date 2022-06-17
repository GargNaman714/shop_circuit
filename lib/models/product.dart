//creating model for 'Product' to store in MongodB, just like the one we created for 'User'
import 'dart:convert';
import 'package:shop_circuit/models/rating.dart';


class Product {
  final String name;
  final String description;
  final double quantity;
  final List<String> images; // in MongoDb, instead of storing images, we'll  be storing their urls and will be storing images on Cloudinary
  final String category;
  final double price;
  final String? id;
  final List<Rating>? rating;
  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    this.id,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'id': id,
      'rating': rating,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      images: List<String>.from(map['images']),
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      id: map['_id'], // used underscore id coz mongoose jo map/object banata hai usme id ko--> _id likhta hai(can check by testing post api)

      //ye khud likhna padega. Yaha rating:map['ratings'] likha hai kyuki in product.js file(models folder), waha productSchema ki property ka naam 'ratings' hai
      rating: map['ratings'] != null
          ? List<Rating>.from(
              map['ratings']?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}
