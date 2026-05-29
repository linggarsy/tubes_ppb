import 'package:flutter/material.dart';
import 'halaman_base_latihan.dart';

class Hari11 extends StatelessWidget {
  const Hari11({super.key});

  final List<Map<String, dynamic>> _latihan = const [
    {'nama': 'Fire Hydrant Kiri', 'durasi': 20, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/fire_hydrant.jpg'},
    {'nama': 'Fire Hydrant Kanan', 'durasi': 20, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/fire_hydrant.jpg'},
    {'nama': 'Crunch Tendang', 'durasi': 30, 'icon': Icons.fitness_center, 'gambar': 'assets/latihan/crunch_tendang.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLatihanPage(
      hariKe: 'Hari 11',
      daftarLatihan: _latihan,
    );
  }
}