import 'package:flutter/material.dart';

import 'package:tga/data/datasources/profile_datasource.dart';
import 'package:tga/pages/main_layout.dart';

class PengaturanAkunPage extends StatefulWidget {
  final Map dataUser;
  const PengaturanAkunPage({Key? key, required this.dataUser})
      : super(key: key);

  @override
  State<PengaturanAkunPage> createState() => _PengaturanAkunPageState();
}

class _PengaturanAkunPageState extends State<PengaturanAkunPage> {
  late Map dataUser;

  @override
  void initState() {
    super.initState();
    dataUser = widget.dataUser;
  }

  Widget build(BuildContext context) {
    final String name = dataUser["name"];
    final String username = dataUser["username"];
    final String email = dataUser["email"];
    final formKey = GlobalKey<FormState>();
    final nameC = TextEditingController(text: name);
    final usernameC = TextEditingController(text: username);
    final emailC = TextEditingController(text: email);

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        title: Text(
          'Ubah Akun',
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
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13),
                      ),
                    ),
                    child: Text(
                      'Perbaharui Akun Anda',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameC,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama lengkap',
                    hintStyle: TextStyle(color: Colors.black45),
                    labelText: 'Nama Lengkap',
                    labelStyle: TextStyle(color: Colors.black45, fontSize: 16),
                    prefixIcon: Icon(Icons.person),
                    prefix: Text(
                      '* ',
                      style: TextStyle(color: Colors.red),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field tidak boleh kosong!';
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: usernameC,
                  decoration: InputDecoration(
                    hintText: 'Masukkan username',
                    hintStyle: TextStyle(color: Colors.black45),
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.black45, fontSize: 16),
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field tidak boleh kosong!';
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailC,
                  decoration: InputDecoration(
                    hintText: 'Masukkan email',
                    hintStyle: TextStyle(color: Colors.black45),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black45, fontSize: 16),
                    prefixIcon: Icon(Icons.mail),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field tidak boleh kosong!';
                    }
                  },
                ),
                const SizedBox(height: 20),
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
                          await ProfileService().editUser(
                        name: nameC.text,
                        username: usernameC.text,
                        email: emailC.text,
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
    } else if (registrationResult["message"] == "Berhasil mengedit akun") {
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
