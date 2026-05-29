import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _completedDaysKey = 'completed_days';
  
  List<String>? _cachedCompletedDays;
  
  Future<void> saveCompletedDay(String hari) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> completedDays = prefs.getStringList(_completedDaysKey) ?? [];
    if (!completedDays.contains(hari)) {
      completedDays.add(hari);
      await prefs.setStringList(_completedDaysKey, completedDays);
      _cachedCompletedDays = completedDays;
    }
  }
  
  Future<List<String>> getCompletedDays() async {
    if (_cachedCompletedDays != null) {
      return _cachedCompletedDays!;
    }
    
    final prefs = await SharedPreferences.getInstance();
    _cachedCompletedDays = prefs.getStringList(_completedDaysKey) ?? [];
    return _cachedCompletedDays!;
  }
  
  Future<bool> isDayCompleted(String hari) async {
    final completedDays = await getCompletedDays();
    return completedDays.contains(hari);
  }
  
  Future<int> getCompletedDaysCount() async {
    final completedDays = await getCompletedDays();
    return completedDays.length;
  }
  
  void clearCache() {
    _cachedCompletedDays = null;
  }
}