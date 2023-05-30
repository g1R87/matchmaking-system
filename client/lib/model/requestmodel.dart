import 'dart:typed_data';

class RequestModel {
  String? id;
  String? name;
  Uint8List? pfp;
  String? about;
  String? gender;
  String? ginterest;
  int? year;
  int? month;
  int? day;
  String? image;
  RequestModel(
      {this.id,
      this.name,
      this.pfp,
      this.about,
      this.gender,
      this.ginterest,
      this.day,
      this.year,
      this.month,
      this.image});
}
