import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tubes_ppb/halaman_saya.dart';
import 'package:tubes_ppb/halaman_beranda.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'progress_service.dart';

class HalamanLaporkan extends StatefulWidget {
  const HalamanLaporkan({super.key});

  @override
  State<HalamanLaporkan> createState() => _HalamanLaporkanState();
}

class _HalamanLaporkanState extends State<HalamanLaporkan> {
  final ProgressService _progressService = ProgressService();
  int _totalLatihan = 0;
  double _totalKkal = 0;
  int _totalMenit = 0;
  
  // Data untuk grafik berat badan
  List<double> _beratBadanData = [150, 140, 135, 130, 128, 125, 122];
  final List<String> _tanggal = ['09', '10', '11', '12', '13', '14', '15'];
  
  double _beratSaatIni = 122.0;
  double _beratTertinggi = 150.0;
  double _beratTerendah = 122.0;
  
  double _bmi = 0.0;
  double _tinggiBadan = 165;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadTinggiBadan();
  }

  Future<void> _loadTinggiBadan() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tinggiBadan = prefs.getInt('user_tinggi')?.toDouble() ?? 165;
      _hitungBMI();
    });
  }

  void _hitungBMI() {
    double tinggiMeter = _tinggiBadan / 100;
    _bmi = _beratSaatIni / (tinggiMeter * tinggiMeter);
  }

  Future<void> _loadData() async {
    final completedDays = await _progressService.getCompletedDays();
    
    setState(() {
      _totalLatihan = completedDays.length;
      _totalKkal = completedDays.length * 85.5;
      _totalMenit = completedDays.length * 15;
      _hitungBMI();
    });
  }

  void _catatBeratBadan() {
    final TextEditingController beratController = TextEditingController();
    beratController.text = _beratSaatIni.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Catat Berat Badan',
          style: TextStyle(color: Color(0xFFCF0F0F)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Masukkan berat badan Anda saat ini:'),
            SizedBox(height: 16),
            Text(
              'Berat Badan',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFCF0F0F),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            TextField(
              controller: beratController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Contoh: 65.5',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixText: 'kg',
                suffixStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              double beratBaru = double.tryParse(beratController.text) ?? _beratSaatIni;
              if (beratBaru > 0) {
                setState(() {
                  _beratSaatIni = beratBaru;
                  
                  // Update data grafik
                  _beratBadanData.add(beratBaru);
                  if (_beratBadanData.length > 7) {
                    _beratBadanData.removeAt(0);
                  }
                  
                  // Update tertinggi dan terendah
                  if (beratBaru > _beratTertinggi) _beratTertinggi = beratBaru;
                  if (beratBaru < _beratTerendah) _beratTerendah = beratBaru;
                  
                  _hitungBMI();
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Berat badan berhasil dicatat: ${beratBaru.toStringAsFixed(1)} kg'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFCF0F0F),
            ),
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _tambahBMI() {
    final TextEditingController beratController = TextEditingController();
    final TextEditingController tinggiController = TextEditingController();
    beratController.text = _beratSaatIni.toString();
    tinggiController.text = _tinggiBadan.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hitung BMI',
          style: TextStyle(color: Color(0xFFCF0F0F)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan data untuk menghitung BMI:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            
            // Label Berat Badan
            Text(
              'Berat Badan',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFCF0F0F),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            TextField(
              controller: beratController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Contoh: 65.5',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixText: 'kg',
                suffixStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Label Tinggi Badan
            Text(
              'Tinggi Badan',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFCF0F0F),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            TextField(
              controller: tinggiController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Contoh: 165',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixText: 'cm',
                suffixStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Informasi tambahan
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFFCF0F0F), size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'BMI = Berat Badan (kg) / (Tinggi Badan (m) × Tinggi Badan (m))',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              double berat = double.tryParse(beratController.text) ?? _beratSaatIni;
              double tinggi = double.tryParse(tinggiController.text) ?? _tinggiBadan;
              
              if (berat <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Berat badan harus lebih dari 0'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              
              if (tinggi <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tinggi badan harus lebih dari 0'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              
              setState(() {
                _beratSaatIni = berat;
                _tinggiBadan = tinggi;
                _hitungBMI();
                
                // Update tertinggi/terendah
                if (berat > _beratTertinggi) _beratTertinggi = berat;
                if (berat < _beratTerendah) _beratTerendah = berat;
              });
              
              // Tampilkan hasil BMI dengan detail
              String status = _getBmiStatus(_bmi);
              String statusMessage;
              switch (status) {
                case 'Kurus':
                  statusMessage = 'Anda tergolong kurus. Disarankan untuk menambah berat badan.';
                  break;
                case 'Normal':
                  statusMessage = 'Anda tergolong normal. Pertahankan!';
                  break;
                case 'Gemuk':
                  statusMessage = 'Anda tergolong gemuk. Mulai latihan yuk!';
                  break;
                default:
                  statusMessage = 'Anda tergolong obesitas. Yuk mulai hidup sehat!';
              }
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'BMI: ${_bmi.toStringAsFixed(1)} ($status)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        statusMessage,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  backgroundColor: status == 'Normal' ? Colors.green : Color(0xFFCF0F0F),
                  duration: Duration(seconds: 3),
                ),
              );
              
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFCF0F0F),
            ),
            child: Text('Hitung'),
          ),
        ],
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
            // Header
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Text(
                    'Laporkan',
                    style: TextStyle(
                      color: Color(0xFFCF0F0F),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Total Statistik Card
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFCF0F0F),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Total Latihan
                        Column(
                          children: [
                            Text(
                              '$_totalLatihan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'LATIHAN',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // Total Kkal
                        Column(
                          children: [
                            Text(
                              '${_totalKkal.toStringAsFixed(1)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'KKAL',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // Total Menit
                        Column(
                          children: [
                            Text(
                              _formatMenit(_totalMenit),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'MENIT',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Berat Badan Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Berat Badan',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: _catatBeratBadan,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFCF0F0F),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Catat',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Grafik Berat Badan
                  Container(
                    height: 200,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: 30,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.shade300,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index >= 0 && index < _tanggal.length) {
                                  return Text(
                                    _tanggal[index],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  );
                                }
                                return Text('');
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: (_beratBadanData.length - 1).toDouble(),
                        minY: (_beratBadanData.reduce((a, b) => a < b ? a : b) - 10).clamp(20, 200),
                        maxY: (_beratBadanData.reduce((a, b) => a > b ? a : b) + 10).clamp(30, 250),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _beratBadanData.asMap().entries.map((e) {
                              return FlSpot(e.key.toDouble(), e.value);
                            }).toList(),
                            isCurved: true,
                            color: Color(0xFFCF0F0F),
                            barWidth: 3,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: Color(0xFFCF0F0F),
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Color(0xFFCF0F0F).withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Statistik Berat Badan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBeratCard('Saat ini', '${_beratSaatIni.toStringAsFixed(1)}kg', Color(0xFFCF0F0F)),
                      _buildBeratCard('Tertinggi', '${_beratTertinggi.toStringAsFixed(1)}kg', Colors.orange),
                      _buildBeratCard('Terendah', '${_beratTerendah.toStringAsFixed(1)}kg', Colors.green),
                    ],
                  ),
                  
                  SizedBox(height: 24),
                  
                  // BMI Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'BMI (kg/m²)',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: _tambahBMI,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFCF0F0F),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Tambah',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // BMI Card
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFCF0F0F),
                          Color(0xFFCF0F0F).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _bmi.toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _getBmiStatus(_bmi),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _getBmiProgress(_bmi),
                          backgroundColor: Colors.white.withOpacity(0.3),
                          color: Colors.white,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kurus',
                              style: TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                            Text(
                              'Normal',
                              style: TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                            Text(
                              'Gemuk',
                              style: TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                            Text(
                              'Obesitas',
                              style: TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 80),
                ],
              ),
            ),
            
            // Bottom Navigation Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBottomNavItem(Icons.home, 'Beranda', false, context),
                    _buildBottomNavItem(Icons.bar_chart, 'Laporkan', true, context),
                    _buildBottomNavItem(Icons.person, 'Saya', false, context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeratCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMenit(int totalMenit) {
    int jam = totalMenit ~/ 60;
    int menit = totalMenit % 60;
    if (jam > 0) {
      return '${jam.toString().padLeft(2, '0')}:${menit.toString().padLeft(2, '0')}';
    }
    return '${menit.toString().padLeft(2, '0')}:00';
  }

  String _getBmiStatus(double bmi) {
    if (bmi < 18.5) return 'Kurus';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Gemuk';
    return 'Obesitas';
  }

  double _getBmiProgress(double bmi) {
    if (bmi < 18.5) return bmi / 18.5 * 0.25;
    if (bmi < 25.0) return 0.25 + (bmi - 18.5) / 6.5 * 0.25;
    if (bmi < 30.0) return 0.5 + (bmi - 25.0) / 5.0 * 0.25;
    return 0.75 + (bmi - 30.0) / 10.0 * 0.25;
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive, BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          if (label == 'Beranda') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BerandaPage()),
            );
          } else if (label == 'Saya') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HalamanSaya()),
            );
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Color(0xFFCF0F0F) : Colors.grey,
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Color(0xFFCF0F0F) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}