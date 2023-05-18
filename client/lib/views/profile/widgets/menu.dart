import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/views/profile/widgets/logout_alertbox.dart';

import '../../../utils/routesname.dart';

IconButton menu(BuildContext context) {
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
                          child: const Icon(CupertinoIcons.multiply))
                    ],
                  ),
                ),
                Expanded(
                    child: listofMenu(Icons.settings, "Settings", context)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.detail);
                  },
                  child: Expanded(
                      child: listofMenu(Icons.edit, "Edit profile", context)),
                ),
                Expanded(
                  child: listofMenu(Icons.update, "Update", context),
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
    icon: const Icon(Icons.menu),
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
