import 'package:flutter/material.dart';
import 'package:tubes_ppb/halaman_daftar_hari.dart';

class LatihanSelesai extends StatelessWidget {
  const LatihanSelesai({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Selamat!',
                  style: TextStyle(
                    color: Color(0xFFCF0F0F),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Anda telah menyelesaikan latihan hari ini',
                  style: TextStyle(
                    color: Color(0xFFCF0F0F),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => DaftarHariPage()),
                        (route) => false,
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
                      'Selesai',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}