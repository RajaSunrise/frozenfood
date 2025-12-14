class OrderModel {
  final String id;
  final String userId;
  final double totalAmount;
  final String date;
  final String status;
  final String shippingMethod;
  final String paymentMethod;
  final String shippingAddress;
  final List<dynamic> items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.date,
    this.status = 'Pending',
    required this.shippingMethod,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'totalAmount': totalAmount,
      'date': date,
      'status': status,
      'shippingMethod': shippingMethod,
      'paymentMethod': paymentMethod,
      'shippingAddress': shippingAddress,
      'items': items,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      date: json['date'],
      status: json['status'] ?? 'Pending',
      shippingMethod: json['shippingMethod'] ?? 'Instant',
      paymentMethod: json['paymentMethod'] ?? 'Transfer',
      shippingAddress: json['shippingAddress'] ?? '',
      items: json['items'] ?? [],
    );
  }
}
