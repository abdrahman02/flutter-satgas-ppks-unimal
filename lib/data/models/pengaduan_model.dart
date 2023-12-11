// To parse this JSON data, do
//
//     final pengaduansModel = pengaduansModelFromJson(jsonString);

import 'dart:convert';

PengaduansModel pengaduansModelFromJson(String str) =>
    PengaduansModel.fromJson(json.decode(str));

String pengaduansModelToJson(PengaduansModel data) =>
    json.encode(data.toJson());

class PengaduansModel {
  String message;
  List<Pengaduan> data;

  PengaduansModel({
    required this.message,
    required this.data,
  });

  factory PengaduansModel.fromJson(Map<String, dynamic> json) =>
      PengaduansModel(
        message: json["message"],
        data: List<Pengaduan>.from(
            json["Data"].map((x) => Pengaduan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Pengaduan {
  int id;
  String? prodi;
  String? fakultas;
  String memilikiDisabilitas;
  String? namaPelaku;
  String statusPelaku;
  String? nimNipNikPelaku;
  String? asalInstansiPelaku;
  String? kontakPelaku;
  String kronologiKejadian;
  String waktuKejadian;
  String bukti;
  String progres;
  String? responPetugas;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  Pengaduan({
    required this.id,
    required this.prodi,
    required this.fakultas,
    required this.memilikiDisabilitas,
    required this.namaPelaku,
    required this.statusPelaku,
    required this.nimNipNikPelaku,
    required this.asalInstansiPelaku,
    required this.kontakPelaku,
    required this.kronologiKejadian,
    required this.waktuKejadian,
    required this.bukti,
    required this.progres,
    required this.responPetugas,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pengaduan.fromJson(Map<String, dynamic> json) => Pengaduan(
        id: json["id"],
        prodi: json["prodi"],
        fakultas: json["fakultas"],
        memilikiDisabilitas: json["memiliki_disabilitas"],
        namaPelaku: json["nama_pelaku"],
        statusPelaku: json["status_pelaku"],
        nimNipNikPelaku: json["nim_nip_nik_pelaku"],
        asalInstansiPelaku: json["asal_instansi_pelaku"],
        kontakPelaku: json["kontak_pelaku"],
        kronologiKejadian: json["kronologi_kejadian"],
        waktuKejadian: json["waktu_kejadian"],
        bukti: json["bukti"],
        progres: json["progres"],
        responPetugas: json["respon_petugas"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prodi": prodi,
        "fakultas": fakultas,
        "memiliki_disabilitas": memilikiDisabilitas,
        "nama_pelaku": namaPelaku,
        "status_pelaku": statusPelaku,
        "nim_nip_nik_pelaku": nimNipNikPelaku,
        "asal_instansi_pelaku": asalInstansiPelaku,
        "kontak_pelaku": kontakPelaku,
        "kronologi_kejadian": kronologiKejadian,
        "waktu_kejadian": waktuKejadian,
        "bukti": bukti,
        "progres": progres,
        "respon_petugas": responPetugas,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
