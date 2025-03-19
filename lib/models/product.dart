import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String category;
  final String? imageUrl;
  final bool inStock;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    this.imageUrl,
    this.inStock = true,
    required this.createdAt,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Handle price conversion more robustly
    double parsePrice(dynamic value) {
      if (value is int) {
        return value.toDouble();
      } else if (value is double) {
        return value;
      } else if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: parsePrice(data['price']),
      quantity:
          (data['quantity'] ?? 0) is int
              ? (data['quantity'] ?? 0)
              : int.parse(data['quantity']?.toString() ?? '0'),
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'],
      inStock: data['inStock'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'imageUrl': imageUrl,
      'inStock': inStock,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
