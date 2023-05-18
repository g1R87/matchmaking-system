import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_matchmaking_system/model/chatmodel.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/reply_card.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/sent_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatWall extends StatefulWidget {
  const ChatWall({super.key, required this.chatModel});
  final ChatModel chatModel;

  @override
  State<ChatWall> createState() => _ChatWallState();
}

class _ChatWallState extends State<ChatWall> {
  TextEditingController msgInputController = TextEditingController();
  final appurl = dotenv.env["appurl"];

  late IO.Socket socket;

  @override
  void initState() {
    // TODO: implement initState
    connect();
    super.initState();
  }

  void connect() {
    socket = IO.io(
        appurl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
  }

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
            SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: ListView(
                shrinkWrap: true,
                children: const [
                  SendMessageCard(),
                  ReplyCard(),
                  SendMessageCard(),
                  ReplyCard(),
                  SendMessageCard(),
                  ReplyCard(),
                  SendMessageCard(),
                  ReplyCard(),
                  SendMessageCard(),
                  ReplyCard(),
                  SendMessageCard(),
                  ReplyCard(),
                  SendMessageCard(),
                  ReplyCard(),
                  SendMessageCard(),
                  ReplyCard(),
                  SendMessageCard(),
                  ReplyCard(),
                  SendMessageCard(),
                  ReplyCard(),
                  SendMessageCard(),
                  ReplyCard(),
                ],
              ),
            ),
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
                        onTap: () {
                          setState(() {});
                        },
                        scrollPadding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).viewInsets.bottom),
                        autofocus: true,
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
                          sendMessage(msgInputController.text);
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

  void sendMessage(String text) {
    var messageJson = {
      "message": text,
      "sender": socket.id,
    };

    socket.emit('message', messageJson);
  }
}
