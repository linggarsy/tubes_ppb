import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_ppb/halaman_laporkan.dart';
import 'package:tubes_ppb/halaman_saya.dart';
import 'package:tubes_ppb/halaman_sign_in.dart';
import 'package:tubes_ppb/halaman_sign_up.dart';
import 'halaman_berat_badan.dart';
import 'halaman_beranda.dart';
import 'halaman_daftar_hari.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tubes PPB',
      theme: ThemeData(
        primaryColor:  Color(0xFFCF0F0F),
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
        '/berat': (context) => BeratBadanPage(),
        '/beranda': (context) => BerandaPage(),
        '/daftar-hari': (context) => DaftarHariPage(),
        '/laporkan': (context) => HalamanLaporkan(),
        '/saya': (context) => HalamanSaya(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFCF0F0F),
              ),
            ),
          );
        }
        
        if (snapshot.hasData && snapshot.data == true) {
          return FutureBuilder<bool>(
            future: _checkHasFilledData(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFCF0F0F),
                    ),
                  ),
                );
              }
              
              if (dataSnapshot.hasData && dataSnapshot.data == true) {
                // Sudah pernah isi, ke Beranda
                return BerandaPage();
              } else {
                // Belum pernah isi, ke halaman berat badan
                return BeratBadanPage();
              }
            },
          );
        } else {
          return SignInPage();
        }
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  Future<bool> _checkHasFilledData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_berat');
  }
}