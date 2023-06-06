import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/functions/toastfunction.dart';
import 'package:online_matchmaking_system/model/requestmodel.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/views/bottomNavBar/bottomnavbar.dart';
import 'package:online_matchmaking_system/views/notification/notification.dart';
import 'package:online_matchmaking_system/views/profile/profile.dart';

class SearchCard extends StatefulWidget {
  const SearchCard({super.key, required this.reqModel, required this.id});
  final RequestModel reqModel;
  final String id;

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  NetworkHandler networkHandler = NetworkHandler();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfilePage(
            requestModel: widget.reqModel,
          );
        }));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 35,
              backgroundImage: (widget.reqModel.pfp == null ||
                      widget.reqModel.pfp!.isEmpty)
                  ? const AssetImage("images/pfp_default.jpg") as ImageProvider
                  : MemoryImage(widget.reqModel.pfp as Uint8List),
            ),
            title: Text(
              widget.reqModel.name as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
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

  dynamic confirmationBox(BuildContext context, String action) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text("Confirm"),
      content: RichText(
          text: TextSpan(
              text: "Are you sure you want to ",
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
            TextSpan(
                text: action,
                style: TextStyle(
                    color: action == "accept" ? Colors.green : Colors.red)),
            const TextSpan(text: "?")
          ])),
      actions: [
        TextButton(
            onPressed: () {
              print("cancel");
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              print("confirm");
              if (action == "accept") {
                //make accept req api
                handleChatRequest(action);

                showToast("Chat accepted", "accept");
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return const MainPage(
                    index: 1,
                  );
                }));
                Navigator.pop(context);
              } else {
                handleChatRequest(action);
                //make reject req api call
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return const NotificationPage();
                }));
                showToast("Chat rejected", "reject");
              }
            },
            child: const Text("Confirm")),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void handleChatRequest(String type) async {
    print(type);
    if (type == "accept") {
      final response = await networkHandler.handleReq(
          "/user/acceptreq", widget.reqModel.id as String);
      if (response.statusCode == 200) {
        print("go to chats");
      }
    } else {
      await networkHandler.handleReq(
          "/user/rejectreq", widget.reqModel.id as String);
    }
  }
}
