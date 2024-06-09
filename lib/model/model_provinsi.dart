// To parse this JSON data, do
//
//     final modelProvinsi = modelProvinsiFromJson(jsonString);

import 'dart:convert';

ModelProvinsi modelProvinsiFromJson(String str) => ModelProvinsi.fromJson(json.decode(str));

String modelProvinsiToJson(ModelProvinsi data) => json.encode(data.toJson());

class ModelProvinsi {
  bool isSuccess;
  String message;
  List<DatumProvinsi> data;

  ModelProvinsi({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelProvinsi.fromJson(Map<String, dynamic> json) => ModelProvinsi(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<DatumProvinsi>.from(json["data"].map((x) => DatumProvinsi.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DatumProvinsi {
  String id;
  String namaProvinsi;

  DatumProvinsi({
    required this.id,
    required this.namaProvinsi,
  });

  factory DatumProvinsi.fromJson(Map<String, dynamic> json) => DatumProvinsi(
    id: json["id"],
    namaProvinsi: json["nama_provinsi"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_provinsi": namaProvinsi,
  };
}