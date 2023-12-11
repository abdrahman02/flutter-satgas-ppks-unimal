import 'package:flutter/material.dart';
import 'package:tga/pages/auth/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    nextPage();
    super.initState();
  }

  void nextPage() async {
    await Future.delayed(Duration(seconds: 3));

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo-satgas-ppks-unimal.png',
        ),
      ),
    );
  }
}
