import 'dart:async';

import 'package:flutter/material.dart';
import 'latihan_selesai.dart';

class LatihanAktif extends StatefulWidget {
  final List<Map<String, dynamic>> daftarLatihan;
  final int currentIndex;
  final String hariKe;

  const LatihanAktif({
    super.key,
    required this.daftarLatihan,
    required this.currentIndex,
    required this.hariKe,
  });

  @override
  State<LatihanAktif> createState() => _LatihanAktifState();
}

class _LatihanAktifState extends State<LatihanAktif> {
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isPaused = false;
  bool _isFinished = false;

  late String _currentLatihan;
  late int _currentDurasi;
  String? _currentGambar;
  IconData? _currentIcon;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _loadCurrentLatihan();
  }

  void _loadCurrentLatihan() {
    if (_currentIndex < widget.daftarLatihan.length) {
      setState(() {
        _currentLatihan = widget.daftarLatihan[_currentIndex]['nama'];
        _currentDurasi = widget.daftarLatihan[_currentIndex]['durasi'];
        _currentGambar = widget.daftarLatihan[_currentIndex]['gambar'];
        _currentIcon = widget.daftarLatihan[_currentIndex]['icon'];
        _remainingSeconds = _currentDurasi;
        _isPaused = false;
        _isFinished = false;
      });
      _startTimer();
    } else {
      _finishAllLatihan();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused && !_isFinished) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          }
          if (_remainingSeconds == 0) {
            _timer?.cancel();
            _isFinished = true;
            _isPaused = false;
          }
        });
      }
    });
  }

  void _nextLatihan() {
    _timer?.cancel();
    if (_currentIndex + 1 < widget.daftarLatihan.length) {
      setState(() {
        _currentIndex++;
        _isFinished = false;
      });
      _loadCurrentLatihan();
    } else {
      _finishAllLatihan();
    }
  }

  void _finishAllLatihan() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LatihanSelesai(
          hariKe: widget.hariKe,
        ),
      ),
    );
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _skipLatihan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Melewatkan Latihan?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Apakah Anda yakin ingin melewatkan latihan ini?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tidak', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _timer?.cancel();
              setState(() {
                _remainingSeconds = 0;
                _isFinished = true;
                _isPaused = false;
              });
            },
            child: Text('Ya', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _exitLatihan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Keluar Latihan?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Progress latihan Anda tidak akan tersimpan.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text('Kembali', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              _timer?.cancel();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  bool get isLastLatihan =>
      _currentIndex == widget.daftarLatihan.length - 1;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Widget gambar latihan
  Widget _buildGambarLatihan() {
    if (_currentGambar != null && _currentGambar!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          _currentGambar!,
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildIconFallback();
          },
        ),
      );
    }
    return _buildIconFallback();
  }

  // Fallback icon kalau gambar tidak ada
  Widget _buildIconFallback() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: Color(0xFFCF0F0F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        _currentIcon ?? Icons.fitness_center,
        size: 80,
        color: Color(0xFFCF0F0F).withOpacity(0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Progress latihan
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFCF0F0F),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Latihan ${_currentIndex + 1} dari ${widget.daftarLatihan.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Tombol keluar
                  if (!_isFinished)
                    IconButton(
                      onPressed: _exitLatihan,
                      icon: Icon(
                        Icons.close,
                        color: Color(0xFFCF0F0F),
                        size: 28,
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Gambar latihan
                    _buildGambarLatihan(),

                    SizedBox(height: 24),

                    // Nama latihan
                    Text(
                      _currentLatihan,
                      style: TextStyle(
                        color: Color(0xFFCF0F0F),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 24),

                    // Timer Circle
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isFinished
                              ? Colors.green
                              : Color(0xFFCF0F0F),
                          width: 6,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_isFinished
                                    ? Colors.green
                                    : Color(0xFFCF0F0F))
                                .withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _formatTime(_remainingSeconds),
                          style: TextStyle(
                            color: _isFinished
                                ? Colors.green
                                : Color(0xFFCF0F0F),
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Tombol kontrol
                    if (!_isFinished)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          // Tombol Sebelumnya
                          if (_currentIndex > 0)
                            SizedBox(
                              height: 40,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _timer?.cancel();
                                  setState(() {
                                    _currentIndex--;
                                    _isFinished = false;
                                  });
                                  _loadCurrentLatihan();
                                },
                                icon: Icon(Icons.skip_previous,
                                    size: 16),
                                label: Text('Sebelumnya',
                                    style: TextStyle(fontSize: 12)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 0),
                                ),
                              ),
                            ),

                          // Tombol Jeda/Mulai
                          SizedBox(
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed: _togglePause,
                              icon: Icon(
                                _isPaused
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                size: 16,
                              ),
                              label: Text(
                                _isPaused ? 'Mulai' : 'Jeda',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color(0xFFCF0F0F),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 0),
                              ),
                            ),
                          ),

                          // Tombol Melewatkan
                          SizedBox(
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed: _skipLatihan,
                              icon: Icon(Icons.skip_next,
                                  size: 16),
                              label: Text('Lewati',
                                  style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 0),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          // Status selesai
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.green.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.green, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Latihan selesai!',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16),

                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                if (isLastLatihan) {
                                  _finishAllLatihan();
                                } else {
                                  _nextLatihan();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                isLastLatihan ? 'SELESAI' : 'LANJUT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          if (!isLastLatihan)
                            Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: TextButton(
                                onPressed: _exitLatihan,
                                child: Text(
                                  'Keluar',
                                  style: TextStyle(
                                      color: Color(0xFFCF0F0F),
                                      fontSize: 14),
                                ),
                              ),
                            ),
                        ],
                      ),

                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom keluar saat latihan berjalan
            if (!_isFinished)
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: TextButton(
                  onPressed: _exitLatihan,
                  child: Text(
                    'Keluar',
                    style: TextStyle(
                        color: Color(0xFFCF0F0F), fontSize: 14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}