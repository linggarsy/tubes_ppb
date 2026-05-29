import 'package:flutter/material.dart';
import 'halaman_base_latihan.dart';

class Hari9 extends StatelessWidget {
  const Hari9({super.key});

  final List<Map<String, dynamic>> _latihan = const [
    {'nama': 'Plank', 'durasi': 30, 'icon': Icons.fitness_center, 'gambar': 'assets/latihan/plank2.jpg'},
    {'nama': 'Sikap Jembatan', 'durasi': 20, 'icon': Icons.fitness_center, 'gambar': 'assets/latihan/sikap_jembatan.jpg'},
    {'nama': 'Push Up', 'durasi': 30, 'icon': Icons.fitness_center, 'gambar': 'assets/latihan/push_up2.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLatihanPage(
      hariKe: 'Hari 9',
      daftarLatihan: _latihan,
    );
  }
}