import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_ppb/services/api_service.dart';
import 'package:tubes_ppb/user_provider.dart';

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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  Future<void> _loadProfil() async {
    setState(() => _isLoading = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final result = await apiService.getProfil();

      if (result['success'] == true) {
        final data = result['data'];
        setState(() {
          _nama = data['nama'] ?? '';
          _beratBadan = data['berat_badan'] ?? 70;
          _targetBerat = data['target_berat'] ?? 60;
          _tinggiBadan = data['tinggi_badan'] ?? 165;
        });
      }
    } catch (e) {
      // Fallback ke UserProvider
      if (mounted) {
        final userProvider =
            Provider.of<UserProvider>(context, listen: false);
        setState(() {
          _nama = userProvider.nama;
          _beratBadan = userProvider.beratBadan;
          _targetBerat = userProvider.targetBerat;
          _tinggiBadan = userProvider.tinggiBadan;
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfil() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSaving = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final result = await apiService.updateProfil(
        nama: _nama,
        beratBadan: _beratBadan,
        targetBerat: _targetBerat,
        tinggiBadan: _tinggiBadan,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        // Update provider
        final userProvider =
            Provider.of<UserProvider>(context, listen: false);
        await userProvider.loadUserData();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil berhasil disimpan'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal menyimpan profil'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
          ? Center(
              child: CircularProgressIndicator(color: Color(0xFFCF0F0F)))
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
                    Text('Nama Lengkap',
                        style: TextStyle(
                            color: Color(0xFFCF0F0F),
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: _nama,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama Anda',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Color(0xFFCF0F0F)),
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
                    Text('Berat Badan (kg)',
                        style: TextStyle(
                            color: Color(0xFFCF0F0F),
                            fontWeight: FontWeight.bold)),
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
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onSaved: (value) =>
                                _beratBadan = int.tryParse(value ?? '') ?? 70,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Isi berat badan';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Text('kg',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Target Berat
                    Text('Target Berat (kg)',
                        style: TextStyle(
                            color: Color(0xFFCF0F0F),
                            fontWeight: FontWeight.bold)),
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
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onSaved: (value) =>
                                _targetBerat = int.tryParse(value ?? '') ?? 60,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Isi target berat';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Text('kg',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Tinggi Badan
                    Text('Tinggi Badan (cm)',
                        style: TextStyle(
                            color: Color(0xFFCF0F0F),
                            fontWeight: FontWeight.bold)),
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
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onSaved: (value) =>
                                _tinggiBadan =
                                    int.tryParse(value ?? '') ?? 165,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Isi tinggi badan';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Text('cm',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),

                    SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveProfil,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFCF0F0F),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSaving
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              'SIMPAN PERUBAHAN',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}