import 'package:flutter/material.dart';
import 'package:tga/const.dart';
import 'package:tga/data/datasources/selesai_proses_remote_datasource.dart';
import 'package:tga/data/models/pengaduan_model.dart';
import 'package:tga/pages/SelesaiProses/detail_selesai_proses_page.dart';

class SelesaiProsesPage extends StatefulWidget {
  const SelesaiProsesPage({super.key});

  @override
  State<SelesaiProsesPage> createState() => _SelesaiProsesPageState();
}

class _SelesaiProsesPageState extends State<SelesaiProsesPage> {
  Future<List<Pengaduan>> _getSelesaiProsesData() async {
    try {
      return await SelesaiProsesRemoteDatasource().getSelesaiProses();
    } catch (e) {
      throw e;
    }
  }

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
        'Belum ada laporan yang selesai diproses!',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildText(
    String text,
    double fontSize,
    FontWeight fontWeight,
    Color color, {
    TextAlign textAlign = TextAlign.left,
    int? maxLines,
  }) {
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
          formatCreatedAt(createdAt),
          12,
          FontWeight.w100,
          Colors.white70,
        )
      ],
    );
  }

  Widget _buildListItem(Pengaduan data) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return DetailSelesaiProsesPage(
              pengaduan: data,
            );
          }),
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
                _buildText(
                  '${data.kronologiKejadian}',
                  14,
                  FontWeight.w100,
                  Colors.white70,
                  textAlign: TextAlign.justify,
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                _buildText('Respon Petugas', 18, FontWeight.w500, Colors.white),
                _buildText(
                  '${data.responPetugas}',
                  14,
                  FontWeight.w100,
                  Colors.white70,
                  textAlign: TextAlign.justify,
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                _buildDateRow('${data.createdAt}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pengaduan>>(
      future: _getSelesaiProsesData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else if (!snapshot.hasData || snapshot.data == null) {
          return _buildEmptyDataWidget();
        } else {
          final selesaiProsesData = snapshot.data!;
          return Scaffold(
            body: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemBuilder: (context, index) {
                final data = selesaiProsesData[index];
                return _buildListItem(data);
              },
              itemCount: selesaiProsesData.length,
            ),
          );
        }
      },
    );
  }
}
