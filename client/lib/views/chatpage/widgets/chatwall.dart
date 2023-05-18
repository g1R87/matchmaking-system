import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/model/chatmodel.dart';

class ChatWall extends StatefulWidget {
  const ChatWall({super.key, required this.chatModel});
  final ChatModel chatModel;

  @override
  State<ChatWall> createState() => _ChatWallState();
}

class _ChatWallState extends State<ChatWall> {
  TextEditingController msgInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: Text(
          widget.chatModel.name as String,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'delete') {
              } else {
                if (value == 'tdb') {}
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 'delete',
                  child: Text("Delete"),
                ),
                const PopupMenuItem(
                  value: 'tdb',
                  child: Text("TBD"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            ListView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width - 60,
                    child: Card(
                      margin:
                          const EdgeInsets.only(left: 2, right: 2, bottom: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        controller: msgInputController,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          contentPadding: const EdgeInsets.only(left: 18),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              CupertinoIcons.smiley,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7, bottom: 8),
                    child: CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 20,
                      child: IconButton(
                        onPressed: () {
                          msgInputController.text = "";
                        },
                        icon: const Icon(
                          CupertinoIcons.paperplane_fill,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
