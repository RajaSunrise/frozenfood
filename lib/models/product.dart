class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double weight;
  final String expirationDate;
  final String description;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.weight,
    required this.expirationDate,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['namaProduk'] ?? 'Unknown Product',
      category: json['category'] ?? json['kategori'] ?? 'Uncategorized',
      price: (json['price'] ?? json['harga'] ?? 0).toDouble(),
      weight: (json['weight'] ?? json['berat'] ?? 0).toDouble(),
      expirationDate: json['expirationDate']?.toString() ?? json['tanggalKadaluarsa']?.toString() ?? '',
      description: json['description'] ?? json['deskripsi'] ?? '',
      rating: (json['rating'] ?? json['ranting'] ?? 0).toDouble(),
      reviewCount: (json['reviewCount'] ?? 0).toInt(),
      imageUrl: json['imageUrl'] ?? json['gambar'] ?? '',
      stock: (json['stock'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // MockAPI usually generates ID on POST, but on PUT we might need it in URL, not body, or body is fine.
      // For POST, sending ID is usually ignored or optional.
      // The user sample includes "id": "1".
      'name': name,
      'category': category,
      'price': price,
      'weight': weight,
      'expirationDate': expirationDate,
      'description': description,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'stock': stock,
    };
  }
}
