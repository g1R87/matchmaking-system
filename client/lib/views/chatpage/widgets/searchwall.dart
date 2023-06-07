import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_matchmaking_system/model/requestmodel.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/utils/api.dart';
import 'package:online_matchmaking_system/views/bottomNavBar/bottomnavbar.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/reply_card.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/sent_card.dart';
import 'package:online_matchmaking_system/model/chatmodel.dart';
import 'package:online_matchmaking_system/views/profile/profile.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../model/messagemodel.dart';

class SearchWall extends StatefulWidget {
  final List? interest;
  final String id;
  const SearchWall({
    super.key,
    required this.interest,
    required this.id,
  });

  @override
  State<SearchWall> createState() => _SearchWallState();
}

class _SearchWallState extends State<SearchWall> {
  TextEditingController msgInputController = TextEditingController();
  final appurl = Api.appurl;
  bool isLoading = true;
  bool notFound = false;
  NetworkHandler networkHandler = NetworkHandler();

  final RequestModel requestModel = RequestModel();

  late IO.Socket socket;
  List<MessageModel> messages = [];
  late ChatModel chatModel = ChatModel(
    name: "",
    id: "",
  );

  String tid = '';

  @override
  void initState() {
    connect();
    super.initState();
  }

  @override
  void dispose() {
    msgInputController.dispose();
    socket.disconnect();
    chatModel;
    widget.interest;
    super.dispose();
  }

  void connect() {
    socket = IO.io(
        appurl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    socket.emit("login", {"sourceId": widget.id, "list": widget.interest});
    socket.emit("search", {"sourceId": widget.id, "list": widget.interest});

    socket.onConnect((data) {
      socket.on("notfound", (data) {
        if (!mounted) return;
        setState(() {
          notFound = true;
        });
      });
      socket.on("found", (user) {
        if (!mounted) return;
        setState(() {
          requestModel.id = user["_id"];
          requestModel.about = user["about"];
          requestModel.name = user["first_name"] ?? "";
          requestModel.gender = user["gender_identity"];
          requestModel.ginterest = user["gender_interest"];
          requestModel.image = user["pfp"]["data"] ?? "";
          requestModel.image2 = user["url2"] ?? "";
          requestModel.image3 = user["url3"] ?? "";
          requestModel.year = user["dob_year"];
          requestModel.month = user["dob_month"];
          requestModel.day = user["dob_day"];
          requestModel.interest = user["interest"];
          chatModel.id = user["_id"];
          chatModel.name = user["first_name"];
          isLoading = false;
        });
      });
      socket.on(("chat"), (msg) {
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
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.grey[50],
              statusBarBrightness: Brightness.dark,
            ),
            leading: InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return const MainPage(
                    index: 2,
                  );
                }));
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
                    requestModel: requestModel,
                  );
                }));
              },
              child: Text(
                chatModel.name as String,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: sendRequest,
                  icon: const Icon(
                    CupertinoIcons.checkmark_alt_circle,
                    color: Colors.green,
                    size: 30,
                  )),
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
            child: Visibility(
              visible: isLoading,
              replacement: Stack(
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
                                    chatModel.id as String);
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
              child: const Center(
                child: CircularProgressIndicator(),
                // ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: const Color(0xff2B2C43),
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(35))),
                //     onPressed: () {
                //       socket.emit("search",
                //           {"sourceId": widget.id, "list": widget.interest});
                //     },
                //     child: const Text(
                //       "Find",
                //       style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 20,
                //           fontWeight: FontWeight.w500),
                //     ),
                //     ),
              ),
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

    socket.emit('chat', messageJson);
  }

  Future<void> sendRequest() async {
    final reqId = requestModel.id;
    final response = await networkHandler.vote("/user/voteup?id=$reqId");
    response.statusCode == 200 ? print("success") : print("fail");
  }
}
