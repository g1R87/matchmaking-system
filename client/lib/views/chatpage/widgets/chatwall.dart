import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_matchmaking_system/model/chatmodel.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/reply_card.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/sent_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../model/messagemodel.dart';

class ChatWall extends StatefulWidget {
  const ChatWall({super.key, required this.chatModel, required this.id});
  final ChatModel chatModel;
  final String id;

  @override
  State<ChatWall> createState() => _ChatWallState();
}

class _ChatWallState extends State<ChatWall> {
  TextEditingController msgInputController = TextEditingController();
  final appurl = dotenv.env["appurl"];

  late IO.Socket socket;
  List<MessageModel> messages = [];

  @override
  void initState() {
    connect();
    super.initState();
  }

  @override
  void dispose() {
    print('disposed');
    msgInputController.dispose();
    socket.disconnect();
    super.dispose();
  }

  void connect() async {
    socket = IO.io(
        appurl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    final id = await NetworkHandler.getValue("userId");
    socket.emit("signin", id);

    socket.onConnect((data) {
      socket.on(("message"), (msg) {
        // print(msg["message"]);
        setMessageReceiver(msg["message"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Icon(Icons.arrow_back_ios_outlined),
            ),
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
                  child: ListView.builder(
                      padding: EdgeInsets.only(
                          top: 50,
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom / 4.5),
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: ((context, index) {
                        int reverseIndex = messages.length - 1 - index;

                        if (messages[reverseIndex].type == "source") {
                          return SentMessageCard(
                            message: messages[reverseIndex].message as String,
                            time: messages[reverseIndex].time as String,
                          );
                        } else {
                          print("reply card triggered!!!");
                          return ReplyCard(
                            message: messages[reverseIndex].message as String,
                            time: messages[reverseIndex].time as String,
                          );
                        }
                      })),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 60,
                        child: Card(
                          margin: const EdgeInsets.only(
                              left: 2, right: 2, bottom: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: TextFormField(
                            onTap: () {
                              print(" Widget is mounted: $mounted");
                            },
                            scrollPadding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).viewInsets.bottom),
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
                              sendMessage(msgInputController.text,
                                  widget.chatModel.id as String);
                              msgInputController.clear();
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
        ),
      ],
    );
  }

  void setMessage(String type, String message) {
    if (type == 'received') {
      print("Received: message is set!!");
    }
    if (type == 'source') {
      print("Source: message is set!!");
    }
    MessageModel messageModel = MessageModel(
        type: type,
        message: message,
        time: DateTime.now().toString().substring(10, 16));
    print(messageModel.message);

    if (mounted) {
      setState(() {
        messages.add(messageModel);
        if (type == 'received') {
          print("After receive: length = ${messages.length}");
        }
        if (type == 'source') {
          print("After Source: length = ${messages.length}");
        }
      });
    }
  }

  void setMessageReceiver(String message) {
    print("Received: message is set!!");
    MessageModel messageModel = MessageModel(
        type: "received",
        message: message,
        time: DateTime.now().toString().substring(10, 16));
    print(messageModel.message);
    if (mounted) {
      setState(() {
        messages.add(messageModel);
        print("After receive: length = ${messages.length}");
      });
    }
  }

  void sendMessage(String message, String targetId) {
    setMessage("source", message);
    var messageJson = {
      "message": message,
      "sourceId": widget.id,
      "targetId": targetId
    };

    socket.emit('message', messageJson);
  }
}
