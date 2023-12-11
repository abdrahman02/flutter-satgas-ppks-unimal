// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:tga/data/datasources/auth_datasource.dart';
import 'package:tga/pages/auth/login_page.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;
  const EmailVerificationPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _kodeVerificationController = TextEditingController();
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
              TextFormField(
                controller: _kodeVerificationController,
                decoration: InputDecoration(
                  hintText: 'Masukkan kode verfikasi',
                  hintStyle: const TextStyle(color: Colors.black45),
                  labelText: 'Kode Verifikasi',
                  labelStyle:
                      const TextStyle(color: Colors.black45, fontSize: 16),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Field tidak boleh kosong!';
                  }
                },
              ),
              SizedBox(height: 10.0),
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tidak mendapatkan email verifikasi? ',
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    child: Text(
                      'Kirim ulang!',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );
                      final registrationResult =
                          await AuthService().resendVerifikasi(widget.email);
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 4),
                          backgroundColor: Colors.lightBlue,
                          content: Row(
                            children: [
                              const Icon(Icons.task_alt, color: Colors.white),
                              const SizedBox(width: 5),
                              Text(
                                '${registrationResult["message"]}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),
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
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                    final registrationResult = await AuthService().verifikasi(
                        kodeVerifikasi: _kodeVerificationController.text);
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
    if (registrationResult["message"] == "Kode verifikasi tidak valid.") {
      print("VIEW");
      print(registrationResult);
      final navigator = Navigator.of(context);
      navigator.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.lightBlue,
          content: Row(
            children: [
              const Icon(Icons.task_alt, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                '${registrationResult["message"]}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    } else if (registrationResult["message"] == "Verifikasi email berhasil!") {
      final navigator = Navigator.of(context);
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => const LoginPage(),
        ),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.lightBlue,
          content: Row(
            children: [
              const Icon(Icons.task_alt, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                '${registrationResult["message"]}, Silahkan masuk',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
  }
}
