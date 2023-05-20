import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/model/requestmodel.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({super.key, required this.reqModel, required this.id});
  final RequestModel reqModel;
  final String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 35,
              backgroundImage: (reqModel.pfp == null || reqModel.pfp!.isEmpty)
                  ? const AssetImage("images/pfp_default.jpg") as ImageProvider
                  : MemoryImage(reqModel.pfp as Uint8List),
            ),
            title: Text(
              reqModel.name as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "wants to chat",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      confirmationBox(context, "accept");
                      print("after dialog");
                    },
                    icon: const Icon(
                      CupertinoIcons.checkmark_alt_circle,
                      color: Colors.green,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      confirmationBox(context, "reject");
                      print("after dialog");
                    },
                    icon: const Icon(
                      CupertinoIcons.xmark_circle,
                      color: Colors.red,
                      size: 30,
                    )),
              ],
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
                //make accept req api call
                print("Accepted");
                Navigator.pop(context);
              } else {
                //make reject req api call
                print("Rejected");
                Navigator.pop(context);
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
}
