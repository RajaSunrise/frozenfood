import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import 'login_screen.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  void _editProfile(User user) {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phoneNumber);
    final addressController = TextEditingController(text: user.address);
    final avatarController = TextEditingController(text: user.avatarUrl); // Simplified avatar editing

    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Edit Profil'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama Lengkap')),
            const SizedBox(height: 12),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Nomor HP')),
            const SizedBox(height: 12),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Alamat')),
            const SizedBox(height: 12),
            TextField(controller: avatarController, decoration: const InputDecoration(labelText: 'URL Avatar')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
        ElevatedButton(onPressed: () async {
            final auth = Provider.of<AuthProvider>(context, listen: false);
            final updatedUser = user.copyWith(
              name: nameController.text,
              phoneNumber: phoneController.text,
              address: addressController.text,
              avatarUrl: avatarController.text,
            );
            await auth.updateUser(updatedUser);
            Navigator.pop(ctx);
        }, child: const Text('Simpan'))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Matching HTML 6 but removing Gold Member
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (user != null) _editProfile(user);
            },
            icon: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              child: Icon(Icons.edit, color: primary),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            // Header
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primary.withValues(alpha: 0.2), width: 4),
                    boxShadow: [BoxShadow(color: primary.withValues(alpha: 0.2), blurRadius: 20)],
                    image: DecorationImage(
                      image: NetworkImage(user?.avatarUrl ?? 'https://via.placeholder.com/150'),
                      fit: BoxFit.cover,
                      onError: (_,__) => const AssetImage('assets/default_avatar.png'), // fallback to nothing or error widget handled by Image provider logic usually
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 4),
                    ),
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.black),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? 'Guest User', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            // REMOVED GOLD MEMBER BADGE as requested
            const SizedBox(height: 4),
            Text(user?.email ?? '', style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 24),
            // Stats (Mock data for now, could be real if orders are fetched here)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatItem(context, '0', 'Pesanan Aktif'), // Placeholder
                  const SizedBox(width: 12),
                  _buildStatItem(context, '150', 'Poin'),
                  const SizedBox(width: 12),
                  _buildStatItem(context, '12', 'Wishlist'),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // Menu Groups
            _buildSectionHeader('TRANSAKSI'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF162A2A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(context, Icons.receipt_long, 'Pesanan Saya', onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
                  }),
                  const Divider(height: 1, color: Colors.white12),
                  _buildMenuItem(context, Icons.history, 'Riwayat Belanja', onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('AKUN'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF162A2A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(context, Icons.location_on, 'Alamat Pengiriman', onTap: () {
                     if (user != null) _editProfile(user); // Quick shortcut to edit address
                  }),
                  const Divider(height: 1, color: Colors.white12),
                  _buildMenuItem(context, Icons.credit_card, 'Metode Pembayaran'), // Placeholder for future feature
                  const Divider(height: 1, color: Colors.white12),
                  _buildMenuItem(context, Icons.lock, 'Keamanan & Password'),
                ],
              ),
            ),

             const SizedBox(height: 24),
            _buildSectionHeader('UMUM'),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF162A2A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(context, Icons.notifications, 'Notifikasi', isToggle: true),
                  const Divider(height: 1, color: Colors.white12),
                  _buildMenuItem(context, Icons.help, 'Pusat Bantuan'),
                   const Divider(height: 1, color: Colors.white12),
                  _buildMenuItem(context, Icons.info, 'Tentang Aplikasi'),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Keluar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
                  backgroundColor: Colors.red.withValues(alpha: 0.05),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
             const SizedBox(height: 16),
             const Text('Versi 2.4.0 (Build 2024)', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF162A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, {String? badge, bool isToggle = false, VoidCallback? onTap}) {
     final primary = Theme.of(context).primaryColor;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(badge, style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
            ],
            if (isToggle)
               Switch(value: true, onChanged: (v) {}, activeColor: Theme.of(context).primaryColor)
            else
               const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
