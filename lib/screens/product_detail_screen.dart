import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../services/notification_service.dart';
import 'edit_product_screen.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Stack(
                  children: [
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.cover,
                          onError: (_,__) => const Icon(Icons.broken_image, size: 100),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black.withValues(alpha: 0.3),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            Row(
                              children: [
                                // Edit Button
                                CircleAvatar(
                                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                                  child: IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => EditProductScreen(product: product)));
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Delete Button
                                CircleAvatar(
                                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmation(context);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Consumer<CartProvider>(
                                  builder: (_, cart, __) => Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black.withValues(alpha: 0.3),
                                          child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                                        ),
                                      ),
                                      if (cart.itemCount > 0)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: primary,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 16,
                                              minHeight: 16,
                                            ),
                                            child: Text(
                                              '${cart.itemCount}',
                                              style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF162A2A),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: Colors.yellow, size: 16),
                                const SizedBox(width: 4),
                                Text('${product.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Rp ${product.price.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primary, shadows: [Shadow(color: primary.withValues(alpha: 0.3), blurRadius: 10)]),
                      ),
                      const SizedBox(height: 20),
                      // Specs Grid
                      Row(
                        children: [
                          _buildSpecItem(Icons.scale, 'Berat', '${product.weight} kg'),
                          const SizedBox(width: 10),
                          _buildSpecItem(Icons.calendar_today, 'Kadaluarsa', product.expirationDate),
                          const SizedBox(width: 10),
                          _buildSpecItem(Icons.thermostat, 'Suhu', '-18°C'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Deskripsi Produk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(
                        product.description,
                        style: const TextStyle(color: Colors.grey, height: 1.5),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.white12),
                    ],
                  ),
                )
              ],
            ),
          ),
          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF102222),
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF162A2A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          IconButton(icon: const Icon(Icons.remove, size: 20), onPressed: () {}),
                          const Text('1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(icon: Icon(Icons.add, size: 20, color: primary), onPressed: () {}),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Provider.of<CartProvider>(context, listen: false).addItem(product, 1);
                             await NotificationService().showNotification('Keranjang', 'Produk ditambahkan ke keranjang');
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ditambahkan ke keranjang')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 5,
                            shadowColor: primary.withValues(alpha: 0.4),
                          ),
                          icon: const Icon(Icons.shopping_bag_outlined),
                          label: const Text('Tambah Keranjang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF162A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF13ECEC).withValues(alpha: 0.8)), // Primary
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Produk?'),
        content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<ProductProvider>(context, listen: false).deleteProduct(product.id);
                Navigator.pop(ctx); // close dialog
                Navigator.pop(context); // close detail screen
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk dihapus')));
              } catch (e) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menghapus produk')));
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
