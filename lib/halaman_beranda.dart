import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_ppb/halaman_saya.dart';
import 'package:tubes_ppb/services/api_service.dart';
import 'halaman_daftar_hari.dart';
import 'halaman_laporkan.dart';
import 'persiapan_latihan.dart';

class BerandaPage extends StatefulWidget {
  BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  String _nama = '';
  int _totalHariSelesai = 0;
  int _totalHari = 12;

  // Data pemanasan
  final List<Map<String, dynamic>> pemanasan = const [
    {
      'nama': 'Peregangan Leher',
      'durasi': 15,
      'icon': Icons.accessibility_new,
      'deskripsi': 'Gerakkan leher ke kiri dan kanan'
    },
    {
      'nama': 'Peregangan Bahu',
      'durasi': 15,
      'icon': Icons.fitness_center,
      'deskripsi': 'Putar bahu ke depan dan belakang'
    },
    {
      'nama': 'Peregangan Tangan',
      'durasi': 15,
      'icon': Icons.pan_tool,
      'deskripsi': 'Tarik tangan ke belakang'
    },
    {
      'nama': 'Peregangan Kaki',
      'durasi': 15,
      'icon': Icons.self_improvement,
      'deskripsi': 'Regangkan otot paha dan betis'
    },
    {
      'nama': 'Pemanasan Ringan',
      'durasi': 30,
      'icon': Icons.directions_run,
      'deskripsi': 'Lari di tempat perlahan'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      // Ambil profil user
      final profilResult = await apiService.getProfil();
      if (profilResult['success'] == true) {
        if (!mounted) return;
        setState(() {
          _nama = profilResult['data']['nama'] ?? '';
        });
      }

      // Ambil progress
      final progressResult = await apiService.getProgress();
      if (progressResult['success'] == true) {
        if (!mounted) return;
        setState(() {
          _totalHariSelesai = progressResult['data']['total'] ?? 0;
        });
      }
    } catch (e) {
      // Fallback ke nama dari SharedPreferences
      final nama = await apiService.getUserNama();
      if (!mounted) return;
      setState(() {
        _nama = nama;
      });
    }
  }

  void _startPemanasan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersiapanLatihan(
          daftarLatihan: pemanasan,
          currentIndex: 0,
          hariKe: 'Pemanasan',
        ),
      ),
    );
  }

  void _startSinglePemanasan(
      BuildContext context, Map<String, dynamic> latihan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersiapanLatihan(
          daftarLatihan: [latihan],
          currentIndex: 0,
          hariKe: 'Pemanasan',
        ),
      ),
    );
  }

  // Hari berikutnya yang belum selesai
  String get _hariBerikutnya {
    int hari = _totalHariSelesai + 1;
    if (hari > _totalHari) return 'Selesai';
    return 'Hari $hari';
  }

  int get _hariTersisa {
    int tersisa = _totalHari - _totalHariSelesai;
    return tersisa < 0 ? 0 : tersisa;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kurangi berat',
                        style: TextStyle(
                          color: Color(0xFFCF0F0F),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _nama.isNotEmpty
                            ? 'Selamat datang, $_nama! 👋'
                            : 'Selamat datang! 👋',
                        style: const TextStyle(
                          color: Color(0xFFCF0F0F),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HalamanSaya()),
                      ).then((_) {
                        // Refresh data saat kembali dari halaman Saya
                        _loadUserData();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCF0F0F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.account_circle_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tantangan Aktif Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFCF0F0F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tantangan Aktif',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Turunkan berat badan & jaga fit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _hariBerikutnya.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFFCF0F0F),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _totalHariSelesai >= _totalHari
                                    ? 'Semua selesai! 🎉'
                                    : '$_hariTersisa hari tersisa',
                                style: const TextStyle(
                                  color: Color(0xFFCF0F0F),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DaftarHariPage(),
                                ),
                              ).then((_) => _loadUserData());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFCF0F0F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'MULAI',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Pemanasan Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pemanasan',
                    style: TextStyle(
                      color: Color(0xFFCF0F0F),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _startPemanasan(context),
                    child: const Text(
                      'Mulai Semua',
                      style: TextStyle(
                        color: Color(0xFFCF0F0F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List Pemanasan
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Info box
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.orange.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Lakukan pemanasan terlebih dahulu untuk mencegah cedera!',
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // List gerakan pemanasan
                  ...pemanasan.map((item) => _buildPemanasanCard(
                        item['nama'] as String,
                        item['durasi'] as int,
                        item['icon'] as IconData,
                        item['deskripsi'] as String,
                        item,
                        context,
                      )),

                  const SizedBox(height: 16),

                  // Tombol Mulai Latihan Utama
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DaftarHariPage(),
                          ),
                        ).then((_) => _loadUserData());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCF0F0F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fitness_center),
                          SizedBox(width: 8),
                          Text(
                            'Mulai Latihan Utama',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBottomNavItem(
                        Icons.home, 'Beranda', true, context, '/beranda'),
                    _buildBottomNavItem(Icons.bar_chart, 'Laporkan', false,
                        context, '/laporkan'),
                    _buildBottomNavItem(
                        Icons.person, 'Saya', false, context, '/saya'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPemanasanCard(
    String title,
    int durasi,
    IconData icon,
    String deskripsi,
    Map<String, dynamic> latihan,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFCF0F0F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFCF0F0F), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$durasi detik',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _startSinglePemanasan(context, latihan),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFCF0F0F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Mulai',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    IconData icon,
    String label,
    bool isActive,
    BuildContext context,
    String route,
  ) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          if (route == '/laporkan') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HalamanLaporkan()),
            );
          } else if (route == '/saya') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HalamanSaya()),
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