import 'package:flutter/material.dart';
import 'package:tubes_ppb/halaman_saya.dart';
import 'halaman_daftar_hari.dart';
import 'halaman_laporkan.dart';
import 'persiapan_latihan.dart';

class BerandaPage extends StatelessWidget {
  BerandaPage({super.key});

  // Data pemanasan sebelum latihan
  final List<Map<String, dynamic>> pemanasan = const [
    {'nama': 'Peregangan Leher', 'durasi': 15, 'icon': Icons.accessibility_new, 'deskripsi': 'Gerakkan leher ke kiri dan kanan'},
    {'nama': 'Peregangan Bahu', 'durasi': 15, 'icon': Icons.fitness_center, 'deskripsi': 'Putar bahu ke depan dan belakang'},
    {'nama': 'Peregangan Tangan', 'durasi': 15, 'icon': Icons.pan_tool, 'deskripsi': 'Tarik tangan ke belakang'},
    {'nama': 'Peregangan Kaki', 'durasi': 15, 'icon': Icons.self_improvement, 'deskripsi': 'Regangkan otot paha dan betis'},
    {'nama': 'Pemanasan Ringan', 'durasi': 30, 'icon': Icons.directions_run, 'deskripsi': 'Lari di tempat perlahan'},
  ];

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

  void _startSinglePemanasan(BuildContext context, Map<String, dynamic> latihan) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kurangi berat',
                        style: TextStyle(
                          color: Color(0xFFCF0F0F),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Selamat datang! 👋',
                        style: TextStyle(
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
                        MaterialPageRoute(builder: (context) => HalamanSaya()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFCF0F0F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.account_circle_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFCF0F0F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tantangan Aktif',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Turunkan berat badan & jaga fit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(12),
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
                                'HARI 1',
                                style: TextStyle(
                                  color: Color(0xFFCF0F0F),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '12 hari tersisa',
                                style: TextStyle(
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
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFCF0F0F),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'MULAI',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Pemanasan (Sebelum memulai latihan)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pemanasan',
                    style: TextStyle(
                      color: Color(0xFFCF0F0F),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _startPemanasan(context);
                    },
                    child: Text(
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
            
            SizedBox(height: 12),
            
            // List pemanasan
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade700),
                        SizedBox(width: 12),
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
                  
                  SizedBox(height: 16),
                  
                  // Tombol Mulai Latihan Utama
                  Container(
                    margin: EdgeInsets.only(bottom: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DaftarHariPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFCF0F0F),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
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
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBottomNavItem(Icons.home, 'Beranda', true, context, '/beranda'),
                    _buildBottomNavItem(Icons.bar_chart, 'Laporkan', false, context, '/laporkan'),
                    _buildBottomNavItem(Icons.person, 'Saya', false, context, '/saya'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPemanasanCard(String title, int durasi, IconData icon, String deskripsi, Map<String, dynamic> latihan, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFCF0F0F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Color(0xFFCF0F0F), size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '$durasi detik',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Mulai pemanasan tertentu
              _startSinglePemanasan(context, latihan);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFCF0F0F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
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

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive, BuildContext context, String route) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          if (route == '/laporkan') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HalamanLaporkan()),
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
            color: isActive ? Color(0xFFCF0F0F) : Colors.grey,
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Color(0xFFCF0F0F) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}