import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _nama = '';
  int _beratBadan = 0;
  int _targetBerat = 0;
  int _tinggiBadan = 0;
  int _totalLatihan = 0;

  String get nama => _nama;
  int get beratBadan => _beratBadan;
  int get targetBerat => _targetBerat;
  int get tinggiBadan => _tinggiBadan;
  int get totalLatihan => _totalLatihan;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _nama = prefs.getString('user_nama') ?? '';
    _beratBadan = prefs.getInt('user_berat') ?? 0;
    _targetBerat = prefs.getInt('user_target_berat') ?? 0;
    _tinggiBadan = prefs.getInt('user_tinggi') ?? 0;
    _totalLatihan = prefs.getStringList('completed_days')?.length ?? 0;
    notifyListeners();
  }

  void updateBeratBadan(int beratBaru) {
    _beratBadan = beratBaru;
    notifyListeners();
  }

  void updateTotalLatihan(int total) {
    _totalLatihan = total;
    notifyListeners();
  }
}