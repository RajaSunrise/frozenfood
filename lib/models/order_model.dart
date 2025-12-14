class OrderModel {
  final String id;
  final String userId;
  final double totalAmount;
  final String date;
  final List<dynamic> items; // Simplified items list (json)

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.date,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'totalAmount': totalAmount,
      'date': date,
      'items': items,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      date: json['date'],
      items: json['items'] ?? [],
    );
  }
}
