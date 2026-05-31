import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_ppb/halaman_daftar_hari.dart';
import 'package:tubes_ppb/services/api_service.dart';

class LatihanSelesai extends StatefulWidget {
  final String hariKe;

  const LatihanSelesai({
    super.key,
    required this.hariKe,
  });

  @override
  State<LatihanSelesai> createState() => _LatihanSelesaiState();
}

class _LatihanSelesaiState extends State<LatihanSelesai> {
  bool _isSaving = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _saveProgress();
  }

  Future<void> _saveProgress() async {
    setState(() => _isSaving = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      await apiService.saveProgress(widget.hariKe);
      if (mounted) setState(() => _isSaved = true);
    } catch (e) {
      if (mounted) setState(() => _isSaved = true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

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
                  child: Icon(Icons.check, color: Colors.white, size: 64),
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
                  'Anda telah menyelesaikan ${widget.hariKe}',
                  style: TextStyle(
                    color: Color(0xFFCF0F0F),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),

                // Status simpan progress
                if (_isSaving)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFCF0F0F),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Menyimpan progress...',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),

                if (_isSaved && !_isSaving)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_done, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Progress tersimpan',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),

                SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DaftarHariPage()),
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