import 'package:flutter/material.dart';
import 'halaman_base_latihan.dart';

class Hari7 extends StatelessWidget {
  const Hari7({super.key});

  final List<Map<String, dynamic>> _latihan = const [
    {'nama': 'Flutter Kicks', 'durasi': 30, 'icon': Icons.fitness_center, 'gambar': 'assets/latihan/flutter_kicks.jpg'},
    {'nama': 'Crunch Tendang', 'durasi': 30, 'icon': Icons.fitness_center, 'gambar': 'assets/latihan/crunch_tendang.jpg'},
    {'nama': 'Superman', 'durasi': 30, 'icon': Icons.self_improvement, 'gambar': 'assets/latihan/superman.jpg'},
    {'nama': 'Bird Dog', 'durasi': 30, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/bird_dog2.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLatihanPage(
      hariKe: 'Hari 7',
      daftarLatihan: _latihan,
    );
  }
}