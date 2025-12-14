import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pusat Bantuan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildItem('Cara Memesan', 'Pilih produk, masukkan keranjang, lalu checkout.'),
          _buildItem('Metode Pembayaran', 'Kami menerima Transfer, GoPay, dan COD.'),
          _buildItem('Pengiriman', 'Pengiriman Instant (1-3 jam), Same Day (6-8 jam), dan Reguler (1-2 hari).'),
          _buildItem('Hubungi Kami', 'Email: support@frozenfood.com\nWA: 08123456789'),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String content) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(content),
        ),
      ],
    );
  }
}
