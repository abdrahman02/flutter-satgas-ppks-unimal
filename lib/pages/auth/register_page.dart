import 'package:flutter/material.dart';
import 'package:tga/data/datasources/auth_datasource.dart';
import 'package:tga/pages/auth/email_verification_page.dart';
import 'package:tga/pages/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isPasswordCVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 200.0,
                child: Image.asset('assets/images/logo-satgas-ppks-unimal.png'),
              ),
              const SizedBox(height: 20.0),
              _buildTextFormField(
                controller: _nameController,
                hintText: 'Masukkan nama lengkap',
                labelText: 'Nama Lengkap',
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 10.0),
              _buildTextFormField(
                controller: _usernameController,
                hintText: 'Masukkan username',
                labelText: 'Username',
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 10.0),
              _buildTextFormField(
                controller: _emailController,
                hintText: 'Masukkan alamat email',
                labelText: 'Email',
                prefixIcon: Icons.mail,
              ),
              const SizedBox(height: 10.0),
              _buildPasswordTextFormField(
                controller: _passwordController,
                hintText: 'Masukkan password',
                labelText: 'Password',
                prefixIcon: Icons.lock,
              ),
              const SizedBox(height: 10.0),
              _buildConfirmationPasswordTextFormField(
                controller: _passwordConfirmationController,
                hintText: 'Masukkan kembali password',
                labelText: 'Konfirmasi Password',
                prefixIcon: Icons.lock,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: const Size(double.infinity, 50.0),
                ),
                child: const Text(
                  'Daftar',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                    final registrationResult = await AuthService().register(
                      name: _nameController.text,
                      username: _usernameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      password_confirmation:
                          _passwordConfirmationController.text,
                    );
                    _handleRegistrationResult(context, registrationResult);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Refaktor builder TextFormField
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required IconData prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black45),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black45, fontSize: 16),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.all(15),
        prefixIcon: Icon(prefixIcon),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Field tidak boleh kosong!';
        }
      },
    );
  }

  // Refaktor builder TextFormField untuk password
  Widget _buildPasswordTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required IconData prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black45),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black45, fontSize: 16),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.all(15),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Field tidak boleh kosong!';
        }
      },
    );
  }

  // Refaktor builder TextFormField untuk password konfirmasi
  Widget _buildConfirmationPasswordTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required IconData prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordCVisible,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black45),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black45, fontSize: 16),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.all(15),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordCVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordCVisible = !_isPasswordCVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Field tidak boleh kosong!';
        }
      },
    );
  }

  // Mengelola hasil pendaftaran dan tampilkan dialog
  void _handleRegistrationResult(
      BuildContext context, dynamic registrationResult) {
    if (registrationResult["message"] == "Validasi gagal") {
      final validationResponse = registrationResult["errors"];
      final listValidationError = <String>[];
      validationResponse.forEach((key, value) {
        if (value is List<String>) {
          listValidationError.addAll(value);
        } else if (value is List) {
          listValidationError.addAll(value.map((e) => e.toString()));
        }
      });
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text('Kesalahan validasi'),
            content: SingleChildScrollView(
              child: Column(
                children: listValidationError
                    .map((error) => Text('- $error'))
                    .toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'OK',
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        },
      );
    } else if (registrationResult["message"] ==
        "Registrasi berhasil! Periksa email Anda untuk verifikasi.") {
      final navigator = Navigator.of(context);
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => EmailVerificationPage(
            email: _emailController.text,
          ),
        ),
        (route) => false,
      );
    }
  }
}
