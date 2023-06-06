import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/model/requestmodel.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/chatwall.dart';

import '../../../model/chatmodel.dart';

class CustomCard extends StatefulWidget {
  const CustomCard(
      {super.key,
      required this.chatModel,
      required this.id,
      required this.requestModel});
  final ChatModel chatModel;
  final RequestModel requestModel;
  final String id;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  Offset _tapPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatWall(
                      chatModel: widget.chatModel,
                      id: widget.id,
                      requestModel: widget.requestModel,
                    )));
      },
      // onLongPress: () {
      //   _showContextMenu(context);
      // },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 35,
              backgroundImage: (widget.chatModel.pfp == null ||
                      widget.chatModel.pfp!.isEmpty)
                  ? const AssetImage("images/pfp_default.jpg") as ImageProvider
                  : MemoryImage(widget.chatModel.pfp as Uint8List),
            ),
            title: Text(
              widget.chatModel.name as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.chatModel.currentMessage as String,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
            trailing: Text(widget.chatModel.time as String),
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

  void _showContextMenu(BuildContext context) async {
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
            child: Text('Add Me'),
          ),
          const PopupMenuItem(
            value: "close",
            child: Text('Close'),
          )
        ]);
    // perform action on selected menu item
    switch (result) {
      case 'fav':
        print("fav");
        break;
      case 'close':
        print('close');
        Navigator.pop(context);
        break;
    }
  }

  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(tapPosition
          .globalPosition); // store the tap positon in offset variable
      print(_tapPosition);
    });
  }
}
