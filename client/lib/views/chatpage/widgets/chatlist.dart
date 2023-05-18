import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/model/chatmodel.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/custom_card.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<ChatModel> chats = [
    ChatModel(name: "Bodda", currentMessage: "I love flutter", time: "4:69"),
    ChatModel(name: "Bome", currentMessage: "I love Bananana", time: "5:69"),
    ChatModel(name: "Danuj", currentMessage: "I love Linux", time: "6:69"),
    ChatModel(name: "G-Man", currentMessage: "Rise and shine", time: "9:69"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) => CustomCard(chatModel: chats[index]),
      ),
    );
  }
}
