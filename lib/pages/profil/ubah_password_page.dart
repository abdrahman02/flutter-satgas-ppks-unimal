import 'package:flutter/material.dart';
import 'package:tga/data/datasources/profile_datasource.dart';
import 'package:tga/pages/main_layout.dart';

class UbahPasswordPage extends StatefulWidget {
  const UbahPasswordPage({super.key});

  @override
  State<UbahPasswordPage> createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  final formKey = GlobalKey<FormState>();

  final currentPasswordC = TextEditingController();
  final passwordC = TextEditingController();
  final konfirmasiPasswordC = TextEditingController();
  bool _isCurrentPVisible = false;
  bool _isPasswordVisible = false;
  bool _isPasswordCVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        title: Text(
          'Ubah Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: currentPasswordC,
                  obscureText: !_isCurrentPVisible,
                  decoration: InputDecoration(
                    hintText: 'Masukkan password lama',
                    hintStyle: TextStyle(color: Colors.black45),
                    labelText: 'Password Lama',
                    labelStyle: TextStyle(color: Colors.black45, fontSize: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.all(15),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isCurrentPVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isCurrentPVisible = !_isCurrentPVisible;
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordC,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Masukkan password baru',
                    hintStyle: TextStyle(color: Colors.black45),
                    labelText: 'Password Baru',
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: konfirmasiPasswordC,
                  obscureText: !_isPasswordCVisible,
                  decoration: InputDecoration(
                    hintText: 'Masukkan kembali password baru',
                    hintStyle: TextStyle(color: Colors.black45),
                    labelText: 'Konfirmasi Password Baru',
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
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    minimumSize: const Size(double.infinity, 50.0),
                  ),
                  child: const Text(
                    'Ubah',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );
                      final registrationResult =
                          await ProfileService().ubahPassword(
                        current_password: currentPasswordC.text,
                        password: passwordC.text,
                        confirmation_password: konfirmasiPasswordC.text,
                      );
                      _handleRegistrationResult(context, registrationResult);
                    }
                  },
                ),
              ],
            ),
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
    } else if(registrationResult["message"] == "Validasi Password") {
      final validationResponse = registrationResult["errors"];
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text('Kesalahan validasi'),
            content: Text('${validationResponse}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
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
    } else if (registrationResult["message"] == "Password berhasil diubah!") {
      final navigator = Navigator.of(context);
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => MainLayout(
            indexs: 2,
          ),
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
                '${registrationResult["message"]}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
  }
}
