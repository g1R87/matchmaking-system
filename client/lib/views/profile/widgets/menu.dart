import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/views/addphoto/addphoto.dart';
import 'package:online_matchmaking_system/views/profile/widgets/logout_alertbox.dart';
import 'package:online_matchmaking_system/views/userdetails/user_details.dart';

IconButton menu(BuildContext context,
    {String name = "",
    String aboutme = "",
    String url2 = "",
    String url3 = ""}) {
  return IconButton(
    onPressed: () {
      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                          child: const Icon(CupertinoIcons.multiply_circle))
                    ],
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () {},
                        child:
                            listofMenu(Icons.settings, "Settings", context))),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return DetailsPage(
                              detail: {"fname": name, "aboutme": aboutme},
                            );
                          }));
                        },
                        child:
                            listofMenu(Icons.edit, "Edit profile", context))),
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return MultipleImageSelector(
                                detail: {
                                  "url2": url2,
                                  "url3": url3,
                                },
                              );
                            },
                          ),
                        );
                      },
                      child:
                          listofMenu(Icons.update, "Update Photos", context)),
                ),
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
        },
      );
    },
    icon: const Icon(CupertinoIcons.bars),
  );
}

Widget listofMenu(IconData icon, String text, BuildContext context) {
  return SizedBox(
    height: 30,
    child: Row(
      children: [
        SizedBox(
          width: getDeviceWidth(context) * 0.05,
        ),
        Icon(
          icon,
          color: Colors.black54,
          size: 27,
        ),
        SizedBox(
          width: getDeviceWidth(context) * 0.05,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
