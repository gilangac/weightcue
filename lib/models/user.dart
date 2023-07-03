import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? idUser;
  String? name;
  String? email;
  String? photo;
  int? type;
  Timestamp? date;

  UserModel({
    this.idUser,
    this.name,
    this.email,
    this.photo,
    this.type,
    this.date,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        idUser: json["idUser"],
        name: json["name"],
        email: json["email"],
        photo: json["photo"],
        type: json["type"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "idUser": idUser,
        "name": name,
        "email": email,
        "photo": photo,
        "type": type,
        "date": date,
      };
}
