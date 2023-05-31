import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/utils/api.dart';
import 'package:online_matchmaking_system/views/profile/widgets/menu.dart';
import 'package:online_matchmaking_system/views/profile/widgets/profilename.dart';
import 'package:online_matchmaking_system/views/profile/widgets/profilepic.dart';

class ProfilePage extends StatefulWidget {
  final Map? detail;
  const ProfilePage({super.key, this.detail});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isOther = false;
  bool isLoading = true;
  var about = "";
  var fname = "";
  var gender = '';
  var ginterest = '';
  var image = "";
  String age = '';
  String imgLink2 = "";
  String imgLink3 = "";
  final appurl = Api.appurl;

  @override
  void initState() {
    final detail = widget.detail;
    if (detail != null) {
      isOther = true;
      about = detail["about"];
      fname = detail["fname"];
      gender = detail["gender"];
      ginterest = detail["ginterest"];
      image = detail['image'] ?? "";
      age = calculateAge(
        detail["year"],
        detail["month"],
        detail["day"],
      );
      isLoading = false;
    } else {
      profileFetch();
    }
    super.initState();
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
          title: isOther
              ? Text(fname)
              : Profilename(about: about, fname: fname, image: image),
          centerTitle: true,
          actions: [
            isOther
                ? Container()
                : menu(context,
                    name: fname,
                    aboutme: about,
                    url2: imgLink2,
                    url3: imgLink3),
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
                        height: getDeviceHeight(context) * 0.07,
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
                        height: 140,
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
                      SizedBox(
                        height: 300,
                        width: getDeviceWidth(context),
                        child: PageView(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imgLink2.isEmpty
                                          ? const AssetImage(
                                                  "images/pfp_default.jpg")
                                              as ImageProvider
                                          : NetworkImage(
                                              "$appurl/image/$imgLink2"),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imgLink3.isEmpty
                                          ? const AssetImage(
                                                  "images/pfp_default.jpg")
                                              as ImageProvider
                                          : NetworkImage(
                                              "$appurl/image/$imgLink3"),
                                      fit: BoxFit.cover)),
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
    const appurl = Api.appurl;

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
      final url2 = responseData["url2"];
      final url3 = responseData["url3"];
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
        imgLink2 = url2 ?? "";
        imgLink3 = url3 ?? "";
        age = calculateAge(year, month, day);
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
