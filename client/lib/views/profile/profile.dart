import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:online_matchmaking_system/services/models/user_model.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/utils/constant.dart';
import 'package:online_matchmaking_system/views/profile/widgets/editprofile.dart';
import 'package:online_matchmaking_system/views/profile/widgets/menu.dart';
import 'package:online_matchmaking_system/views/profile/widgets/profilename.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.grey[50],
          elevation: 0,
          title: const Profilename(),
          centerTitle: true,
          actions: [
            menu(context),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getDeviceWidth(context) * 0.05),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("images/image2.jpg"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getDeviceHeight(context) * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Gender : ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Male",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getDeviceHeight(context) * 0.005,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Prefer gender : ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Female",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getDeviceHeight(context) * 0.02,
                  ),
                  const Editprofile(),
                  SizedBox(
                    height: getDeviceHeight(context) * 0.02,
                  ),
                ],
              ),
            ),
            const TabBar(
              indicatorColor: Colors.black,
              tabs: <Widget>[
                Tab(
                  icon: Icon(
                    Icons.grid_on_sharp,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.person_pin_outlined,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // number of columns
                        mainAxisSpacing: 2.5, // space between rows
                        crossAxisSpacing: 5, // space between columns
                        childAspectRatio:
                            1.0, // width to height ratio of grid cells
                      ),
                      itemCount: images.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 2.5),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(images[index]),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        );
                      }),
                  const Center(
                    child: Text("No favourite photo"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<UserModel>> profileFetch() async {
  const url = "http://192.168.137.1:5300/user/all";
  final uri = Uri.parse(url);
  final response = await http.get(
    uri,
    headers: {
      "Content-type": "application/json",
    },
  );
  return userModelFromJson(response.body);
}
