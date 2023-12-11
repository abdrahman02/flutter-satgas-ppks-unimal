import 'package:flutter/material.dart';

import 'package:tga/data/models/pengaduan_model.dart';
import 'package:tga/pages/SedangProses/edit_sedang_proses_page.dart';

class DetailSedangProsesPage extends StatefulWidget {
  final Pengaduan pengaduan;

  const DetailSedangProsesPage({Key? key, required this.pengaduan})
      : super(key: key);

  @override
  _DetailSedangProsesPageState createState() => _DetailSedangProsesPageState();
}

class _DetailSedangProsesPageState extends State<DetailSedangProsesPage> {
  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTextInfo(String label, String value) {
    return Text(
      '$label: $value',
      style: TextStyle(
        color: Colors.black87,
        fontSize: 14,
      ),
    );
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
          'Detail Laporan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
              width: 3.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              _buildSectionTitle('INFORMASI PELAPOR'),
              SizedBox(height: 5),
              _buildTextInfo(
                  'Prodi', widget.pengaduan.prodi ?? 'Tidak ada informasi'),
              _buildTextInfo('Fakultas',
                  widget.pengaduan.fakultas ?? 'Tidak ada informasi'),
              _buildTextInfo(
                  'Memiliki Disabilitas', widget.pengaduan.memilikiDisabilitas),
              SizedBox(height: 16),
              _buildSectionTitle('INFORMASI PELAKU'),
              _buildTextInfo('Nama Pelaku',
                  widget.pengaduan.namaPelaku ?? 'Tidak ada informasi'),
              _buildTextInfo('Status Pelaku', widget.pengaduan.statusPelaku),
              _buildTextInfo('NIM/NIP/NIK',
                  widget.pengaduan.nimNipNikPelaku ?? 'Tidak ada informasi'),
              _buildTextInfo('Asal Instansi',
                  widget.pengaduan.asalInstansiPelaku ?? 'Tidak ada informasi'),
              _buildTextInfo('Kontak Pelaku',
                  widget.pengaduan.kontakPelaku ?? 'Tidak ada informasi'),
              SizedBox(height: 16),
              _buildSectionTitle('INFORMASI KEJADIAN'),
              _buildTextInfo(
                  'Kronologi Kejadian', widget.pengaduan.kronologiKejadian),
              _buildTextInfo('Waktu Kejadian', widget.pengaduan.waktuKejadian),
              _buildTextInfo('Bukti', widget.pengaduan.bukti),
              SizedBox(height: 16),
              _buildSectionTitle('RESPON PETUGAS'),
              _buildTextInfo('Respon',
                  widget.pengaduan.responPetugas ?? 'Petugas belum merespon'),
            ],
          ),
        ),
      ),
    );
  }
}
