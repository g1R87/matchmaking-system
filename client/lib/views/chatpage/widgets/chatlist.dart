import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/model/chatmodel.dart';
import 'package:online_matchmaking_system/model/requestmodel.dart';
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
  List<RequestModel> reqModel = [];
  List<dynamic> decodedImage = [];
  Offset _tapPosition = Offset.zero;

  @override
  void initState() {
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
          itemBuilder: (context, index) => InkWell(
            onTapDown: (position) => {_getTapPosition(position)},
            onLongPress: () {
              _showContextMenu(context, chats[index].id as String);
            },
            child: CustomCard(
              chatModel: chats[index],
              id: id,
              requestModel: reqModel[index],
            ),
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
          var timeString = fetchedUsers[i]["createdAt"];
          chats.add(ChatModel(
              id: fetchedUsers[i]["_id"],
              name: fetchedUsers[i]["first_name"],
              currentMessage: fetchedUsers[i]["message"] ?? "Say Hi!",
              time: timeString != null ? timeString.substring(11, 16) : "",
              pfp: fetchedUsers[i]["pfp"] != null
                  ? base64Decode(fetchedUsers[i]["pfp"]["data"])
                  : null));
          decodedImage.add(fetchedUsers[i]["pfp"] != null
              ? base64Decode(fetchedUsers[i]["pfp"]["data"])
              : null);

          reqModel.add(RequestModel(
            about: fetchedUsers[i]["about"],
            name: fetchedUsers[i]["first_name"],
            gender: fetchedUsers[i]["gender_identity"],
            ginterest: fetchedUsers[i]["gender_interest"],
            image: fetchedUsers[i]["pfp"]?["data"] ?? "",
            image2: fetchedUsers[i]["url2"] ?? "",
            image3: fetchedUsers[i]["url3"] ?? "",
            day: fetchedUsers[i]["dob_day"],
            month: fetchedUsers[i]["dob_month"],
            year: fetchedUsers[i]["dob_year"],
            interest: fetchedUsers[i]["interest"],
          ));
        }

        isLoading = false;
      });
    } else {
      print("retry");
    }
  }

  void _showContextMenu(BuildContext context, String id) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          const PopupMenuItem(
            value: "fav",
            child: Text('Favourite'),
          ),
          const PopupMenuItem(
            value: "delete",
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          )
        ]);
    // perform action on selected menu item
    switch (result) {
      case 'fav':
        print("fav");
        break;
      case 'delete':
        print('close');
        // delete api request here
        final response = await networkHandler.deleteData("/user/chat", id);
        if (response.statusCode == 200) {
          //navigate
          print("success");
        } else {
          print("fail");
        }
        break;
    }
  }

  void _getTapPosition(TapDownDetails tapPosition) {
    print('tap down');
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(tapPosition
          .globalPosition); // store the tap positon in offset variable
      print(_tapPosition);
    });
  }
}
