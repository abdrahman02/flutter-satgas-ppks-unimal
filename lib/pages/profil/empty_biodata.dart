import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tga/data/datasources/profile_datasource.dart';
import 'package:tga/pages/main_layout.dart';

class EmptyBiodataPage extends StatefulWidget {
  const EmptyBiodataPage({super.key});

  @override
  State<EmptyBiodataPage> createState() => _EmptyBiodataPageState();
}

class _EmptyBiodataPageState extends State<EmptyBiodataPage> {
  final formKey = GlobalKey<FormState>();
  final nimNipNikC = TextEditingController();
  final tempatLahirC = TextEditingController();
  final tanggalLahirC = TextEditingController();
  final noTelpC = TextEditingController();
  final alamatC = TextEditingController();
  String? selectedValueS;
  String? selectedValueJK;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      firstDate: DateTime(1800),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        tanggalLahirC.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

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
          'Ubah Biodata',
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
                      'Perbaharui Biodata Anda',
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
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                  ),
                  items: ["Laki - Laki", "Perempuan"],
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Pilih jenis kelamin anda",
                      hintStyle: TextStyle(color: Colors.black45),
                      labelText: "Jenis Kelamin",
                      labelStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                      ),
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
                  ),
                  onChanged: (value) {
                    selectedValueJK = value;
                  },
                  validator: (value) {
                    if (selectedValueJK == null) {
                      return 'Pilih salah satu opsi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nimNipNikC,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nim/nip/nik anda',
                    hintStyle: TextStyle(color: Colors.black45),
                    labelText: 'NIM/NIP/NIK',
                    labelStyle: TextStyle(color: Colors.black45, fontSize: 16),
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
                  controller: noTelpC,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nomor telepon/wa',
                    hintStyle: TextStyle(color: Colors.black45),
                    labelText: 'No Telp/WA',
                    labelStyle: TextStyle(color: Colors.black45, fontSize: 16),
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
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                  ),
                  items: [
                    "Mahasiswa/i",
                    "Dosen",
                    "Tenaga Kependidikan",
                    "Masyarakat Umum"
                  ],
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Pilih status anda sekarang",
                      hintStyle: TextStyle(color: Colors.black45),
                      labelText: "Status",
                      labelStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                      ),
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
                  ),
                  onChanged: (value) {
                    selectedValueS = value;
                  },
                  validator: (value) {
                    if (selectedValueS == null) {
                      return 'Pilih salah satu opsi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: alamatC,
                  maxLines: 3, // Teks panjang
                  decoration: InputDecoration(
                    hintText: 'Masukkan alamat anda',
                    hintStyle: TextStyle(color: Colors.black45),
                    labelText: 'Alamat',
                    labelStyle: TextStyle(color: Colors.black45, fontSize: 16),
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
                  controller: tempatLahirC,
                  decoration: InputDecoration(
                    hintText: 'Masukkan tempat lahir',
                    hintStyle: TextStyle(color: Colors.black45),
                    labelText: 'Tempat Lahir',
                    labelStyle: TextStyle(color: Colors.black45, fontSize: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: tanggalLahirC,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Masukkan tanggal lahir',
                    hintStyle: TextStyle(color: Colors.black45),
                    labelText: 'Tanggal Lahir',
                    labelStyle: TextStyle(color: Colors.black45, fontSize: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: Icon(Icons.calendar_today),
                      color: Colors.black54,
                    ),
                  ),
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
                      final data = await ProfileService().editBio(
                        nimNipNik: nimNipNikC.text,
                        status: selectedValueS,
                        tempatLahir: tempatLahirC.text,
                        tanggalLahir: tanggalLahirC.text,
                        jenisKelamin: selectedValueJK,
                        noTelp: noTelpC.text,
                        alamat: alamatC.text,
                      );
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );

                      if (data["message"] == 'Berhasil mengedit biodata') {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MainLayout(
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
                                  '${data["message"]}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
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
}
