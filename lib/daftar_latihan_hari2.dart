import 'package:flutter/material.dart';
import 'halaman_base_latihan.dart';

class Hari2 extends StatelessWidget {
  const Hari2({super.key});

  final List<Map<String, dynamic>> _latihan = const [
    {'nama': 'Meninju', 'durasi': 20, 'icon': Icons.sports_mma, 'gambar': 'assets/latihan/meninju.png'},
    {'nama': 'Plank', 'durasi': 30, 'icon': Icons.fitness_center, 'gambar': 'assets/latihan/plank2.jpg'},
    {'nama': 'Posisi Kobra', 'durasi': 30, 'icon': Icons.self_improvement, 'gambar': 'assets/latihan/posisi_kobra2.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLatihanPage(
      hariKe: 'Hari 2',
      daftarLatihan: _latihan,
    );
  }
}