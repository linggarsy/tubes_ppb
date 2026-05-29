import 'package:flutter/material.dart';
import 'halaman_base_latihan.dart';

class Hari1 extends StatelessWidget {
  const Hari1({super.key});

  final List<Map<String, dynamic>> _latihan = const [
    {'nama': 'Ayun Lengan Searah Jarum Jam', 'durasi': 20, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/ayun_lengan2.jpg'},
    {'nama': 'Loncat Bintang', 'durasi': 20, 'icon': Icons.directions_run, 'gambar': 'assets/latihan/loncat_bintang.jpg'},
    {'nama': 'Squat', 'durasi': 30, 'icon': Icons.self_improvement, 'gambar': 'assets/latihan/squat.jpg'},
    {'nama': 'Sikap Jembatan', 'durasi': 20, 'icon': Icons.fitness_center, 'gambar': 'assets/latihan/sikap_jembatan.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLatihanPage(
      hariKe: 'Hari 1',
      daftarLatihan: _latihan,
    );
  }
}