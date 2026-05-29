import 'package:flutter/material.dart';
import 'persiapan_latihan.dart';

class DaftarLatihanPage extends StatelessWidget {
  final String hariKe;
  final List<Map<String, dynamic>> daftarLatihan;

  const DaftarLatihanPage({
    super.key,
    required this.hariKe,
    required this.daftarLatihan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFCF0F0F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          hariKe,
          style: TextStyle(color: Color(0xFFCF0F0F)),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header
          Container(
            margin: EdgeInsets.all(24),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFCF0F0F),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hariKe,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${daftarLatihan.length} latihan',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    color: Color(0xFFCF0F0F),
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Text(
                  'Latihan',
                  style: TextStyle(
                    color: Color(0xFFCF0F0F),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 12),
          
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24),
              itemCount: daftarLatihan.length,
              itemBuilder: (context, index) {
                final item = daftarLatihan[index];
                return _buildLatihanCard(
                  nama: item['nama'] as String,
                  durasi: item['durasi'] as int,
                  icon: item['icon'] as IconData,
                  gambar: item['gambar'] as String?,
                );
              },
            ),
          ),
          
          // Tombol MULAI
          Padding(
            padding: EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersiapanLatihan(
                        daftarLatihan: daftarLatihan,
                        currentIndex: 0,
                        hariKe: hariKe,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFCF0F0F),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'MULAI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatihanCard({
    required String nama,
    required int durasi,
    required IconData icon,
    String? gambar,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFCF0F0F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: gambar != null && gambar.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      gambar,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(icon, color: Colors.white, size: 30);
                      },
                    ),
                  )
                : Icon(icon, color: Colors.white, size: 30),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${durasi.toString()} detik',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.play_circle_outline, color: Colors.white, size: 32),
        ],
      ),
    );
  }
}