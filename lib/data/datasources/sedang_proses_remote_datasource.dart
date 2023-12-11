import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:tga/const.dart';
import 'package:tga/data/datasources/profile_datasource.dart';
import 'package:tga/data/models/pengaduan_model.dart';
import 'package:tga/helpers/token.dart';

class SedangProsesRemoteDatasource {
  final dio = Dio(
    BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60), // 30 seconds
        receiveTimeout: const Duration(seconds: 60) // 30 seconds
        ),
  );
  final token = Token.userToken;

  Future<List<Pengaduan>> getSedangProses() async {
    try {
      print(token);
      final hasBiodata = await ProfileService().checkBiodata();
      if (!hasBiodata) {
        // Jika biodata belum diisi, kembalikan list kosong
        return [];
      }
      final response = await dio.get(
        "$baseUrl/dataonprocess",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data["Data"];
        // final List<Pengaduan> puList = jsonData.cast<Pengaduan>().toList();
        final puList =
            jsonData.map((data) => Pengaduan.fromJson(data)).toList();
        return puList;
      } else {
        throw Exception('Failed to load data');
      }
    } on DioException catch (e) {
      print(e.response);
      print('Error: $e');
      return (e.response!.data);
    }
  }

  Future store({
    String? prodi,
    String? fakultas,
    required String memilikiDisabilitas,
    String? namaPelaku,
    required String statusPelaku,
    String? nimNipNikPelaku,
    String? asalInstansiPelaku,
    String? kontakPelaku,
    required String kronologiKejadian,
    required String waktuKejadian,
    required File bukti,
  }) async {
    print(bukti);
    final data = {
      if (prodi != null) 'prodi': prodi,
      if (fakultas != null) 'fakultas': fakultas,
      'memiliki_disabilitas': memilikiDisabilitas,
      if (namaPelaku != null) 'nama_pelaku': namaPelaku,
      'status_pelaku': statusPelaku,
      if (nimNipNikPelaku != null) 'nim_nip_nik_pelaku': nimNipNikPelaku,
      if (asalInstansiPelaku != null)
        'asal_instansi_pelaku': asalInstansiPelaku,
      if (kontakPelaku != null) 'kontak_pelaku': kontakPelaku,
      'kronologi_kejadian': kronologiKejadian,
      'waktu_kejadian': waktuKejadian,
    };
    FormData formData = FormData.fromMap(data);

    if (bukti != null) {
      formData.files.add(
        MapEntry(
            'bukti',
            await MultipartFile.fromFile(
              bukti.path,
              filename: bukti.path.split('/').last,
            )),
      );
    }

    try {
      print(token);
      Response response = await dio.post(
        "$baseUrl/laporan",
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data["message"]);
        return response.data;
      }
    } on DioException catch (error) {
      print('Error: $error');
      print(error.response!.data);
    }
  }
}
