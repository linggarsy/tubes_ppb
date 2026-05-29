import 'package:flutter/material.dart';
import 'halaman_base_latihan.dart';

class Hari12 extends StatelessWidget {
  const Hari12({super.key});

  final List<Map<String, dynamic>> _latihan = const [
    {'nama': 'Ayun Lengan Searah Jarum Jam', 'durasi': 20, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/ayun_lengan2.jpg'},
    {'nama': 'Lunge', 'durasi': 30, 'icon': Icons.self_improvement, 'gambar': 'assets/latihan/lunge.jpg'},
    {'nama': 'Putaran Pinggul Berdiri', 'durasi': 20, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/putaran_pinggul.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLatihanPage(
      hariKe: 'Hari 12',
      daftarLatihan: _latihan,
    );
  }
}