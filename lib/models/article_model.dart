import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  String? idArtikel;
  String? judul;
  String? materi;
  String? imageUrl;
  String? link;
  Timestamp? date;

  ArticleModel({
    this.idArtikel,
    this.judul,
    this.materi,
    this.imageUrl,
    this.link,
    this.date,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
        idArtikel: json["idArtikel"],
        judul: json["judul"],
        materi: json["materi"],
        imageUrl: json["imageUrl"],
        link: json["link"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "idArtikel": idArtikel,
        "judul": judul,
        "materi": materi,
        "imageUrl": imageUrl,
        "link": link,
        "date": date,
      };
}
