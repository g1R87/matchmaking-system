import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/model/requestmodel.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/views/user_search/searchcard.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({super.key});

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  TextEditingController searchBoxController = TextEditingController();
  NetworkHandler networkHandler = NetworkHandler();
  String id = "";
  bool isLoading = false;

  List<RequestModel> reqs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: searchFunction,
              icon: const Icon(
                CupertinoIcons.search,
                color: Colors.green,
                size: 30,
              )),
        ],
        title: TextFormField(
          controller: searchBoxController,
          autofocus: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Type here",
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 150, 235, 152),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: ListView.builder(
          itemCount: reqs.length,
          itemBuilder: (context, index) =>
              SearchCard(reqModel: reqs[index], id: id),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void searchFunction() async {
    setState(() {
      isLoading = true;
      reqs = [];
    });
    final userId = await NetworkHandler.getValue("userId");
    final body = {
      "targetInterest": searchBoxController.text,
    };
    final response = await networkHandler.getDataWithBody("/user/search", body);
    final fetchedUsers = jsonDecode(response.body);
    print("the length is ${fetchedUsers.length}");

    if (response.statusCode == 200) {
      if (!mounted) return;
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
              interest: fetchedUsers[i]["interest"],
            ),
          );
        }
        isLoading = false;
      });
    }
  }
}
