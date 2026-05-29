import 'package:flutter/material.dart';
import 'halaman_base_latihan.dart';

class Hari3 extends StatelessWidget {
  const Hari3({super.key});

  final List<Map<String, dynamic>> _latihan = const [
    {'nama': 'Squat', 'durasi': 30, 'icon': Icons.self_improvement, 'gambar': 'assets/latihan/squat.jpg'},
    {'nama': 'Sikap Kucing Sapi', 'durasi': 30, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/kucing_sapi.jpg'},
    {'nama': 'Plank', 'durasi': 30, 'icon': Icons.fitness_center, 'gambar': 'assets/latihan/plank2.jpg'},
    {'nama': 'Posisi Kobra', 'durasi': 30, 'icon': Icons.self_improvement, 'gambar': 'assets/latihan/posisi_kobra2.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLatihanPage(
      hariKe: 'Hari 3',
      daftarLatihan: _latihan,
    );
  }
}