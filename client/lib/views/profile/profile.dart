import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/views/profile/widgets/menu.dart';
import 'package:online_matchmaking_system/views/profile/widgets/profilename.dart';
import 'package:online_matchmaking_system/views/profile/widgets/profilepic.dart';

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
        body: SingleChildScrollView(
          child: Visibility(
            visible: isLoading,
            replacement: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getDeviceWidth(context) * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ProfilePic(image: image)],
                      ),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.1,
                      ),
                      Row(
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          const Text(
                            "Name : ",
                            style: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PTSans'),
                          ),
                          Text(
                            fname,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'PTSans',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.015,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Gender : ",
                            style: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PTSans'),
                          ),
                          Text(
                            gender,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'PTSans',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.015,
                      ),
                      Row(
                        children: const [
                          Text(
                            "Age : ",
                            style: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PTSans'),
                          ),
                          Text(
                            "23",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'PTSans',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.015,
                      ),
                      const Text(
                        "About me: ",
                        style: TextStyle(
                            letterSpacing: 1.5,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PTSans'),
                      ),
                      Text(
                        about,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'PTSans',
                        ),
                      ),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.02,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
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
