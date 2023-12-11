import 'package:flutter/material.dart';
import 'package:tga/data/datasources/auth_datasource.dart';
import 'package:tga/data/datasources/profile_datasource.dart';
import 'package:tga/helpers/token.dart';
import 'package:tga/pages/auth/login_page.dart';
import 'package:tga/pages/profil/biodata_page.dart';
import 'package:tga/pages/profil/empty_biodata.dart';
import 'package:tga/pages/profil/pengaturan_akun_page.dart';
import 'package:tga/pages/profil/ubah_password_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(error) {
    return Center(
      child: Text('Terjadi kesalahan: ${error.toString()}'),
    );
  }

  Widget _buildEmptyDataWidget() {
    return Center(
      child: Text(
        'Gagal mengambil informasi profil!',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ProfileService().getUser(),
      builder: (context, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (s.hasError) {
          return _buildErrorWidget(s.error);
        } else if (!s.hasData || s.data == null) {
          return _buildEmptyDataWidget();
        } else {
          final profileData = s.data!;
          return Container(
            margin: const EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: 15,
            ),
            padding: const EdgeInsets.only(
              top: 15,
              left: 10,
              right: 10,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                AssetImage('assets/images/default-profile.jpg'),
                          ),
                          borderRadius: BorderRadius.circular(360),
                          border: Border.all(
                            color: const Color.fromARGB(68, 0, 0, 0),
                            width: 1,
                          ),
                        ),
                      ),
                      // Positioned(
                      //   bottom: 0,
                      //   right: 0,
                      //   child: InkWell(
                      //     onTap: () async {},
                      //     child: Container(
                      //       width: 30,
                      //       height: 30,
                      //       padding: const EdgeInsets.all(5),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(360),
                      //         color: Colors.green,
                      //       ),
                      //       child: const Icon(
                      //         Icons.camera_alt,
                      //         color: Colors.white,
                      //         size: 20,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    profileData["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                // const SizedBox(height: 5),
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      // "Disini letak username",
                      profileData["username"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 5),
                Center(
                  child: Text(
                    // "Disini letak email",
                    profileData["email"],
                    style: const TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 16),
                          Text(
                            "Pengaturan Akun",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right_outlined),
                    ],
                  ),
                  onTap: () async {
                    final data = await ProfileService().getUser();
                    if (data != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PengaturanAkunPage(dataUser: data);
                          },
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock),
                          SizedBox(width: 16),
                          Text(
                            "Ubah Password",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right_outlined),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UbahPasswordPage();
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 10),
                          Text(
                            "Biodata",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right_outlined),
                    ],
                  ),
                  onTap: () async {
                    final data = await ProfileService().getBio();
                    print("VIEW");
                    print(data);
                    if (data["message"] == "Berhasil mengambil data biodata") {
                      final biodata = data["bioUser"];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BiodataPage(biodata: biodata);
                          },
                        ),
                      );
                    } else if (data["message"] == "Biodata tidak ditemukan") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EmptyBiodataPage();
                          },
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  child: const Text(
                    "Keluar",
                    style: TextStyle(color: Colors.red),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    final data = await AuthService().logout();
                    if (data["message"] ==
                        "Berhasil logout dan menghapus token") {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginPage();
                          },
                        ),
                        (route) => false,
                      );
                    } else {
                      throw Error();
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
