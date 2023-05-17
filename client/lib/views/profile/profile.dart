import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/utils/constant.dart';
import 'package:online_matchmaking_system/views/profile/widgets/editprofile.dart';
import 'package:online_matchmaking_system/views/profile/widgets/logout_alertbox.dart';
import 'package:online_matchmaking_system/views/profile/widgets/menu.dart';
import 'package:online_matchmaking_system/views/profile/widgets/profilename.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  var about = "";
  var fname = "";
  var gender = '';
  var ginterest = '';
  var image = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileFetch();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.grey[50],
          elevation: 0,
          title: Profilename(about: about, fname: fname),
          centerTitle: true,
          actions: [
            menu(context),
          ],
        ),
        body: Visibility(
          visible: isLoading,
          replacement: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getDeviceWidth(context) * 0.05),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
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
                                    height: 200,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height:
                                              getDeviceHeight(context) * 0.005,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: getDeviceWidth(context) *
                                                    0.18,
                                              ),
                                              Container(
                                                height: 4,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              ),
                                              GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Icon(
                                                      CupertinoIcons.multiply))
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            child: listofMenu(Icons.settings,
                                                "Settings", context)),
                                        Expanded(
                                            child: listofMenu(Icons.update,
                                                "Update", context)),
                                        Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      const DialogBox(),
                                                ));
                                              },
                                              child: listofMenu(Icons.logout,
                                                  "logout", context)),
                                        ),
                                        SizedBox(
                                          height:
                                              getDeviceHeight(context) * 0.02,
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: image.isEmpty
                                ? const AssetImage("images/pfp_default.jpg")
                                    as ImageProvider
                                : MemoryImage(base64Decode(image)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: getDeviceHeight(context) * 0.015,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Gender : ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          gender,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getDeviceHeight(context) * 0.005,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Prefer gender : ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          ginterest,
                          style: const TextStyle(
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
                    child: Text(
                      "About me",
                      style: TextStyle(color: Colors.black),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(about),
                    ),
                  ],
                ),
              ),
            ],
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Future<void> profileFetch() async {
    final appurl = dotenv.env["appurl"];
    print(await NetworkHandler.getValue("pfp"));

    final token = await NetworkHandler.getValue("token");
    final id = await NetworkHandler.getValue("userId");
    final userImage = await NetworkHandler.getValue("pfp") as String;
    //get request
    final url = "$appurl/user?id=$id";
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        "Content-type": "application/json",
        "authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map;
      final userfname = responseData["first_name"];
      final userabout = responseData["about"];
      final userGender = responseData['gender_identity'];
      final userInterest = responseData['gender_interest'];
      setState(() {
        about = userabout;
        fname = userfname;
        gender = userGender;
        ginterest = userInterest;
        image = userImage;
        isLoading = false;
      });
    } else {
      print('wtf?');
    }
  }

  // Future<void> fetchPfp() async {
  //   final appurl = dotenv.env["appurl"];

  //   final token = await NetworkHandler.getValue("token");
  //   final id = await NetworkHandler.getValue("userId");
  //   //get request
  //   final url = "$appurl/image/pfp";
  //   final uri = Uri.parse(url);
  //   final response = await http.get(
  //     uri,
  //     headers: {
  //       "authorization": "Bearer $token",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body) as Map;
  //     await NetworkHandler.storeValue("pfp", responseData["data"]??"");
  //     final userImage = NetworkHandler.getValue("pfp") as String;

  //     setState(() {
  //       image = userImage;
  //       isLoading = false;
  //     });
  //   } else {
  //     print('wtf?');
  //   }
  // }
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
