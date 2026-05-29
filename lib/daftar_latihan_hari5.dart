import 'package:flutter/material.dart';
import 'halaman_base_latihan.dart';

class Hari5 extends StatelessWidget {
  const Hari5({super.key});

  final List<Map<String, dynamic>> _latihan = const [
    {'nama': 'Lunge', 'durasi': 30, 'icon': Icons.self_improvement, 'gambar': 'assets/latihan/lunge.jpg'},
    {'nama': 'Fire Hydrant Kiri', 'durasi': 20, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/fire_hydrant.jpg'},
    {'nama': 'Fire Hydrant Kanan', 'durasi': 20, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/fire_hydrant.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLatihanPage(
      hariKe: 'Hari 5',
      daftarLatihan: _latihan,
    );
  }
}