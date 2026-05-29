import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilSayaPage extends StatefulWidget {
  const ProfilSayaPage({super.key});

  @override
  State<ProfilSayaPage> createState() => _ProfilSayaPageState();
}

class _ProfilSayaPageState extends State<ProfilSayaPage> {
  final _formKey = GlobalKey<FormState>();
  
  String _nama = '';
  int _beratBadan = 70;
  int _targetBerat = 60;
  int _tinggiBadan = 165;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  Future<void> _loadProfil() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('user_nama') ?? '';
      _beratBadan = prefs.getInt('user_berat') ?? 70;
      _targetBerat = prefs.getInt('user_target_berat') ?? 60;
      _tinggiBadan = prefs.getInt('user_tinggi') ?? 165;
      _isLoading = false;
    });
  }

  Future<void> _saveProfil() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_nama', _nama);
      await prefs.setInt('user_berat', _beratBadan);
      await prefs.setInt('user_target_berat', _targetBerat);
      await prefs.setInt('user_tinggi', _tinggiBadan);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profil berhasil disimpan'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      Navigator.pop(context);
    }
  }

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
          'Profil Saya',
          style: TextStyle(color: Color(0xFFCF0F0F)),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Avatar
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFFCF0F0F).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Color(0xFFCF0F0F),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Nama
                    Text(
                      'Nama Lengkap',
                      style: TextStyle(
                        color: Color(0xFFCF0F0F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: _nama,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama Anda',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFFCF0F0F)),
                        ),
                      ),
                      onSaved: (value) => _nama = value ?? '',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Berat Badan
                    Text(
                      'Berat Badan (kg)',
                      style: TextStyle(
                        color: Color(0xFFCF0F0F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _beratBadan.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '70',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onSaved: (value) => _beratBadan = int.parse(value ?? '70'),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Isi berat badan';
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Text('kg', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Target Berat
                    Text(
                      'Target Berat (kg)',
                      style: TextStyle(
                        color: Color(0xFFCF0F0F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _targetBerat.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '60',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onSaved: (value) => _targetBerat = int.parse(value ?? '60'),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Isi target berat';
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Text('kg', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Tinggi Badan
                    Text(
                      'Tinggi Badan (cm)',
                      style: TextStyle(
                        color: Color(0xFFCF0F0F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _tinggiBadan.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '165',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onSaved: (value) => _tinggiBadan = int.parse(value ?? '165'),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Isi tinggi badan';
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Text('cm', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    
                    SizedBox(height: 32),
                    
                    ElevatedButton(
                      onPressed: _saveProfil,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFCF0F0F),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'SIMPAN PERUBAHAN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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