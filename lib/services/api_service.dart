import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Ganti IP sesuai IP komputer kamu
  static const String baseUrl = 'http://192.168.1.10/tubes_ppb_backend';

  // Key SharedPreferences
  static const String _keyUserId = 'api_user_id';
  static const String _keyEmail = 'api_email';
  static const String _keyNama = 'api_nama';
  static const String _keyProvider = 'api_provider';

  // Auth
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    String nama = '',
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
              'nama': nama,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        await _saveUserSession(data['data']);
      }

      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        await _saveUserSession(data['data']);
      }

      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: ${e.toString()}',
      };
    }
  }

  // Login via Google (kirim data Google ke backend)
  Future<Map<String, dynamic>> loginWithGoogle({
    required String email,
    required String nama,
    required String fotoUrl,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login_google.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'nama': nama,
              'foto_url': fotoUrl,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        await _saveUserSession(data['data']);
      }

      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: ${e.toString()}',
      };
    }
  }

  //Profil
  Future<Map<String, dynamic>> getProfil() async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        return {'success': false, 'message': 'User tidak ditemukan'};
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/user/get_profil.php?user_id=$userId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> updateProfil({
    required String nama,
    required int beratBadan,
    required int targetBerat,
    required int tinggiBadan,
  }) async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        return {'success': false, 'message': 'User tidak ditemukan'};
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/user/update_profil.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'user_id': userId,
              'nama': nama,
              'berat_badan': beratBadan,
              'target_berat': targetBerat,
              'tinggi_badan': tinggiBadan,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      // Update nama di SharedPreferences
      if (data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyNama, nama);
        await prefs.setInt('user_berat', beratBadan);
        await prefs.setInt('user_target_berat', targetBerat);
        await prefs.setInt('user_tinggi', tinggiBadan);
      }

      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: ${e.toString()}',
      };
    }
  }

  // Progress
  Future<Map<String, dynamic>> saveProgress(String hari) async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        return {'success': false, 'message': 'User tidak ditemukan'};
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/progress/save_progress.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'user_id': userId,
              'hari': hari,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> getProgress() async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        return {'success': false, 'message': 'User tidak ditemukan'};
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/progress/get_progress.php?user_id=$userId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> resetProgress() async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        return {'success': false, 'message': 'User tidak ditemukan'};
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/progress/reset_progress.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'user_id': userId}),
          )
          .timeout(const Duration(seconds: 10));

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: ${e.toString()}',
      };
    }
  }

  // BB
  Future<Map<String, dynamic>> saveBerat(double berat) async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        return {'success': false, 'message': 'User tidak ditemukan'};
      }

      final response = await http
          .post(
            Uri.parse('$baseUrl/berat/save_berat.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'user_id': userId,
              'berat': berat,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> getRiwayatBerat() async {
    try {
      final userId = await getUserId();
      if (userId == null) {
        return {'success': false, 'message': 'User tidak ditemukan'};
      }

      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/berat/get_berat.php?user_id=$userId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server: ${e.toString()}',
      };
    }
  }

  // Session
  Future<void> _saveUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userData['user_id'] ?? 0);
    await prefs.setString(_keyEmail, userData['email'] ?? '');
    await prefs.setString(_keyNama, userData['nama'] ?? '');
    await prefs.setString(_keyProvider, userData['provider'] ?? 'email');

    // Simpan data profil jika ada
    if (userData['berat_badan'] != null && userData['berat_badan'] > 0) {
      await prefs.setInt('user_berat', userData['berat_badan']);
      await prefs.setInt('user_target_berat', userData['target_berat'] ?? 0);
      await prefs.setInt('user_tinggi', userData['tinggi_badan'] ?? 0);
    }
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_keyUserId);
    return (id != null && id > 0) ? id : null;
  }

  Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ?? '';
  }

  Future<String> getUserNama() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNama) ?? '';
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyNama);
    await prefs.remove(_keyProvider);
  }
}