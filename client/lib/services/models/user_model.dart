// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  String? id;
  String? userId;
  String? hashedPassword;
  String? firstName;
  int? dobDay;
  int? dobMonth;
  int? dobYear;
  bool? showGender;
  String? genderIdentity;
  String? genderInterest;
  String? email;
  String? url1;
  String? url2;
  String? about;
  List<Match>? matches;
  String? password;
  int? v;
  String? url;

  UserModel({
    this.id,
    this.userId,
    this.hashedPassword,
    this.firstName,
    this.dobDay,
    this.dobMonth,
    this.dobYear,
    this.showGender,
    this.genderIdentity,
    this.genderInterest,
    this.email,
    this.url1,
    this.url2,
    this.about,
    this.matches,
    this.password,
    this.v,
    this.url,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        userId: json["user_id"],
        hashedPassword: json["hashed_password"],
        firstName: json["first_name"],
        dobDay: json["dob_day"],
        dobMonth: json["dob_month"],
        dobYear: json["dob_year"],
        showGender: json["show_gender"],
        genderIdentity: json["gender_identity"],
        genderInterest: json["gender_interest"],
        email: json["email"],
        url1: json["url1"],
        url2: json["url2"],
        about: json["about"],
        matches: json["matches"] == null
            ? []
            : List<Match>.from(json["matches"]!.map((x) => Match.fromJson(x))),
        password: json["password"],
        v: json["__v"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "hashed_password": hashedPassword,
        "first_name": firstName,
        "dob_day": dobDay,
        "dob_month": dobMonth,
        "dob_year": dobYear,
        "show_gender": showGender,
        "gender_identity": genderIdentity,
        "gender_interest": genderInterest,
        "email": email,
        "url1": url1,
        "url2": url2,
        "about": about,
        "matches": matches == null
            ? []
            : List<dynamic>.from(matches!.map((x) => x.toJson())),
        "password": password,
        "__v": v,
        "url": url,
      };
}

class Match {
  String? userId;

  Match({
    this.userId,
  });

  factory Match.fromJson(Map<String, dynamic> json) => Match(
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
      };
}
