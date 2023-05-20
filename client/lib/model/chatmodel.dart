import 'dart:typed_data';

class ChatModel {
  String? id;
  String? name;
  String? time;
  String? currentMessage;
  Uint8List? pfp;
  ChatModel({this.id, this.name, this.time, this.currentMessage, this.pfp});
}
