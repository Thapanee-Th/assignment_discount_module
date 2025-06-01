class CartItemModel {
  final String id;
  final String name;
  final String image;
  final String imageUrl;
  final double price;
  final String category;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      category: json['category'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'imageUrl': imageUrl,
      'price': price,
      'category': category,
      'quantity': quantity,
    };
  }

  CartItemModel copyWith({
    String? id,
    String? name,
    String? image,
    String? imageUrl,
    double? price,
    String? category,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
    );
  }
}
