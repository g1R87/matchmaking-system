import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;
  TextEditingController msgInputController = TextEditingController();
  final appurl = dotenv.env["appurl"];

  @override
  void initState() {
    socket = IO.io(
        appurl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const MessageItem(
                      sendByMe: false,
                    );
                  }),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black12,
              child: TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                cursorColor: Colors.black,
                controller: msgInputController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(
                          top: getDeviceWidth(context) * 0.005,
                          bottom: getDeviceWidth(context) * 0.005,
                          right: getDeviceHeight(context) * 0.003),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black26,
                      ),
                      child: IconButton(
                          onPressed: () {
                            sendMessage(msgInputController.text);
                            msgInputController.text = "";
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.black38,
                          )),
                    )),
              ),
            ),
          ),
        ],
      )),
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

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.sendByMe});

  final bool sendByMe;

  @override
  Widget build(BuildContext context) {
    Color blue = const Color(0xff0199FE);
    Color black = const Color(0xff191919);
    Color lightBlack = const Color(0xff3E4042);
    Color white = Colors.white;
    return Align(
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 3,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: sendByMe ? Colors.blueAccent : Colors.amberAccent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "hello",
              style: TextStyle(
                fontSize: 18,
                color: sendByMe ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "time",
              style: TextStyle(
                fontSize: 10,
                color:
                    (sendByMe ? Colors.white : Colors.black).withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
