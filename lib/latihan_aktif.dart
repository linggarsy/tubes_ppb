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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
        title: const Text(
          'Melewatkan Latihan?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah Anda yakin ingin melewatkan latihan ini?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak', style: TextStyle(color: Colors.white)),
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
            child: const Text('Ya', style: TextStyle(color: Colors.red)),
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
        title: const Text(
          'Keluar Latihan?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Progress latihan Anda tidak akan tersimpan.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              _timer?.cancel();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!_isFinished && !isLastLatihan)
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: _exitLatihan,
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFFCF0F0F),
                        size: 28,
                      ),
                    ),
                  ),

                if (_isFinished && isLastLatihan)
                  const SizedBox(height: 50),

                const Spacer(),

                Text(
                  _currentLatihan,
                  style: const TextStyle(
                    color: Color(0xFFCF0F0F),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Timer Circle
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isFinished
                          ? Colors.green
                          : const Color(0xFFCF0F0F),
                      width: 6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_isFinished
                                ? Colors.green
                                : const Color(0xFFCF0F0F))
                            .withOpacity(0.3),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        color: Color(0xFFCF0F0F),
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Label progress latihan
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCF0F0F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Latihan ${_currentIndex + 1} dari ${widget.daftarLatihan.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

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
                          height: 36,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _timer?.cancel();
                              setState(() {
                                _currentIndex--;
                                _isFinished = false;
                              });
                              _loadCurrentLatihan();
                            },
                            icon: const Icon(Icons.skip_previous, size: 16),
                            label: const Text('Sebelumnya',
                                style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 0),
                            ),
                          ),
                        ),

                      // Tombol Jeda/Mulai
                      SizedBox(
                        height: 36,
                        child: ElevatedButton.icon(
                          onPressed: _togglePause,
                          icon: Icon(
                            _isPaused ? Icons.play_arrow : Icons.pause,
                            size: 16,
                          ),
                          label: Text(
                            _isPaused ? 'Mulai' : 'Jeda',
                            style: const TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCF0F0F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 0),
                          ),
                        ),
                      ),

                      // Tombol Melewatkan
                      SizedBox(
                        height: 36,
                        child: ElevatedButton.icon(
                          onPressed: _skipLatihan,
                          icon: const Icon(Icons.skip_next, size: 16),
                          label: const Text('Melewatkan',
                              style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 180,
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
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            isLastLatihan ? 'SELESAI' : 'LANJUT',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (!isLastLatihan)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: TextButton(
                            onPressed: _exitLatihan,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                            ),
                            child: const Text(
                              'keluar',
                              style: TextStyle(
                                  color: Color(0xFFCF0F0F), fontSize: 14),
                            ),
                          ),
                        ),
                    ],
                  ),

                const Spacer(),

                if (!_isFinished && !isLastLatihan)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextButton(
                      onPressed: _exitLatihan,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                      ),
                      child: const Text(
                        'keluar',
                        style: TextStyle(
                            color: Color(0xFFCF0F0F), fontSize: 14),
                      ),
                    ),
                  ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}