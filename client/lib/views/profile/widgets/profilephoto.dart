import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_matchmaking_system/utils/api.dart';
import '../../../services/network_handler.dart';
import '../../../shared_data/device_size.dart';

class ProfilePhoto extends StatefulWidget {
  // final String image;
  const ProfilePhoto({
    super.key,
  });

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  bool isLoading = true;
  var image = '';

  @override
  void initState() {
    profileFetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: isLoading,
        replacement: SafeArea(
          child: PageView(children: [
            Center(
              child: Container(
                height: getDeviceHeight(context) * 0.7,
                width: getDeviceWidth(context) * 0.95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: image.isEmpty
                            ? const AssetImage("images/pfp_default.jpg")
                                as ImageProvider
                            : MemoryImage(base64Decode(image)),
                        fit: BoxFit.cover)),
              ),
            ),
            Center(
              child: Container(
                height: getDeviceHeight(context) * 0.7,
                width: getDeviceWidth(context) * 0.95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: image.isEmpty
                            ? const AssetImage("images/pfp_default.jpg")
                                as ImageProvider
                            : MemoryImage(base64Decode(image)),
                        fit: BoxFit.cover)),
              ),
            ),
            Center(
              child: Container(
                height: getDeviceHeight(context) * 0.7,
                width: getDeviceWidth(context) * 0.95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: image.isEmpty
                            ? const AssetImage("images/pfp_default.jpg")
                                as ImageProvider
                            : MemoryImage(base64Decode(image)),
                        fit: BoxFit.cover)),
              ),
            ),
          ]),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> profileFetch() async {
    const appurl = Api.appurl;
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
      setState(() {
        image = userImage;
        isLoading = false;
      });
    } else {
      print('wtf?');
    }
  }
}
