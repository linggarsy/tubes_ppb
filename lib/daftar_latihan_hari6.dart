import 'package:flutter/material.dart';
import 'halaman_base_latihan.dart';

class Hari6 extends StatelessWidget {
  const Hari6({super.key});

  final List<Map<String, dynamic>> _latihan = const [
    {'nama': 'Putaran Pinggul Berdiri', 'durasi': 20, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/putaran_pinggul.png'},
    {'nama': 'Squat', 'durasi': 30, 'icon': Icons.self_improvement, 'gambar': 'assets/latihan/squat.jpg'},
    {'nama': 'Meninju', 'durasi': 20, 'icon': Icons.sports_mma, 'gambar': 'assets/latihan/meninju.png'},
    {'nama': 'Crunch Sepeda', 'durasi': 20, 'icon': Icons.fitness_center, 'gambar': 'assets/latihan/crunch_sepeda.jpg'},
    {'nama': 'Push Up', 'durasi': 30, 'icon': Icons.fitness_center, 'gambar': 'assets/latihan/push_up2.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLatihanPage(
      hariKe: 'Hari 6',
      daftarLatihan: _latihan,
    );
  }
}