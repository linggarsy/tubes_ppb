import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_ppb/firebase_options.dart';
import 'package:tubes_ppb/halaman_laporkan.dart';
import 'package:tubes_ppb/halaman_saya.dart';
import 'package:tubes_ppb/halaman_sign_in.dart';
import 'package:tubes_ppb/halaman_sign_up.dart';
import 'package:tubes_ppb/services/auth_service.dart';
import 'package:tubes_ppb/user_provider.dart';
import 'package:tubes_ppb/services/api_service.dart';
import 'halaman_berat_badan.dart';
import 'halaman_beranda.dart';
import 'halaman_daftar_hari.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ApiService>(create: (_) => ApiService()),  // tambah ini
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
      child: MaterialApp(
        title: 'Tubes PPB',
        theme: ThemeData(
          primaryColor: Color(0xFFCF0F0F),
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
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFCF0F0F)),
            ),
          );
        }

        // Sudah login via Firebase
        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<bool>(
            future: _checkHasFilledData(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(color: Color(0xFFCF0F0F)),
                  ),
                );
              }
              if (dataSnapshot.data == true) {
                return BerandaPage();
              } else {
                return BeratBadanPage();
              }
            },
          );
        }

        // Belum login
        return SignInPage();
      },
    );
  }

  Future<bool> _checkHasFilledData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_berat');
  }
}