import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/views/profile/widgets/profilephoto.dart';

import '../profile.dart';
import 'logout_alertbox.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 240,
                child: Column(
                  children: [
                    SizedBox(
                      height: getDeviceHeight(context) * 0.005,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: getDeviceWidth(context) * 0.18,
                          ),
                          Container(
                            height: 4,
                            width: 35,
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(CupertinoIcons.multiply))
                        ],
                      ),
                    ),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfilePhoto(),
                        ));
                      },
                      child: listofMenu(CupertinoIcons.viewfinder,
                          "View Profile Photo", context),
                    )),
                    Expanded(
                        child: GestureDetector(
                            onTap: () {},
                            child: listofMenu(
                                Icons.settings, "Settings", context))),
                    Expanded(
                        child: GestureDetector(
                            onTap: () {},
                            child:
                                listofMenu(Icons.update, "Update", context))),
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const DialogBox(),
                            ));
                          },
                          child: listofMenu(Icons.logout, "logout", context)),
                    ),
                    SizedBox(
                      height: getDeviceHeight(context) * 0.02,
                    )
                  ],
                ),
              );
            });
      },
      child: CircleAvatar(
        radius: 50,
        backgroundImage: image.isEmpty
            ? const AssetImage("images/pfp_default.jpg") as ImageProvider
            : MemoryImage(base64Decode(image)),
      ),
    );
  }
}
