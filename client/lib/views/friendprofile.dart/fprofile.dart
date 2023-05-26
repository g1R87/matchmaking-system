import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/views/profile/widgets/menu.dart';
import 'package:online_matchmaking_system/views/profile/widgets/profilename.dart';
import 'package:online_matchmaking_system/views/profile/widgets/profilepic.dart';

class FProfilePage extends StatefulWidget {
  const FProfilePage({super.key});

  @override
  State<FProfilePage> createState() => _FProfilePageState();
}

class _FProfilePageState extends State<FProfilePage> {
  bool isLoading = true;
  var about = "";
  var fname = "";
  var gender = '';
  var ginterest = '';
  var image = '';
  String age = '';

  @override
  void initState() {
    super.initState();
    profileFetch();
  }

  String calculateAge(int year, int month, int day) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - year;
    int month1 = currentDate.month;
    int month2 = month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
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
          title: Profilename(about: about, fname: fname, image: image),
          centerTitle: true,
          actions: [
            menu(context, name: fname, aboutme: about),
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
                      Container(
                        padding: const EdgeInsets.all(12),
                        height: 50,
                        width: getDeviceWidth(context),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 212, 212),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
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
                      ),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.015,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        height: 50,
                        width: getDeviceWidth(context),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 212, 212),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
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
                      ),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.015,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        height: 50,
                        width: getDeviceWidth(context),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 212, 212),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            const Text(
                              "Age : ",
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PTSans'),
                            ),
                            Text(
                              age.isEmpty ? "na" : age,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'PTSans',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.015,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        height: 120,
                        width: getDeviceWidth(context),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 212, 212),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                          ],
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

      final year = responseData['dob_year'];
      final month = responseData['dob_month'];
      final day = responseData['dob_day'];
      print("$year $month $day");
      setState(() {
        about = userabout;
        fname = userfname;
        gender = userGender;
        ginterest = userInterest;
        image = userImage;
        age = calculateAge(year, month, day);
        isLoading = false;
      });
    } else {
      print('sorry');
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
