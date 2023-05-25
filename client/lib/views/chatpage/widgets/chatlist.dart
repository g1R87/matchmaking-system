import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/model/chatmodel.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/custom_card.dart';
import 'dart:convert';

import 'package:online_matchmaking_system/services/network_handler.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool isLoading = true;
  String id = "";
  NetworkHandler networkHandler = NetworkHandler();
  List<ChatModel> chats = [
    // ChatModel(name: "Bodda", currentMessage: "I love flutter", time: "4:69"),
  ];
  List<dynamic> decodedImage = [];
  @override
  void initState() {
    // TODO: implement initState
    fetchChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: isLoading,
        replacement: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) => CustomCard(
            chatModel: chats[index],
            id: id,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void fetchChat() async {
    final response = await networkHandler.getData("/user/fetchchat");
    final userId = await NetworkHandler.getValue("userId");
    final fetchedUsers = await jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (!mounted) {
        return;
      }
      setState(() {
        id = userId as String;
        for (int i = 0; i < fetchedUsers.length; i++) {
          chats.add(ChatModel(
              id: fetchedUsers[i]["_id"],
              name: fetchedUsers[i]["first_name"],
              currentMessage: "input message here",
              time: "4:49",
              pfp: fetchedUsers[i]["pfp"] != null
                  ? base64Decode(fetchedUsers[i]["pfp"]["data"])
                  : null));
          decodedImage.add(fetchedUsers[i]["pfp"] != null
              ? base64Decode(fetchedUsers[i]["pfp"]["data"])
              : null);
        }

        isLoading = false;
      });
    } else {
      print("retry");
    }
  }
}
