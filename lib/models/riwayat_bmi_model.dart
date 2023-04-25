import 'package:cloud_firestore/cloud_firestore.dart';

class RiwayatBmiModel {
  String? idBmi;
  String? bmi;
  String? idUser;
  String? keterangan;
  String? gender;
  Timestamp? date;

  RiwayatBmiModel({
    this.idBmi,
    this.bmi,
    this.idUser,
    this.keterangan,
    this.gender,
    this.date,
  });

  factory RiwayatBmiModel.fromJson(Map<String, dynamic> json) =>
      RiwayatBmiModel(
        idBmi: json["idBmi"],
        bmi: json["bmi"],
        idUser: json["idUser"],
        keterangan: json["keterangan"],
        gender: json["gender"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "idBmi": idBmi,
        "bmi": bmi,
        "idUser": idUser,
        "keterangan": keterangan,
        "gender": gender,
        "date": date,
      };
}
