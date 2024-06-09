// To parse this JSON data, do
//
//     final modelRs = modelRsFromJson(jsonString);

import 'dart:convert';

ModelRs modelRsFromJson(String str) => ModelRs.fromJson(json.decode(str));

String modelRsToJson(ModelRs data) => json.encode(data.toJson());

class ModelRs {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelRs({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelRs.fromJson(Map<String, dynamic> json) => ModelRs(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String kabupatenId;
  String namaRs;
  String deskripsi;
  String gambar;
  String alamat;
  String noTelp;
  String lang;
  String long;

  Datum({
    required this.id,
    required this.kabupatenId,
    required this.namaRs,
    required this.deskripsi,
    required this.gambar,
    required this.alamat,
    required this.noTelp,
    required this.lang,
    required this.long,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    kabupatenId: json["kabupaten_id"],
    namaRs: json["nama_rs"],
    deskripsi: json["deskripsi"],
    gambar: json["gambar"],
    alamat: json["alamat"],
    noTelp: json["no_telp"],
    lang: json["lang"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kabupaten_id": kabupatenId,
    "nama_rs": namaRs,
    "deskripsi": deskripsi,
    "gambar": gambar,
    "alamat": alamat,
    "no_telp": noTelp,
    "lang": lang,
    "long": long,
  };
}
