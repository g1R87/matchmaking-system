import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/model/requestmodel.dart';
import 'dart:convert';

import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/views/notification/widgets/request_card.dart';

class RequestList extends StatefulWidget {
  const RequestList({super.key});

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  bool isLoading = true;
  String id = "";
  NetworkHandler networkHandler = NetworkHandler();
  List<RequestModel> reqs = [];
  List<dynamic> decodedImage = [];
  @override
  void initState() {
    print("notf page");
    fetchPending();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: isLoading,
        replacement: ListView.builder(
          itemCount: reqs.length,
          itemBuilder: (context, index) => RequestCard(
            reqModel: reqs[index],
            id: id,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void fetchPending() async {
    final response = await networkHandler.getData("/user/fetchpending");
    final userId = await NetworkHandler.getValue("userId");
    final fetchedUsers = await jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (!mounted) {
        return;
      }
      setState(() {
        id = userId as String;
        for (int i = 0; i < fetchedUsers.length; i++) {
          reqs.add(
            RequestModel(
              id: fetchedUsers[i]["_id"],
              name: fetchedUsers[i]["first_name"],
              pfp: fetchedUsers[i]["pfp"] != null
                  ? base64Decode(fetchedUsers[i]["pfp"]["data"])
                  : null,
              about: fetchedUsers[i]["about"],
              gender: fetchedUsers[i]["gender_identity"],
              ginterest: fetchedUsers[i]["gender_interest"],
              day: fetchedUsers[i]["dob_day"],
              month: fetchedUsers[i]["dob_month"],
              year: fetchedUsers[i]["dob_year"],
              image: fetchedUsers[i]["pfp"]["data"] ?? "",
              image2: fetchedUsers[i]["url2"] ?? "",
              image3: fetchedUsers[i]["url3"] ?? "",
            ),
          );
          decodedImage.add(fetchedUsers[i]["pfp"] != null
              ? base64Decode(fetchedUsers[i]["pfp"]["data"])
              : null);
        }

        isLoading = false;
      });
    } else {
      print("retry");
    }
  }
}
