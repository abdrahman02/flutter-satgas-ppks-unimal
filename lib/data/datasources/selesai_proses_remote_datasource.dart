import 'package:dio/dio.dart';
import 'package:tga/const.dart';
import 'package:tga/data/models/pengaduan_model.dart';
import 'package:tga/helpers/token.dart';

class SelesaiProsesRemoteDatasource {
  final dio = Dio(
    BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<List<Pengaduan>> getSelesaiProses() async {
    try {
      final token = Token.userToken;
      print(token);
      final response = await dio.get(
        "$baseUrl/dataselesai",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data["Data"];
        return jsonData.map((data) => Pengaduan.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
