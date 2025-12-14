import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../models/order_model.dart';
import '../models/user.dart';
import 'main_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedShipping = 'Instant';
  String _selectedPayment = 'Transfer Virtual Account';
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    _addressController.text = user?.address ?? '';
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _changeAddress() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ubah Alamat'),
        content: TextField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: 'Alamat Lengkap'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              final auth = Provider.of<AuthProvider>(context, listen: false);
              if (auth.isAuthenticated) {
                User updatedUser = auth.currentUser!.copyWith(address: _addressController.text);
                await auth.updateUser(updatedUser);
                setState(() {}); // refresh UI
              }
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // Matching HTML 5
    final cart = Provider.of<CartProvider>(context);
    final auth = Provider.of<AuthProvider>(context); // Listen to auth for user updates
    final user = auth.currentUser;
    final primary = Theme.of(context).primaryColor;

    // Shipping Costs Mock
    double shippingCost = 0;
    if (_selectedShipping == 'Instant') shippingCost = 20000;
    if (_selectedShipping == 'Same Day') shippingCost = 15000;
    if (_selectedShipping == 'Reguler') shippingCost = 10000;

    final total = cart.totalAmount * 1.1 + shippingCost + 5000 + 1000; // Mock calculation

    void placeOrder() async {
      if (!auth.isAuthenticated) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan login terlebih dahulu')));
         return;
      }

      final order = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: auth.currentUser!.id,
        totalAmount: total,
        date: DateTime.now().toIso8601String(),
        shippingMethod: _selectedShipping,
        paymentMethod: _selectedPayment,
        shippingAddress: user?.address ?? _addressController.text,
        items: cart.items.values.map((e) => e.toJson()).toList(),
      );

      await auth.saveOrder(order);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan Dibuat!')));
      cart.clear();
      Navigator.popUntil(context, (route) => route.isFirst);
       // Navigate to MainScreen
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stepper
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(context, isActive: false, isCompleted: true),
                      const SizedBox(width: 8),
                      Container(width: 32, height: 10, decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(5))),
                      const SizedBox(width: 8),
                      _buildDot(context, isActive: false),
                    ],
                  ),
                ),
                // Address
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Alamat Pengiriman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF162A2A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                            child: Icon(Icons.location_on, color: primary),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Rumah', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                                      child: Text('UTAMA', style: TextStyle(color: primary, fontSize: 10, fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  (user?.address != null && user!.address.isNotEmpty) ? user.address : 'Belum ada alamat',
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Text('${user?.name} (${user?.phoneNumber.isNotEmpty == true ? user!.phoneNumber : "-"})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: _changeAddress, child: Text('Ubah Alamat', style: TextStyle(color: primary))),
                      )
                    ],
                  ),
                ),
                // Delivery Options
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text('Opsi Pengiriman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildDeliveryOption(context, 'Instant', '1-3 Jam', 'Rp 20.000', Icons.rocket_launch, isSelected: _selectedShipping == 'Instant'),
                      const SizedBox(width: 12),
                      _buildDeliveryOption(context, 'Same Day', '6-8 Jam', 'Rp 15.000', Icons.local_shipping, isSelected: _selectedShipping == 'Same Day'),
                      const SizedBox(width: 12),
                      _buildDeliveryOption(context, 'Reguler', '1-2 Hari', 'Rp 10.000', Icons.inventory_2, isSelected: _selectedShipping == 'Reguler'),
                    ],
                  ),
                ),
                // Payment Method
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text('Metode Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildPaymentOption(context, 'Transfer Virtual Account', 'Cek otomatis', isSelected: _selectedPayment == 'Transfer Virtual Account'),
                      const SizedBox(height: 12),
                      _buildPaymentOption(context, 'GoPay', 'Hubungkan akun', isSelected: _selectedPayment == 'GoPay'),
                      const SizedBox(height: 12),
                      _buildPaymentOption(context, 'COD (Bayar di Tempat)', 'Tunai saat barang sampai', isSelected: _selectedPayment == 'COD (Bayar di Tempat)'),
                    ],
                  ),
                ),
                // Summary
                 const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text('Ringkasan Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF162A2A).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      ...cart.items.values.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), image: DecorationImage(image: NetworkImage(item.imageUrl), fit: BoxFit.cover)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('Qty: ${item.quantity}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            )),
                            Text('Rp ${(item.price * item.quantity).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 8),
                      _buildCostRow('Subtotal Produk', 'Rp ${cart.totalAmount.toStringAsFixed(0)}'),
                      _buildCostRow('Biaya Pengiriman', 'Rp ${shippingCost.toStringAsFixed(0)}'),
                      _buildCostRow('Biaya Kemasan & Ice Gel', 'Rp 5.000'),
                      _buildCostRow('Biaya Layanan', 'Rp 1.000'),
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
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF102222),
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Total Pembayaran', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Rp ${total.toStringAsFixed(0)}', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Row(
                        children: [
                          Text('Konfirmasi', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(BuildContext context, {bool isActive = false, bool isCompleted = false}) {
    final primary = Theme.of(context).primaryColor;
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? primary : (isCompleted ? const Color(0xFF326767) : const Color(0xFF326767)),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDeliveryOption(BuildContext context, String title, String subtitle, String price, IconData icon, {bool isSelected = false}) {
    final primary = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () => setState(() => _selectedShipping = title),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.05) : const Color(0xFF162A2A),
          border: Border.all(color: isSelected ? primary : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: isSelected ? primary : Colors.grey),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 12, color: Colors.black),
                  )
                else
                  Container(
                    width: 16, height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                  )
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Text(price, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? primary : Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String title, String subtitle, {bool isSelected = false}) {
     final primary = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = title),
      child: Container(
        padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.05) : const Color(0xFF162A2A),
          border: Border.all(color: isSelected ? primary : Colors.transparent),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 50, height: 36,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              // Logo placeholder
              child: const Icon(Icons.payments, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
             if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 12, color: Colors.black),
                  )
                else
                  Container(
                    width: 16, height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
