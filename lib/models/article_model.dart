import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  String? idArtikel;
  String? judul;
  String? materi;
  String? imageUrl;
  Timestamp? date;

  ArticleModel({
    this.idArtikel,
    this.judul,
    this.materi,
    this.imageUrl,
    this.date,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
        idArtikel: json["idArtikel"],
        judul: json["judul"],
        materi: json["materi"],
        imageUrl: json["imageUrl"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "idArtikel": idArtikel,
        "judul": judul,
        "materi": materi,
        "imageUrl": imageUrl,
        "date": date,
      };
}
