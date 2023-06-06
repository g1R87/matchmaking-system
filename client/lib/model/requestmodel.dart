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
  dynamic image;
  dynamic image2;
  dynamic image3;
  List<dynamic>? interest;
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
      this.image,
      this.image2,
      this.image3,
      this.interest});
}
