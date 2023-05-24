import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';

class Profilename extends StatelessWidget {
  final String about;
  final String fname;
  final String image;
  const Profilename(
      {super.key,
      required this.about,
      required this.fname,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              builder: (BuildContext context) {
                return Container(
                    height: 180,
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(20))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Container(
                          height: 7,
                          width: 45,
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        SizedBox(
                          height: getDeviceHeight(context) * 0.01,
                        ),
                        Expanded(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: image.isEmpty
                                  ? const AssetImage("images/pfp_default.jpg")
                                      as ImageProvider
                                  : MemoryImage(base64Decode(image)),
                              radius: 30,
                            ),
                            title: Text(fname),
                            trailing: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Color.fromARGB(255, 15, 244, 23),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.black54,
                              ),
                            ),
                            title: Text("Add account"),
                          ),
                        ),
                      ],
                    ));
              });
        },
        child: Row(
          children: [
            Text(
              fname,
              style: const TextStyle(color: Colors.black),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded)
          ],
        ));
  }
}
