import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/chatlist.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: const Text(
          "Inbox",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: const ChatList(),
    );
  }
}
