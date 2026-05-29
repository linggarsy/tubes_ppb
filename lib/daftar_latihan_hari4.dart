import 'package:flutter/material.dart';
import 'halaman_base_latihan.dart';

class Hari4 extends StatelessWidget {
  const Hari4({super.key});

  final List<Map<String, dynamic>> _latihan = const [
    {'nama': 'Jingkat Samping', 'durasi': 30, 'icon': Icons.directions_run, 'gambar': 'assets/latihan/jingkat_samping.jpg'},
    {'nama': 'Meninju', 'durasi': 20, 'icon': Icons.sports_mma, 'gambar': 'assets/latihan/meninju.png'},
    {'nama': 'Sikap Kucing Sapi', 'durasi': 30, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/kucing_sapi.jpg'},
    {'nama': 'Posisi Kobra', 'durasi': 30, 'icon': Icons.self_improvement, 'gambar': 'assets/latihan/posisi_kobra2.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLatihanPage(
      hariKe: 'Hari 4',
      daftarLatihan: _latihan,
    );
  }
}