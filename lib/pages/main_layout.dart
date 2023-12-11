import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tga/data/datasources/auth_datasource.dart';
import 'package:tga/helpers/token.dart';
import 'package:tga/pages/SedangProses/sedang_proses_page.dart';
import 'package:tga/pages/SelesaiProses/selesai_proses_page.dart';
import 'package:tga/pages/auth/login_page.dart';
import 'package:tga/pages/profil/profil_page.dart';

class MainLayout extends StatefulWidget {
  MainLayout({
    Key? key,
    required this.indexs,
  }) : super(key: key);
  var indexs;
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  List<Widget> listPage = [
    SedangProsesPage(),
    SelesaiProsesPage(),
    ProfilPage(),
  ];

  List<Widget> listAppBar = [
    Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'PENGADUAN',
            style: GoogleFonts.oswald(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Sedang Diproses',
            style: GoogleFonts.oswald(
              fontSize: 18,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
    Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'PENGADUAN',
            style: GoogleFonts.oswald(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Selesai Diproses',
            style: GoogleFonts.oswald(
              fontSize: 18,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
    Center(
      child: Text(
        'Profil',
        style: GoogleFonts.oswald(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 9,
        backgroundColor: Colors.green,
        toolbarHeight: 100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft:
                Radius.circular(20.0), // Atur border radius di kiri bawah
            bottomRight:
                Radius.circular(20.0), // Atur border radius di kanan bawah
          ),
        ),
        title: listAppBar[widget.indexs],
        
        elevation: 2,
      ),
      body: SafeArea(
        child: listPage[widget.indexs],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color.fromARGB(178, 255, 255, 255),
          elevation: 20,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.schedule_outlined,
                size: 27,
              ),
              activeIcon: Icon(
                Icons.schedule,
                size: 27,
              ),
              label: 'Sedang Proses',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle_outline,
                size: 27,
              ),
              activeIcon: Icon(
                Icons.check_circle,
                size: 27,
              ),
              label: 'Selesai Proses',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
                size: 27,
              ),
              activeIcon: Icon(
                Icons.account_circle,
                size: 27,
              ),
              label: 'Profil',
            ),
          ],
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black,
          currentIndex: widget.indexs,
          onTap: (i) {
            setState(() {
              widget.indexs = i;
            });
          },
        ),
      ),
    );
  }
}
