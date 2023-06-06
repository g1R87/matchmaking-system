import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_matchmaking_system/model/chatmodel.dart';
import 'package:online_matchmaking_system/model/requestmodel.dart';
import 'package:online_matchmaking_system/services/models/keypair.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/services/rsa.dart';
import 'package:online_matchmaking_system/utils/api.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/reply_card.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/sent_card.dart';
import 'package:online_matchmaking_system/views/profile/profile.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:online_matchmaking_system/services/models/privatekey.dart';
import 'package:online_matchmaking_system/services/models/publickey.dart';

import '../../../model/messagemodel.dart';

class ChatWall extends StatefulWidget {
  const ChatWall(
      {super.key,
      required this.chatModel,
      required this.id,
      required this.requestModel});
  final ChatModel chatModel;
  final String id;
  final RequestModel requestModel;

  @override
  State<ChatWall> createState() => _ChatWallState();
}

class _ChatWallState extends State<ChatWall> {
  TextEditingController msgInputController = TextEditingController();
  final appurl = Api.appurl;
  late PublicKey senderPubKey;
  late PublicKey receiverPubKey;
  late PrivateKey senderPriKey;
  late PrivateKey receiverPriKey;
  RSA rsa = RSA();

  late IO.Socket socket;
  List<MessageModel> messages = [];

  @override
  void initState() {
    final KeyPair keyPair = rsa.generateKeyPair();
    senderPriKey = keyPair.privateKey;
    senderPubKey = keyPair.publicKey;
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
    socket.emit("signin", {
      "sourceId": widget.id,
      "targetId": widget.chatModel.id,
      "pubkey1": senderPubKey.e,
      "pubkey2": senderPubKey.n,
    });
    socket.emit("getkey", {
      "sourceId": widget.id,
      "targetId": widget.chatModel.id,
      "pubkey1": senderPubKey.e,
      "pubkey2": senderPubKey.n,
    });

    socket.onConnect((data) {
      socket.on("key", (data) {
        print("data received!");
        print("the data is $data");
      });

      socket.on("history", (data) {
        for (var msg in data) {
          if (msg["from_userId"] == id) {
            setMessage("source", msg["message"], msg["createdAt"]);
          } else {
            setMessage("received", msg["message"], msg["createdAt"]);
          }
        }
      });

      socket.on(("message"), (msg) {
        // print(msg["message"]);
        final keyPair = rsa.generateKeyPair();
        final decryptedMessage =
            rsa.decrypt(msg["message"], keyPair.privateKey);
        setMessageReceiver(decryptedMessage);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.grey[50],
              statusBarBrightness: Brightness.dark,
            ),
            leading: InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Icon(Icons.arrow_back_ios_outlined),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.grey[50],
            elevation: 0,
            title: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProfilePage(
                    requestModel: widget.requestModel,
                  );
                }));
              },
              child: Text(
                widget.chatModel.name as String,
                style: const TextStyle(color: Colors.black),
              ),
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
                            time: messages[reverseIndex].time as String,
                            message: messages[reverseIndex].message as String,
                          );
                        } else {
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
                            onTap: () {},
                            scrollPadding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).viewInsets.bottom),
                            controller: msgInputController,
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

  void setMessage(String type, String message, [var time]) {
    MessageModel messageModel = MessageModel(
      type: type,
      message: message,
      time: time == null
          ? DateTime.now().toString().substring(11, 16)
          : time.toString().substring(11, 16),
    );

    if (mounted) {
      setState(() {
        messages.add(messageModel);
      });
    }
  }

  void setMessageReceiver(String message) {
    MessageModel messageModel = MessageModel(
        type: "received",
        message: message,
        time: DateTime.now().toString().substring(11, 16));
    if (mounted) {
      setState(() {
        messages.add(messageModel);
      });
    }
  }

  void sendMessage(String message, String targetId) {
    final keyPair = rsa.generateKeyPair();

    setMessage("source", message);
    final encryptedMessage = rsa.encrypt(message, keyPair.publicKey);
    var messageJson = {
      "message": encryptedMessage,
      "sourceId": widget.id,
      "targetId": targetId
    };

    socket.emit('message', messageJson);
  }
}
