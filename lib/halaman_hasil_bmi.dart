import 'package:flutter/material.dart';
import 'halaman_beranda.dart';

class HasilBmiPage extends StatelessWidget {
  final int beratBadan;
  final int targetBerat;
  final int tinggiBadan;
  
  HasilBmiPage({
    super.key,
    required this.beratBadan,
    required this.targetBerat,
    required this.tinggiBadan,
  });

  double hitungBMI() {
    double tinggiMeter = tinggiBadan / 100;
    return beratBadan / (tinggiMeter * tinggiMeter);
  }

  double hitungTargetBMI() {
    double tinggiMeter = tinggiBadan / 100;
    return targetBerat / (tinggiMeter * tinggiMeter);
  }

  String getStatusBMI(double bmi) {
    if (bmi < 18.5) return 'KURUS';
    if (bmi < 25.0) return 'NORMAL';
    if (bmi < 30.0) return 'KEGEMUKAN';
    return 'OBESITAS';
  }

  @override
  Widget build(BuildContext context) {
    double bmiSaatIni = hitungBMI();
    double targetBMI = hitungTargetBMI();
    String status = getStatusBMI(bmiSaatIni);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PERUBAHAN ANDA DIMULAI HARI INI!',
                style: TextStyle(
                  color: Color(0xFFCF0F0F),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFCF0F0F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Target BMI ${targetBMI.toStringAsFixed(1)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '${bmiSaatIni.toStringAsFixed(1)} BMI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'BMI saat ini - $status',
                      style: TextStyle(
                        color: status == 'KEGEMUKAN' ? Colors.white : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Perbaikan: Langsung ke BerandaPage dan hapus semua halaman sebelumnya
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => BerandaPage()),
                      (route) => false, // Menghapus semua halaman sebelumnya
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCF0F0F),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'MULAI LATIHAN',
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
    );
  }
}