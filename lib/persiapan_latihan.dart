import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tubes_ppb/latihan_aktif.dart';

class PersiapanLatihan extends StatefulWidget {
  final List<Map<String, dynamic>> daftarLatihan;
  final int currentIndex;
  final String hariKe;

  const PersiapanLatihan({
    super.key,
    required this.daftarLatihan,
    required this.currentIndex,
    required this.hariKe,
  });

  @override
  State<PersiapanLatihan> createState() => _PersiapanLatihanState();
}

class _PersiapanLatihanState extends State<PersiapanLatihan> {
  int _countdown = 10;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LatihanAktif(
                daftarLatihan: widget.daftarLatihan,
                currentIndex: widget.currentIndex,
                hariKe: widget.hariKe,
              ),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Siap beraksi!',
                style: TextStyle(
                  color: Color(0xFFCF0F0F),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFCF0F0F),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFCF0F0F).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$_countdown',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Persiapkan dirimu',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _timer.cancel();
                  Navigator.pop(context);
                },
                child: Text(
                  'Batal',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}