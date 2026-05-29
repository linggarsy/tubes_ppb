import 'package:flutter/material.dart';
import 'package:tubes_ppb/daftar_latihan_hari1.dart';
import 'package:tubes_ppb/daftar_latihan_hari2.dart';
import 'package:tubes_ppb/daftar_latihan_hari3.dart';
import 'package:tubes_ppb/daftar_latihan_hari4.dart';
import 'package:tubes_ppb/daftar_latihan_hari5.dart';
import 'package:tubes_ppb/daftar_latihan_hari6.dart';
import 'package:tubes_ppb/daftar_latihan_hari7.dart';
import 'package:tubes_ppb/daftar_latihan_hari8.dart';
import 'package:tubes_ppb/daftar_latihan_hari9.dart';
import 'package:tubes_ppb/daftar_latihan_hari10.dart';
import 'package:tubes_ppb/daftar_latihan_hari11.dart';
import 'package:tubes_ppb/daftar_latihan_hari12.dart';

class DaftarHariPage extends StatelessWidget {
  DaftarHariPage({super.key});

  final Map<String, Widget> halamanLatihan = {
    'Hari 1': Hari1(),
    'Hari 2': Hari2(),
    'Hari 3': Hari3(),
    'Hari 4': Hari4(),
    'Hari 5': Hari5(),
    'Hari 6': Hari6(),
    'Hari 7': Hari7(),
    'Hari 8': Hari8(),
    'Hari 9': Hari9(),
    'Hari 10': Hari10(),
    'Hari 11': Hari11(),
    'Hari 12': Hari12(),
  };

  final Map<String, int> jumlahLatihan = {
    'Hari 1': 4, 'Hari 2': 3, 'Hari 3': 4, 'Hari 4': 4,
    'Hari 5': 3, 'Hari 6': 5, 'Hari 7': 4, 'Hari 8': 4,
    'Hari 9': 3, 'Hari 10': 5, 'Hari 11': 3, 'Hari 12': 3,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFCF0F0F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Daftar Tantangan',
          style: TextStyle(color: Color(0xFFCF0F0F)),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(24),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFCF0F0F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Turunkan berat badan & jaga fit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '0/12',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '0%',
                      style: TextStyle(
                        color: Color(0xFFCF0F0F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildWeekSection('MINGGU 1', ['Hari 1', 'Hari 2', 'Hari 3'], context),
                SizedBox(height: 24),
                _buildWeekSection('MINGGU 2', ['Hari 4', 'Hari 5', 'Hari 6'], context),
                SizedBox(height: 24),
                _buildWeekSection('MINGGU 3', ['Hari 7', 'Hari 8', 'Hari 9'], context),
                SizedBox(height: 24),
                _buildWeekSection('MINGGU 4', ['Hari 10', 'Hari 11', 'Hari 12'], context),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSection(String weekTitle, List<String> days, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          weekTitle,
          style: TextStyle(
            color: Color(0xFFCF0F0F),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        ...days.map((day) => _buildDayCard(day, context)),
      ],
    );
  }

  Widget _buildDayCard(String dayTitle, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFCF0F0F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dayTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${jumlahLatihan[dayTitle]} Latihan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => halamanLatihan[dayTitle]!,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFFCF0F0F),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Mulai'),
          ),
        ],
      ),
    );
  }
}