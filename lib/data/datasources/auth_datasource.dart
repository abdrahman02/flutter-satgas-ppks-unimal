import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tga/const.dart';
import 'package:tga/helpers/token.dart';

class AuthService {
  final dio = Dio(
    BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60), // 30 seconds
        receiveTimeout: const Duration(seconds: 60) // 30 seconds
        ),
  );
  Token tokenManager = Token();

  Future login({
    required String email_or_username,
    required String password,
  }) async {
    try {
      final Map jsonData = {
        "email_or_username": email_or_username,
        "password": password,
      };
      print("Kirim Data");
      Response response = await dio.post('$baseUrl/login', data: jsonData);
      print("Terima Data");
      print(response.data);
      if (response.statusCode == 200) {
        final Map<String, dynamic> resultData = response.data;
        final String newToken = resultData["token"];
        tokenManager.updateToken(newToken);
        return resultData;
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> resultData = response.data;
        return resultData;
      }
    } on DioException catch (e) {
      print(e);
      print(e.response!.data);
      final resultData = e.response!.data;
      return resultData;
      // return e.response!.data;
    }
  }

  Future register(
      {required String name,
      required String username,
      required String email,
      required String password,
      required String password_confirmation}) async {
    try {
      final Map jsonData = {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation,
      };
      Response response = await dio.post('$baseUrl/register', data: jsonData);
      print('RESPON');
      print(response);

      if (response.statusCode == 201) {
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

  Future verifikasi({required kodeVerifikasi}) async {
    try {
      final Map jsonData = {
        'verification_code': kodeVerifikasi,
      };
      print(jsonData);
      Response response = await dio
          .get('$baseUrl/verify-email/${kodeVerifikasi}', data: jsonData);

      print(response.data);

      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      final validationResponse = e.response!.data;
      if (validationResponse != null) {
        print('ValidationResponse');
        print(validationResponse);
        return validationResponse;
      } else {
        print('Error: $e');
        print(e.response);
        return e;
      }
    }
  }

  Future resendVerifikasi(String email) async {
    try {
      final response = await Dio().post(
        '$baseUrl/resend-verification-email',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        print('Kode verifikasi baru telah dikirim.');
        print(response.data);
        return response.data;
      } else {
        print('Gagal mengirim ulang kode verifikasi: ${response.data}');
      }
    } on DioException catch (error) {
      final validationResponse = error.response!.data;
      if (validationResponse != null) {
        print('ValidationResponse');
        print(validationResponse);
        return validationResponse;
      } else {
        print('Error: $error');
        print(error.response);
      }
    }
  }

  Future logout() async {
    try {
      final token = Token.userToken;
      Response result = await dio.post(
        '$baseUrl/logout',
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      handleSignOut();
      if (result.statusCode == 200) {
        tokenManager.clearToken();
        return result.data;
      } else {
        return result.data;
      }
    } on DioException catch (e) {
      print(e);
      throw "Internal Server Error";
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  Future handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      handleSignOut();
      print("Terima Akun");
      print(googleUser);
      if (googleUser == null) {
        handleSignOut();
        // User canceled the sign-in process
        return;
      }

      print("Ambil Data");
      final String id = googleUser.id;
      final String name = googleUser.displayName!;
      final String username = name + id;
      final String email = googleUser.email;
      final Map jsonData = {"name": name, "username": username, "email": email};
      print("Berhasil ambil data");
      print(jsonData);

      Response response = await dio.post(
        '$baseUrl/verify-email',
        data: jsonData,
      );

      print(response);
      if (response.statusCode == 200) {
        final String newToken = response.data["token"];
        tokenManager.updateToken(newToken);
        return response.data;
      }
    } on DioException catch (e) {
      print("ERROR Exception");
      print(e.response!.data);
      final notFoundResponse = e.response!.data;
      if (notFoundResponse != null) {
        print(notFoundResponse);
        return notFoundResponse;
      } else {
        print('Error: $e');
        print(e.response);
        return e;
      }
    }
  }

  Future registerGoogleSignIn(
      {required String name,
      required String username,
      required String email,
      required String password,
      required String password_confirmation}) async {
    try {
      print("masuk ke service");
      final Map jsonData = {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation,
      };
      print("mengirim data");
      Response response =
          await dio.post('$baseUrl/register-email-google', data: jsonData);
      print("udah kirim data");

      if (response.statusCode == 201) {
        final String newToken = response.data["token"];
        tokenManager.updateToken(newToken);
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

  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      print(error);
    }
  }
}
