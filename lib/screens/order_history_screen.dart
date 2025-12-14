import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = Provider.of<AuthProvider>(context, listen: false).getOrders();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan memuat pesanan'));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('Belum ada pesanan'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 16),
            itemBuilder: (ctx, i) {
              final order = orders[i];
              // Parse items safely
              List<dynamic> items = order.items;
              String firstItemName = items.isNotEmpty ? (items[0]['name'] ?? 'Produk') : 'Produk';
              int otherItemsCount = items.length - 1;
              String description = otherItemsCount > 0 ? '$firstItemName + $otherItemsCount lainnya' : firstItemName;

              // Date formatting
              DateTime date = DateTime.tryParse(order.date) ?? DateTime.now();
              String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(date);

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF162A2A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formattedDate, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(order.status, style: TextStyle(color: primary, fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
                          child: const Icon(Icons.shopping_bag, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(description, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('Total Belanja', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Text('Rp ${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                     const SizedBox(height: 12),
                     const Divider(color: Colors.white12),
                     const SizedBox(height: 8),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text('Metode: ${order.paymentMethod}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                         TextButton(
                           onPressed: () {},
                           style: TextButton.styleFrom(
                             padding: EdgeInsets.zero,
                             minimumSize: Size.zero,
                             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                           ),
                           child: Text('Lihat Detail', style: TextStyle(color: primary)),
                         )
                       ],
                     )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
