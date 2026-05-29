import 'package:flutter/material.dart';
import 'halaman_base_latihan.dart';

class Hari10 extends StatelessWidget {
  const Hari10({super.key});

  final List<Map<String, dynamic>> _latihan = const [
    {'nama': 'Putaran Pinggul Berdiri', 'durasi': 20, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/putaran_pinggul.png'},
    {'nama': 'Squat', 'durasi': 30, 'icon': Icons.self_improvement, 'gambar': 'assets/latihan/squat.jpg'},
    {'nama': 'Posisi Kobra', 'durasi': 30, 'icon': Icons.self_improvement, 'gambar': 'assets/latihan/posisi_kobra2.jpg'},
    {'nama': 'Superman', 'durasi': 30, 'icon': Icons.self_improvement, 'gambar': 'assets/latihan/superman.jpg'},
    {'nama': 'Bird Dog', 'durasi': 30, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/bird_dog2.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLatihanPage(
      hariKe: 'Hari 10',
      daftarLatihan: _latihan,
    );
  }
}