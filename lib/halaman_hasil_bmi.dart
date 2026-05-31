import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_ppb/services/api_service.dart';
import 'package:tubes_ppb/user_provider.dart';
import 'halaman_beranda.dart';

class HasilBmiPage extends StatefulWidget {
  final int beratBadan;
  final int targetBerat;
  final int tinggiBadan;

  const HasilBmiPage({
    super.key,
    required this.beratBadan,
    required this.targetBerat,
    required this.tinggiBadan,
  });

  @override
  State<HasilBmiPage> createState() => _HasilBmiPageState();
}

class _HasilBmiPageState extends State<HasilBmiPage> {
  bool _isLoading = false;

  double hitungBMI() {
    double tinggiMeter = widget.tinggiBadan / 100;
    return widget.beratBadan / (tinggiMeter * tinggiMeter);
  }

  double hitungTargetBMI() {
    double tinggiMeter = widget.tinggiBadan / 100;
    return widget.targetBerat / (tinggiMeter * tinggiMeter);
  }

  String getStatusBMI(double bmi) {
    if (bmi < 18.5) return 'KURUS';
    if (bmi < 25.0) return 'NORMAL';
    if (bmi < 30.0) return 'KEGEMUKAN';
    return 'OBESITAS';
  }

  Future<void> _simpanDanMulai() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      // Simpan ke SharedPreferences
      await prefs.setInt('user_berat', widget.beratBadan);
      await prefs.setInt('user_target_berat', widget.targetBerat);
      await prefs.setInt('user_tinggi', widget.tinggiBadan);

      // Simpan ke MySQL via API
      final apiService = Provider.of<ApiService>(context, listen: false);
      final nama = prefs.getString('api_nama') ?? '';

      final result = await apiService.updateProfil(
        nama: nama,
        beratBadan: widget.beratBadan,
        targetBerat: widget.targetBerat,
        tinggiBadan: widget.tinggiBadan,
      );

      // Simpan berat awal ke riwayat
      await apiService.saveBerat(widget.beratBadan.toDouble());

      // Update provider
      if (mounted) {
        final userProvider =
            Provider.of<UserProvider>(context, listen: false);
        await userProvider.loadUserData();
      }

      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BerandaPage()),
          (route) => false,
        );
      } else {
        // Tetap lanjut ke beranda meski API gagal
        // karena data sudah tersimpan di SharedPreferences
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BerandaPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Tetap lanjut ke beranda
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BerandaPage()),
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _simpanDanMulai,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCF0F0F),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
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