import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_ppb/firebase_options.dart';
import 'package:tubes_ppb/halaman_laporkan.dart';
import 'package:tubes_ppb/halaman_saya.dart';
import 'package:tubes_ppb/halaman_sign_in.dart';
import 'package:tubes_ppb/halaman_sign_up.dart';
import 'package:tubes_ppb/services/api_service.dart';
import 'package:tubes_ppb/services/auth_service.dart';
import 'package:tubes_ppb/user_provider.dart';
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
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Tubes PPB',
        theme: ThemeData(
          primaryColor: const Color(0xFFCF0F0F),
          fontFamily: 'Poppins',
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/signin': (context) => SignInPage(),
          '/signup': (context) => SignUpPage(),
          '/berat': (context) => BeratBadanPage(),
          '/beranda': (context) => BerandaPage(),
          '/daftar-hari': (context) => DaftarHariPage(),
          '/laporkan': (context) => const HalamanLaporkan(),
          '/saya': (context) => const HalamanSaya(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Loading Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFCF0F0F)),
            ),
          );
        }

        // Error
        if (snapshot.hasError) {
          print('Auth stream error: ${snapshot.error}');
          return SignInPage();
        }

        // Sudah login via Firebase
        if (snapshot.hasData && snapshot.data != null) {
          return const _CheckUserDataPage();
        }

        // Belum login
        return SignInPage();
      },
    );
  }
}

// Widget terpisah untuk cek data user dari MySQL
class _CheckUserDataPage extends StatefulWidget {
  const _CheckUserDataPage();

  @override
  State<_CheckUserDataPage> createState() => _CheckUserDataPageState();
}

class _CheckUserDataPageState extends State<_CheckUserDataPage> {
  @override
  void initState() {
    super.initState();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      // Cek apakah user_id tersimpan di session
      final userId = await apiService.getUserId();

      print('=== CHECK USER DATA ===');
      print('userId: $userId');

      if (userId == null) {
        // Belum ada session MySQL → ke Sign In
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/signin');
        return;
      }

      // Ambil profil dari MySQL
      final result = await apiService.getProfil();
      print('profil result: $result');

      if (!mounted) return;

      if (result['success'] == true) {
        final data = result['data'];
        final beratBadan = data['berat_badan'] ?? 0;
        final tinggiBadan = data['tinggi_badan'] ?? 0;

        // Cek apakah sudah isi data profil
        final hasFilledData = beratBadan > 0 && tinggiBadan > 0;

        print('hasFilledData: $hasFilledData');

        if (hasFilledData) {
          // Pengguna lama → langsung ke Beranda
          Navigator.pushReplacementNamed(context, '/beranda');
        } else {
          // Pengguna baru → isi data dulu
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BeratBadanPage()),
          );
        }
      } else {
        // Gagal ambil profil → ke Sign In
        Navigator.pushReplacementNamed(context, '/signin');
      }
    } catch (e) {
      print('Error check user data: $e');
      if (!mounted) return;
      // Error → ke Sign In
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFCF0F0F)),
            SizedBox(height: 16),
            Text(
              'Memuat data...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}