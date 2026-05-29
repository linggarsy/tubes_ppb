import 'package:flutter/material.dart';
import 'package:tubes_ppb/halaman_target_berat.dart';

class BeratBadanPage extends StatefulWidget {
  BeratBadanPage({super.key});

  @override
  State<BeratBadanPage> createState() => _BeratBadanPageState();
}

class _BeratBadanPageState extends State<BeratBadanPage> {
  double _beratBadan = 70;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                'BERAPA BERAT ANDA?',
                style: TextStyle(
                  color: Color(0xFFCF0F0F),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Izinkan kami mengenal Anda lebih baik agar kami dapat membantu meningkatkan hasil latihan Anda',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Spacer(),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_beratBadan > 20) _beratBadan -= 1;
                            });
                          },
                          icon: Icon(Icons.remove_circle_outline,
                              color: Color(0xFFCF0F0F), size: 40),
                        ),
                        SizedBox(width: 30),
                        Text(
                          '${_beratBadan.toInt()}',
                          style: TextStyle(
                            color: Color(0xFFCF0F0F),
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 30),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_beratBadan < 200) _beratBadan += 1;
                            });
                          },
                          icon: Icon(Icons.add_circle_outline,
                              color: Color(0xFFCF0F0F), size: 40),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'kg',
                      style: TextStyle(
                        color: Color(0xFFCF0F0F),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TargetBeratPage(beratAwal: _beratBadan.toInt()),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCF0F0F),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'LANJUT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}