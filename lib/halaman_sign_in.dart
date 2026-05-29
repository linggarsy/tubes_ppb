import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_ppb/halaman_berat_badan.dart';
import 'package:tubes_ppb/halaman_sign_up.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(Duration(seconds: 1));
      
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('user_email');
      final savedPassword = prefs.getString('user_password');
      
      setState(() {
        _isLoading = false;
      });
      
      if (_emailController.text == savedEmail && _passwordController.text == savedPassword) {
        await prefs.setBool('is_logged_in', true);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login berhasil! Selamat datang kembali.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        final hasFilledData = prefs.containsKey('user_berat');
        
        if (hasFilledData) {
          Navigator.pushReplacementNamed(context, '/beranda');
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BeratBadanPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email atau password salah!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Sign In',
                  style: TextStyle(
                    color: Color(0xFFCF0F0F),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Masuk ke akun Anda untuk melanjutkan',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 40),
                
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email
                      Text(
                        'Email',
                        style: TextStyle(
                          color: Color(0xFFCF0F0F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'email@gmail.com',
                          prefixIcon: Icon(Icons.email_outlined, color: Color(0xFFCF0F0F)),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Masukkan email yang valid';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Password
                      Text(
                        'Password',
                        style: TextStyle(
                          color: Color(0xFFCF0F0F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'enter your password',
                          prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFCF0F0F)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFCF0F0F),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Color(0xFFCF0F0F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}