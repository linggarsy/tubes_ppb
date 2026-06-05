import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_ppb/daftar_latihan_hari1.dart';
import 'package:tubes_ppb/daftar_latihan_hari2.dart';
import 'package:tubes_ppb/daftar_latihan_hari3.dart';
import 'package:tubes_ppb/daftar_latihan_hari4.dart';
import 'package:tubes_ppb/daftar_latihan_hari5.dart';
import 'package:tubes_ppb/daftar_latihan_hari6.dart';
import 'package:tubes_ppb/daftar_latihan_hari7.dart';
import 'package:tubes_ppb/daftar_latihan_hari8.dart';
import 'package:tubes_ppb/daftar_latihan_hari9.dart';
import 'package:tubes_ppb/daftar_latihan_hari10.dart';
import 'package:tubes_ppb/daftar_latihan_hari11.dart';
import 'package:tubes_ppb/daftar_latihan_hari12.dart';
import 'package:tubes_ppb/services/api_service.dart';

class DaftarHariPage extends StatefulWidget {
  DaftarHariPage({super.key});

  @override
  State<DaftarHariPage> createState() => _DaftarHariPageState();
}

class _DaftarHariPageState extends State<DaftarHariPage> {
  List<String> _completedDays = [];
  bool _isLoading = true;
  final int _totalHari = 12;

  final Map<String, int> jumlahLatihan = {
    'Hari 1': 4, 'Hari 2': 3, 'Hari 3': 4, 'Hari 4': 4,
    'Hari 5': 3, 'Hari 6': 5, 'Hari 7': 4, 'Hari 8': 4,
    'Hari 9': 3, 'Hari 10': 5, 'Hari 11': 3, 'Hari 12': 3,
  };

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final result = await apiService.getProgress();

      if (result['success'] == true) {
        final days =
            List<String>.from(result['data']['completed_days'] ?? []);
        if (!mounted) return;
        setState(() {
          _completedDays = days;
        });
      }
    } catch (e) {
      // fallback kosong
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Cek apakah hari sudah selesai
  bool _isDayCompleted(String day) => _completedDays.contains(day);

  // Cek apakah hari bisa diklik
  // Hari bisa diklik jika:
  // - Hari 1 selalu bisa diklik
  // - Hari N bisa diklik jika Hari N-1 sudah selesai
  // - Hari yang sudah selesai bisa diklik lagi (review)
  bool _isDayUnlocked(String day) {
    int hariIndex = int.parse(day.split(' ')[1]);
    if (hariIndex == 1) return true;
    String hariSebelumnya = 'Hari ${hariIndex - 1}';
    return _completedDays.contains(hariSebelumnya);
  }

  // Persentase progress
  double get _progressPercent =>
      _totalHari > 0 ? _completedDays.length / _totalHari : 0;

  // Navigasi ke halaman latihan
  Widget _getHalamanLatihan(String day) {
    switch (day) {
      case 'Hari 1': return Hari1();
      case 'Hari 2': return Hari2();
      case 'Hari 3': return Hari3();
      case 'Hari 4': return Hari4();
      case 'Hari 5': return Hari5();
      case 'Hari 6': return Hari6();
      case 'Hari 7': return Hari7();
      case 'Hari 8': return Hari8();
      case 'Hari 9': return Hari9();
      case 'Hari 10': return Hari10();
      case 'Hari 11': return Hari11();
      case 'Hari 12': return Hari12();
      default: return Hari1();
    }
  }

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
          'Daftar Tantangan',
          style: TextStyle(color: Color(0xFFCF0F0F)),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Color(0xFFCF0F0F)),
            )
          : Column(
              children: [
                // Progress Card
                Container(
                  margin: EdgeInsets.all(24),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFCF0F0F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Turunkan berat badan & jaga fit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${_completedDays.length}/$_totalHari hari selesai',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${(_progressPercent * 100).toInt()}%',
                                style: TextStyle(
                                  color: Color(0xFFCF0F0F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _progressPercent,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          color: Colors.white,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),

                // List hari
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadProgress,
                    color: Color(0xFFCF0F0F),
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _buildWeekSection(
                            'MINGGU 1',
                            ['Hari 1', 'Hari 2', 'Hari 3'],
                            context),
                        SizedBox(height: 24),
                        _buildWeekSection(
                            'MINGGU 2',
                            ['Hari 4', 'Hari 5', 'Hari 6'],
                            context),
                        SizedBox(height: 24),
                        _buildWeekSection(
                            'MINGGU 3',
                            ['Hari 7', 'Hari 8', 'Hari 9'],
                            context),
                        SizedBox(height: 24),
                        _buildWeekSection(
                            'MINGGU 4',
                            ['Hari 10', 'Hari 11', 'Hari 12'],
                            context),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildWeekSection(
      String weekTitle, List<String> days, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weekTitle,
          style: TextStyle(
            color: Color(0xFFCF0F0F),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        ...days.map((day) => _buildDayCard(day, context)),
      ],
    );
  }

  Widget _buildDayCard(String dayTitle, BuildContext context) {
    final bool isCompleted = _isDayCompleted(dayTitle);
    final bool isUnlocked = _isDayUnlocked(dayTitle);

    // Warna berdasarkan status
    Color cardColor;
    Color textColor;
    Color buttonColor;
    Color buttonTextColor;
    String buttonLabel;
    IconData? statusIcon;

    if (isCompleted) {
      // Sudah selesai → hijau gelap
      cardColor = Colors.green.shade700;
      textColor = Colors.white;
      buttonColor = Colors.white;
      buttonTextColor = Colors.green.shade700;
      buttonLabel = 'Ulangi';
      statusIcon = Icons.check_circle;
    } else if (isUnlocked) {
      // Belum selesai tapi bisa diklik → merah
      cardColor = Color(0xFFCF0F0F);
      textColor = Colors.white;
      buttonColor = Colors.white;
      buttonTextColor = Color(0xFFCF0F0F);
      buttonLabel = 'Mulai';
      statusIcon = null;
    } else {
      // Terkunci → abu-abu gelap
      cardColor = Colors.grey.shade800;
      textColor = Colors.white60;
      buttonColor = Colors.grey.shade600;
      buttonTextColor = Colors.white60;
      buttonLabel = 'Terkunci';
      statusIcon = Icons.lock;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Icon status
              if (statusIcon != null) ...[
                Icon(statusIcon, color: textColor, size: 20),
                SizedBox(width: 8),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayTitle,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${jumlahLatihan[dayTitle]} Latihan',
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: isUnlocked || isCompleted
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _getHalamanLatihan(dayTitle),
                      ),
                    ).then((_) => _loadProgress());
                  }
                : null, // null = tidak bisa diklik
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: buttonTextColor,
              disabledBackgroundColor: Colors.grey.shade600,
              disabledForegroundColor: Colors.white60,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              buttonLabel,
              style: TextStyle(
                color: isUnlocked || isCompleted
                    ? buttonTextColor
                    : Colors.white60,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}