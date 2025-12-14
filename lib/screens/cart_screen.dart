import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Matching HTML 4 but polished
    final cart = Provider.of<CartProvider>(context);
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              // Confirm clear
               showDialog(context: context, builder: (ctx) => AlertDialog(
                 title: const Text('Hapus Keranjang?'),
                 content: const Text('Semua item akan dihapus.'),
                 actions: [
                   TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                   TextButton(onPressed: () {
                     cart.clear();
                     Navigator.pop(ctx);
                   }, child: const Text('Hapus', style: TextStyle(color: Colors.red))),
                 ],
               ));
            },
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
          )
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  const Text('Keranjang Kosong', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                       // Navigate to product page/tab
                       // Just pop or go to main? Since Cart is a tab, we need to switch tab or go to ProductList.
                       // But CartScreen is used inside MainScreen, so we can't easily switch tab from here without a callback or context hack.
                       // Or if pushed, pop.
                       // For now just stay.
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.black),
                    child: const Text('Belanja Sekarang'),
                  )
                ],
              ),
            )
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final item = cart.items.values.toList()[i];
                final productId = cart.items.keys.toList()[i];
                return Dismissible(
                  key: ValueKey(productId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    cart.removeItem(productId);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF162A2A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(item.imageUrl),
                              fit: BoxFit.cover,
                              onError: (_,__) => const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('Rp ${item.price.toStringAsFixed(0)}', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Pack', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF234848),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () => cart.removeSingleItem(productId),
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: const Color(0xFF112222),
                                            child: Icon(Icons.remove, size: 14, color: primary),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            cart.incrementItem(productId);
                                          },
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: primary,
                                            child: const Icon(Icons.add, size: 14, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Order Summary
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF102222),
              border: Border(top: BorderSide(color: Colors.white12)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Rincian Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Subtotal', 'Rp ${cart.totalAmount.toStringAsFixed(0)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Estimasi Pengiriman', 'Rp 15.000'), // Fixed for now, updated in checkout
                  const SizedBox(height: 8),
                  _buildSummaryRow('Pajak (10%)', 'Rp ${(cart.totalAmount * 0.1).toStringAsFixed(0)}'),
                  const Divider(color: Colors.white12, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(
                        'Rp ${(cart.totalAmount * 1.1 + 15000).toStringAsFixed(0)}',
                        style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                        shadowColor: primary.withOpacity(0.3),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Lanjutkan ke Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
