import 'package:flutter/material.dart';
import 'halaman_base_latihan.dart';

class Hari8 extends StatelessWidget {
  const Hari8({super.key});

  final List<Map<String, dynamic>> _latihan = const [
    {'nama': 'Angkat Lutut/Berlari', 'durasi': 30, 'icon': Icons.directions_run, 'gambar': 'assets/latihan/angkat_lutut.jpg'},
    {'nama': 'Loncat Bintang', 'durasi': 20, 'icon': Icons.directions_run, 'gambar': 'assets/latihan/loncat_bintang.jpg'},
    {'nama': 'Meninju', 'durasi': 20, 'icon': Icons.sports_mma, 'gambar': 'assets/latihan/meninju.png'},
    {'nama': 'Putaran Pinggul Berdiri', 'durasi': 20, 'icon': Icons.accessibility_new, 'gambar': 'assets/latihan/putaran_pinggul.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLatihanPage(
      hariKe: 'Hari 8',
      daftarLatihan: _latihan,
    );
  }
}