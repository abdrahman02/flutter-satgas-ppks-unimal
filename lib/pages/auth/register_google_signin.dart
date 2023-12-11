import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tga/data/datasources/auth_datasource.dart';
import 'package:tga/pages/main_layout.dart';

class RegisterGoogleSignInPage extends StatefulWidget {
  final Map dataUser;
  const RegisterGoogleSignInPage({Key? key, required this.dataUser})
      : super(key: key);

  @override
  State<RegisterGoogleSignInPage> createState() =>
      _RegisterGoogleSignInPageState();
}

class _RegisterGoogleSignInPageState extends State<RegisterGoogleSignInPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordC = TextEditingController();
  final passwordConfirmationC = TextEditingController();
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
                child:
                    Image.asset('assets/images/logo-satgas-ppks-unimal.png'),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Silahkan Buat Password Untuk Melanjutkan',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: passwordC,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Masukkan password',
                  hintStyle: TextStyle(color: Colors.black45),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black45, fontSize: 16),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.all(15),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
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
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: passwordConfirmationC,
                obscureText: !_isPasswordCVisible,
                decoration: InputDecoration(
                  hintText: 'Masukkan kembali password',
                  hintStyle: TextStyle(color: Colors.black45),
                  labelText: 'Konfirmasi Password',
                  labelStyle: TextStyle(color: Colors.black45, fontSize: 16),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.all(15),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordCVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
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
                  'Masuk',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(
                            child: CircularProgressIndicator());
                      },
                    );
                    Map dataUser = widget.dataUser;
                    String name = dataUser["name"];
                    String username = dataUser["username"];
                    String email = dataUser["email"];
                    print(dataUser["email"]);
                    final registrationResult =
                        await AuthService().registerGoogleSignIn(
                      name: name,
                      username: username,
                      email: email,
                      password: passwordC.text,
                      password_confirmation: passwordConfirmationC.text,
                    );
                    print(registrationResult);
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
      Navigator.pop(context);
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
    } else if (registrationResult["message"] == "Registrasi berhasil!") {
      final navigator = Navigator.of(context);
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => MainLayout(
            indexs: 0,
          ),
        ),
        (route) => false,
      );
    }
  }
}
