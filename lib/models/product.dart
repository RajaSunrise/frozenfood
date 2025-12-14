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
    // Map fields from API response (some might be different based on the sample data provided)
    // Sample data keys: "namaProduk", "kategori", "harga", "berat", "tanggalKadaluarsa", "gambar", "deskripsi", "ranting", "id", "name", "category", "price", "weight", "expirationDate", "description", "rating", "reviewCount", "imageUrl", "stock"
    // It seems the API returns a mix of Indonesian and English keys or duplications.
    // I will prioritize English keys if available, else map from Indonesian keys.

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['namaProduk'] ?? 'Unknown Product',
      category: json['category'] ?? json['kategori'] ?? 'Uncategorized',
      price: (json['price'] ?? json['harga'] ?? 0).toDouble(),
      weight: (json['weight'] ?? json['berat'] ?? 0).toDouble(),
      // Handle date format if needed, simplistic for now
      expirationDate: json['expirationDate']?.toString() ?? json['tanggalKadaluarsa']?.toString() ?? '',
      description: json['description'] ?? json['deskripsi'] ?? '',
      rating: (json['rating'] ?? json['ranting'] ?? 0).toDouble(), // "ranting" in sample
      reviewCount: (json['reviewCount'] ?? 0).toInt(),
      imageUrl: json['imageUrl'] ?? json['gambar'] ?? '',
      stock: (json['stock'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
