import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.ac_unit, size: 80, color: Color(0xFF13ECEC)),
            SizedBox(height: 16),
            Text('Frozen Food App', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Versi 2.4.0', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 24),
            Text(
              'Aplikasi ini dibuat untuk memudahkan Anda berbelanja berbagai macam makanan beku berkualitas tinggi. Nikmati kemudahan berbelanja dari rumah dengan pengiriman cepat dan aman.',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
