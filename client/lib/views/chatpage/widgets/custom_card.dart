import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/chatwall.dart';

import '../../../model/chatmodel.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.chatModel});
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatWall(
                      chatModel: chatModel,
                    )));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 35,
              backgroundImage: (chatModel.pfp == null || chatModel.pfp!.isEmpty)
                  ? const AssetImage("images/pfp_default.jpg") as ImageProvider
                  : MemoryImage(base64Decode(chatModel.pfp as String)),
            ),
            title: Text(
              chatModel.name as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              chatModel.currentMessage as String,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
            trailing: Text(chatModel.time as String),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10, left: 80),
            child: Divider(
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
