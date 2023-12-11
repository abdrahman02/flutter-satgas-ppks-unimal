import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tga/data/datasources/auth_datasource.dart';
import 'package:tga/helpers/token.dart';
import 'package:tga/pages/auth/register_google_signin.dart';
import 'package:tga/pages/auth/register_page.dart';
import 'package:tga/pages/main_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final key = GlobalKey<FormState>();
  final email_or_usernameC = TextEditingController();
  final passwordC = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 120, horizontal: 20),
        child: Form(
          key: key,
          child: Column(
            children: [
              _buildLogo(),
              SizedBox(height: 20.0),
              _buildTextField(
                controller: email_or_usernameC,
                labelText: 'Username/Email',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Field tidak boleh kosong!';
                  }
                },
              ),
              SizedBox(height: 10.0),
              _buildPasswordTextField(),
              SizedBox(height: 20.0),
              _buildLoginButton(),
              SizedBox(height: 10.0),
              _buildRegisterLink(),
              SizedBox(height: 10.0),
              _buildDividerText(),
              SizedBox(height: 10.0),
              _buildGoogleLoginButton(),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 200.0,
      child: Image.asset('assets/images/logo-satgas-ppks-unimal.png'),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Masukkan $labelText',
        hintStyle: TextStyle(color: Colors.black45),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black45, fontSize: 16),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.all(15),
        prefixIcon: Icon(prefixIcon),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
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

  Widget _buildLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        minimumSize: Size(double.infinity, 50.0),
      ),
      child: Text(
        'Masuk',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: _login,
    );
  }

  void _login() async {
    if (key.currentState!.validate()) {
      final navigator = Navigator.of(context);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        final data = await AuthService().login(
          email_or_username: email_or_usernameC.text,
          password: passwordC.text,
        );

        if (data["message"] == "Berhasil login!") {
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (ctx) => MainLayout(
                indexs: 0,
              ),
            ),
            (route) => false,
          );
        } else if (data["message"] == "Email/username ataupun password salah") {
          navigator.pop();
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                title: Text('Login Gagal'),
                content: Text('Email/username ataupun password salah'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        navigator.pop();
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Text('Login Gagal'),
              content: Text('Email/username ataupun password salah'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Belum memiliki akun? ',
          style: TextStyle(color: Colors.black54),
        ),
        GestureDetector(
          child: Text(
            'Daftar sekarang!',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return RegisterPage();
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDividerText() {
    return Text(
      "atau",
      style: TextStyle(
        color: Colors.black54,
        fontSize: 16,
      ),
    );
  }

  Widget _buildGoogleLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        maximumSize: Size.fromWidth(300),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.google,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Text(
            "Masuk Menggunakan Google",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
      onPressed: () async {
        final navigator = Navigator.of(context);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        final data = await AuthService().handleGoogleSignIn();

        print(data);
        // print("VIEW");
        // print(data["success"]);
        if (data != null) {
          if (data["success"] == false) {
            navigator.pop();
            final result = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RegisterGoogleSignInPage(dataUser: data["dataUser"]),
              ),
            );
          } else if (data["success"] == true) {
            navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (ctx) => MainLayout(
                  indexs: 0,
                ),
              ),
              (route) => false,
            );
          }
        } else if (data == null) {
          navigator.pop();
        }
      },
    );
  }
}
