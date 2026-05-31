import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_ppb/halaman_profil_saya.dart';
import 'package:tubes_ppb/halaman_sign_in.dart';
import 'package:tubes_ppb/services/api_service.dart';
import 'package:tubes_ppb/services/auth_service.dart';
import 'halaman_beranda.dart';
import 'halaman_laporkan.dart';

class HalamanSaya extends StatefulWidget {
  const HalamanSaya({super.key});

  @override
  State<HalamanSaya> createState() => _HalamanSayaState();
}

class _HalamanSayaState extends State<HalamanSaya> {
  int _hitunganMundur = 10;

  @override
  void initState() {
    super.initState();
    _loadHitunganMundur();
  }

  Future<void> _loadHitunganMundur() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hitunganMundur = prefs.getInt('hitungan_mundur') ?? 10;
    });
  }

  Future<void> _saveHitunganMundur(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('hitungan_mundur', value);
    setState(() {
      _hitunganMundur = value;
    });
  }

  void _resetProgress(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atur Ulang Perkembangan'),
        content: const Text(
            'Apakah Anda yakin ingin mengatur ulang semua progress latihan? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                // Reset di MySQL
                final apiService =
                    Provider.of<ApiService>(context, listen: false);
                await apiService.resetProgress();

                // Reset di SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('completed_days');

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Progress berhasil diatur ulang'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal reset progress: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                // Logout Firebase
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                await authService.signOut();

                // Clear session API
                final apiService =
                    Provider.of<ApiService>(context, listen: false);
                await apiService.clearSession();

                // Clear SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignInPage()),
                  (route) => false,
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal logout: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showHitunganMundurDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hitung Mundur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pilih durasi hitungan mundur sebelum latihan dimulai:'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDurationButton(5),
                _buildDurationButton(10),
                _buildDurationButton(15),
                _buildDurationButton(20),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationButton(int duration) {
    bool isSelected = _hitunganMundur == duration;
    return GestureDetector(
      onTap: () {
        _saveHitunganMundur(duration);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hitung mundur diubah menjadi ${duration} detik'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFCF0F0F) : Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${duration}s',
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  const Text(
                    'Saya',
                    style: TextStyle(
                      color: Color(0xFFCF0F0F),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const Text(
                    'SETELAN UMUM',
                    style: TextStyle(
                      color: Color(0xFFCF0F0F),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Profil Saya',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilSayaPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Atur Ulang Perkembangan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () => _resetProgress(context),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'PENGATURAN LATIHAN',
                    style: TextStyle(
                      color: Color(0xFFCF0F0F),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Hitung Mundur',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_hitunganMundur}s',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      onTap: _showHitunganMundurDialog,
                    ),
                  ),
                  
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      onTap: () => _logout(context),
                    ),
                  ),
                  
                  const SizedBox(height: 80),
                ],
              ),
            ),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBottomNavItem(Icons.home, 'Beranda', false, context, '/beranda'),
                    _buildBottomNavItem(Icons.bar_chart, 'Laporkan', false, context, '/laporkan'),
                    _buildBottomNavItem(Icons.person, 'Saya', true, context, '/saya'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive, BuildContext context, String route) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          if (route == '/beranda') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BerandaPage()),
            );
          } else if (route == '/laporkan') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HalamanLaporkan()),
            );
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFFCF0F0F) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFFCF0F0F) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}