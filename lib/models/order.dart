
import 'dart:convert';
import 'package:shop_circuit/models/product.dart';

//create model for order
class Order {
  final String id;
  final List<Product> products;
  final List<int> quantity;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;
  final double totalPrice;
  Order({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
      'totalPrice': totalPrice,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? '', // used underscore id coz mongoose jo map/object banata hai usme id ko--> _id likhta hai(can check by testing post api)
      products: List<Product>.from( //ye auto-generated wala nahi hai, thode changes kiye hai. Watch Video from--> 9:59:27
          map['products']?.map((x) => Product.fromMap(x['product']))),
      quantity: List<int>.from(
        map['products']?.map(
          (x) => x['quantity'],
        ),
      ),
      address: map['address'] ?? '',
      userId: map['userId'] ?? '',
      orderedAt: map['orderedAt']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0, //if map['totalPrice'] is null, pass 0.0 else pass the value obtained from map
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}