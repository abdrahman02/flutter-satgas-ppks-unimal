import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tga/const.dart';
import 'package:tga/helpers/token.dart';

class ProfileService {
  final dio = Dio(
    BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60), // 30 seconds
        receiveTimeout: const Duration(seconds: 60) // 30 seconds
        ),
  );
  final token = Token.userToken;

  Future getUser() async {
    try {
      print(token);
      final response = await dio.get(
        "$baseUrl/user",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      final data = response.data["user"];
      print(data);
      return data;
    } on DioException catch (e) {
      print('Error : $e');
      print(e.response);
      rethrow;
    }
  }

  Future editUser({
    required String name,
    required String username,
    required String email,
  }) async {
    try {
      print(token);
      final Map jsonData = {
        'name': name,
        'username': username,
        'email': email,
      };
      Response response = await dio.put(
        '$baseUrl/user/edit',
        data: jsonData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      print(response.data);
      if (response.statusCode == 200) {
        final Map<String, dynamic> resultData = response.data;
        return resultData;
      }
    } on DioException catch (e) {
      final validationResponse = e.response!.data;
      if (validationResponse != null) {
        print(validationResponse);
        return validationResponse;
      } else {
        print('Error: $e');
        print(e.response);
        return e;
      }
    }
  }

  Future ubahPassword({
    required String current_password,
    required String password,
    required String confirmation_password,
  }) async {
    try {
      print(token);
      final Map jsonData = {
        'current_password': current_password,
        'password': password,
        'confirmation_password': confirmation_password,
      };
      Response response = await dio.put(
        '$baseUrl/password/edit',
        data: jsonData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      print(response.data);
      if (response.statusCode == 200) {
        final Map<String, dynamic> resultData = response.data;
        return resultData;
      }
    } on DioException catch (e) {
      final validationResponse = e.response!.data;
      if (validationResponse != null) {
        print(validationResponse);
        return validationResponse;
      } else {
        print('Error: $e');
        print(e.response);
        return e;
      }
    }
  }

  Future<bool> checkBiodata() async {
    try {
      print('check biodata: $token');
      final response = await dio.get(
        "$baseUrl/check-bio",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      // Jika respons adalah 200, artinya biodata sudah diisi
      print(response.data["status"]);
      return response.data["status"];
    } on DioException catch (e) {
      print('Error: $e');
      print(e.response);
      return false; // Atau atur kembali ke false sesuai kebutuhan Anda
    }
  }

  Future getBio() async {
    try {
      print(token);
      final response = await dio.get(
        "$baseUrl/bio",
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      print(response.data);
      final data = response.data;
      print(data);
      return data;
    } on DioException catch (e) {
      print('Error : $e');
      print(e.response);
      return e.response!.data;
    }
  }

  Future editBio({
    required nimNipNik,
    required status,
    required tempatLahir,
    required tanggalLahir,
    required jenisKelamin,
    required noTelp,
    required alamat,
  }) async {
    try {
      final token = Token.userToken;
      final Map jsonData = {
        "nip_nim_nik": nimNipNik,
        "status": status,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "jenis_kelamin": jenisKelamin,
        "no_telepon": noTelp,
        "alamat": alamat
      };
      print(jsonData);
      Response result = await dio.put(
        '$baseUrl/bio/edit',
        data: jsonData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      print(result);

      return result.data;
    } on DioException catch (e) {
      print(e);
      print(e.response);
      throw "Internal Server Error";
    }
  }
}
