import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/views/profile/widgets/logout_alertbox.dart';

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
              height: 350,
              child: Column(
                children: [
                  SizedBox(
                    height: getDeviceHeight(context) * 0.012,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: getDeviceWidth(context) * 0.18,
                      ),
                      Container(
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(CupertinoIcons.multiply)),
                    ],
                  ),
                  listofMenu(Icons.settings, "Settings", context),
                  listofMenu(Icons.bookmark_border, "Saved", context),
                  listofMenu(Icons.star_border, "Favourites", context),
                  listofMenu(
                      Icons.local_activity_outlined, "Your Activity", context),
                  listofMenu(Icons.menu, "Close friends", context),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DialogBox(),
                        ));
                      },
                      child: listofMenu(Icons.logout, "logout", context)),
                  SizedBox(
                    height: getDeviceHeight(context) * 0.02,
                  )
                ],
              ),
            );
          });
    },
    icon: const Icon(Icons.menu),
  );
}

Widget listofMenu(IconData icon, String text, BuildContext context) {
  return Expanded(
    child: SizedBox(
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
    ),
  );
}
