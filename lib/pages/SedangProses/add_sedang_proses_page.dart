import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:tga/data/datasources/sedang_proses_remote_datasource.dart';
import 'package:tga/pages/SedangProses/sedang_proses_page.dart';
import 'package:tga/pages/main_layout.dart';

class AddSedangProsesPage extends StatefulWidget {
  const AddSedangProsesPage({super.key});

  @override
  State<AddSedangProsesPage> createState() => _AddSedangProsesPageState();
}

class _AddSedangProsesPageState extends State<AddSedangProsesPage> {
  final _formKey = GlobalKey<FormState>();
  final prodiController = TextEditingController();
  final fakultasController = TextEditingController();
  final namaPelakuController = TextEditingController();
  final statusPelakuController = TextEditingController();
  final nimNipNikPelakuController = TextEditingController();
  final asalInstansiPelakuController = TextEditingController();
  final kontakPelakuController = TextEditingController();
  final kronologiKejadianController = TextEditingController();

  String? selectedValueMD;
  String? selectedValueS;

  final waktuKejadianController = TextEditingController();
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
        waktuKejadianController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  String _namaFile = "Tekan untuk upload file";
  File? selectedFile;
  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final selectedFileName = result.files.single.name; // Ambil nama file
      setState(() {
        selectedFile = File(result.files.single.path!);
        _namaFile =
            selectedFileName; // Perbarui _namaFile dengan nama file yang dipilih
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 9,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft:
                Radius.circular(20.0), // Atur border radius di kiri bawah
            bottomRight:
                Radius.circular(20.0), // Atur border radius di kanan bawah
          ),
        ),
        title: Text(
          'Kirim Laporan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(13),
                    topRight: Radius.circular(13),
                  ),
                ),
                child: Text(
                  'Sampaikan Laporan Anda',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'INFORMASI PELAPOR',
                          style: GoogleFonts.oswald(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: prodiController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan asal prodi',
                        hintStyle: TextStyle(color: Colors.black45),
                        labelText: 'Asal Prodi',
                        labelStyle:
                            TextStyle(color: Colors.black45, fontSize: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: fakultasController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan asal fakultas',
                        hintStyle: TextStyle(color: Colors.black45),
                        labelText: 'Asal Fakultas',
                        labelStyle:
                            TextStyle(color: Colors.black45, fontSize: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownSearch<String>(
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                      ),
                      items: ["Ya", "Tidak"],
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          hintText: "Apakah anda memiliki disabilitas",
                          hintStyle: TextStyle(color: Colors.black45),
                          labelText: "Memiliki Disabilitas?",
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
                        selectedValueMD = value;
                      },
                      validator: (value) {
                        if (selectedValueMD == null) {
                          return 'Pilih salah satu opsi'; // Pesan kesalahan jika tidak ada opsi yang dipilih.
                        }
                        return null; // Mengembalikan null jika input valid.
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'INFORMASI PELAKU',
                          style: GoogleFonts.oswald(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: namaPelakuController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nama pelaku',
                        hintStyle: TextStyle(color: Colors.black45),
                        labelText: 'Nama Pelaku',
                        labelStyle:
                            TextStyle(color: Colors.black45, fontSize: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nimNipNikPelakuController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nim/nip/nik pelaku',
                        hintStyle: TextStyle(color: Colors.black45),
                        labelText: 'NIM/NIP/NIK Pelaku',
                        labelStyle:
                            TextStyle(color: Colors.black45, fontSize: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: asalInstansiPelakuController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan asal instansi pelaku',
                        hintStyle: TextStyle(color: Colors.black45),
                        labelText: 'Instansi Pelaku',
                        labelStyle:
                            TextStyle(color: Colors.black45, fontSize: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: kontakPelakuController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan kontak pelaku',
                        hintStyle: TextStyle(color: Colors.black45),
                        labelText: 'Kontak Pelaku',
                        labelStyle:
                            TextStyle(color: Colors.black45, fontSize: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.edit_square,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'INFORMASI KEJADIAN',
                          style: GoogleFonts.oswald(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: kronologiKejadianController,
                      maxLines: 3, // Teks panjang
                      decoration: InputDecoration(
                        hintText: 'Masukkan kronologi kejadian',
                        hintStyle: TextStyle(color: Colors.black45),
                        labelText: 'Kronologi Kejadian',
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field tidak boleh kosong!';
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: waktuKejadianController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Masukkan waktu kejadian',
                        hintStyle: TextStyle(color: Colors.black45),
                        labelText: 'Waktu Kejadian',
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
                        suffixIcon: IconButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          icon: Icon(Icons.calendar_today),
                          color: Colors.black54,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field tidak boleh kosong!';
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickFile,
                      child: Container(
                        height: 47,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _namaFile.length > 20
                                  ? _namaFile.substring(0, 20) + '...'
                                  : _namaFile,
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 16),
                            ),
                            Icon(
                              Icons.upload,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  minimumSize: const Size(double.infinity, 50.0),
                ),
                child: const Text(
                  'Kirim',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final navigator = Navigator.of(context);

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                    if (selectedFile == null) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Anda harus memilih berkas terlebih dahulu'),
                        ),
                      );
                    } else {
                      try {
                        final data = await SedangProsesRemoteDatasource().store(
                          prodi: prodiController.text,
                          fakultas: fakultasController.text,
                          memilikiDisabilitas: selectedValueMD ?? '',
                          namaPelaku: namaPelakuController.text,
                          statusPelaku: selectedValueS ?? '',
                          // statusPelaku: statusPelakuController.text,
                          nimNipNikPelaku: nimNipNikPelakuController.text,
                          asalInstansiPelaku: asalInstansiPelakuController.text,
                          kontakPelaku: kontakPelakuController.text,
                          kronologiKejadian: kronologiKejadianController.text,
                          waktuKejadian: waktuKejadianController.text,
                          bukti: selectedFile!,
                        );

                        if (data["message"] == 'Sukses menambahkan laporan!') {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => MainLayout(
                                indexs: 0,
                              ),
                            ),
                            (route) => false,
                          );
                        }

                        // navigator.pop();
                        // navigator.pop();
                      } catch (e) {
                        navigator.pop();
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              title: const Text('Gagal Kirim Laporan'),
                              content: const Text('Silahkan cek kembali!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Ok",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      }
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
