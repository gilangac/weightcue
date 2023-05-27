import 'package:cloud_firestore/cloud_firestore.dart';

class RiwayatDiagnosisModel {
  String? idDiagnosis;
  String? data;
  String? idUser;
  String? result;
  Timestamp? date;

  RiwayatDiagnosisModel({
    this.idDiagnosis,
    this.data,
    this.idUser,
    this.result,
    this.date,
  });

  factory RiwayatDiagnosisModel.fromJson(Map<String, dynamic> json) =>
      RiwayatDiagnosisModel(
        idDiagnosis: json["idDiagnosis"],
        data: json["data"],
        idUser: json["idUser"],
        result: json["result"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "idDiagnosis": idDiagnosis,
        "data": data,
        "idUser": idUser,
        "result": result,
        "date": date,
      };
}
