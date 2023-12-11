import 'package:flutter/material.dart';
import 'package:tga/const.dart';
import 'package:tga/data/datasources/profile_datasource.dart';
import 'package:tga/data/datasources/sedang_proses_remote_datasource.dart';
import 'package:tga/data/models/pengaduan_model.dart';
import 'package:tga/pages/SedangProses/add_sedang_proses_page.dart';
import 'package:tga/pages/SedangProses/detail_sedang_proses_page.dart';

class SedangProsesPage extends StatefulWidget {
  const SedangProsesPage({super.key});

  @override
  State<SedangProsesPage> createState() => _SedangProsesPageState();
}

class _SedangProsesPageState extends State<SedangProsesPage> {
  bool hasBiodata = false;
  String biodataMessage = '';
  List<Pengaduan> _data = [];

  @override
  void initState() {
    super.initState();
    _loadBiodataStatus();
  }

  Future<void> _loadBiodataStatus() async {
    try {
      final biodataStatus = await ProfileService().checkBiodata();
      setState(() {
        hasBiodata = biodataStatus;
        biodataMessage = biodataStatus
            ? ''
            : 'Silakan isi biodata terlebih dahulu'; // Atur pesan biodata
      });

      if (hasBiodata) {
        _fetchSedangProsesData();
      }
    } catch (error) {
      print('Error loading biodata status: $error');
    }
  }

  Future<void> _fetchSedangProsesData() async {
    try {
      final sedangProsesData =
          await SedangProsesRemoteDatasource().getSedangProses();
      print('Response from getSedangProses: $sedangProsesData');
      if (sedangProsesData != null) {
        setState(() {
          _data = sedangProsesData;
        });
      }
    } catch (error) {
      print('Error fetching Sedang Proses data: $error');
    }
  }

  Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator());

  Widget _buildErrorWidget(error) => Center(
      child: Text('Terjadi kesalahan: ${error.toString()}',
          style: TextStyle(color: Colors.black87)));

  Widget _buildEmptyDataWidget() => Center(
      child: Text('Belum ada laporan yang diberikan!',
          style: TextStyle(color: Colors.black87)));

  Widget _buildText(
      String text, double fontSize, FontWeight fontWeight, Color color,
      {TextAlign textAlign = TextAlign.left, int? maxLines}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }

  Widget _buildDateRow(String createdAt) {
    return Row(
      children: [
        Icon(
          Icons.calendar_month_rounded,
          color: Colors.white70,
          size: 12,
        ),
        _buildText(
            formatCreatedAt(createdAt), 12, FontWeight.w100, Colors.white70),
      ],
    );
  }

  Widget _buildListItem(Pengaduan data) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailSedangProsesPage(pengaduan: data),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText('Waktu Kejadian', 18, FontWeight.w500, Colors.white),
                _buildText(formatWaktuKejadian('${data.waktuKejadian}'), 14,
                    FontWeight.w400, Colors.white70),
                SizedBox(height: 10),
                _buildText(
                    'Kronologi Kejadian', 18, FontWeight.w500, Colors.white),
                _buildText('${data.kronologiKejadian}', 14, FontWeight.w100,
                    Colors.white70,
                    textAlign: TextAlign.justify, maxLines: 3),
                SizedBox(height: 10),
                _buildText('Respon Petugas', 18, FontWeight.w500, Colors.white),
                _buildText('${data.responPetugas}', 14, FontWeight.w100,
                    Colors.white70,
                    textAlign: TextAlign.justify, maxLines: 3),
                SizedBox(height: 10),
                _buildDateRow('${data.createdAt}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: hasBiodata
          ? _data.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  itemBuilder: (context, index) {
                    final data = _data[index];
                    return _buildListItem(data);
                  },
                  itemCount: _data.length,
                )
              : _buildEmptyDataWidget()
          : Center(
              child: Text(
                biodataMessage,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
      floatingActionButton: hasBiodata
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddSedangProsesPage()),
                ).then((value) {
                  refreshData();
                });
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
