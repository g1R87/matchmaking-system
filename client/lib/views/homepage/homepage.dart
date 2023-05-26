import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/functions/alertfunctions.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/views/profile/profile.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../utils/constant.dart';

class ShowingPage extends StatefulWidget {
  const ShowingPage({super.key});

  @override
  State<ShowingPage> createState() => _ShowingPageState();
}

class _ShowingPageState extends State<ShowingPage> {
  final List<SwipeItem> _swipeItem = <SwipeItem>[];
  MatchEngine? _matchEngine;

  bool isLoading = true;
  NetworkHandler networkHandler = NetworkHandler();
  List<dynamic> users = [];
  List<dynamic> decodedImage = [];

  @override
  void initState() {
    fetchUsers();

    _matchEngine = MatchEngine(swipeItems: _swipeItem);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  imageWidget("images/image1.jpg"),
                  buttonWidget(Icons.star, Colors.amber),
                  buttonWidget(Icons.notifications, Colors.grey.shade400)
                ],
              ),
            ),
            Expanded(
              child: Visibility(
                visible: isLoading,
                replacement: SizedBox(
                  child: SwipeCards(
                    matchEngine: _matchEngine!,
                    onStackFinished: () {
                      return ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("List is over")));
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: decodedImage[index] == null
                                      ? AssetImage(images[1]) as ImageProvider
                                      : MemoryImage(decodedImage[index]),
                                  // image: AssetImage(images[index]),
                                  fit: BoxFit.cover),
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return ProfilePage(
                                        detail: {
                                          "fname": users[index]["first_name"],
                                          "about": users[index]["about"],
                                          "gender": users[index]
                                              ["gender_identity"],
                                          "ginterest": users[index]
                                              ["gender_interest"],
                                          "image": users[index]["pfp"]["data"],
                                          "year": users[index]["dob_year"],
                                          "month": users[index]["dob_month"],
                                          "day": users[index]["dob_day"],
                                        },
                                      );
                                    },
                                  ));
                                },
                                child: Text(
                                  users[index]["first_name"],
                                  style: const TextStyle(
                                      fontSize: 32,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.12,
            //   width: MediaQuery.of(context).size.width,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       buttonWidget(Icons.refresh, Colors.amber),
            //       buttonWidget(Icons.cancel, Colors.red),
            //       buttonWidget(Icons.star, Colors.blue),
            //       GestureDetector(
            //           onTap: () {},
            //           child: buttonWidget(
            //               Icons.favorite_outline_outlined, Colors.green)),
            //       buttonWidget(Icons.bolt, Colors.purple),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void fetchUsers() async {
    final response = await networkHandler.getData("/user/fetchuser");
    final fetchedUsers = await jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          users = fetchedUsers;
          for (int i = 0; i < users.length; i++) {
            decodedImage.add(users[i]["pfp"] != null
                ? base64Decode(users[i]["pfp"]["data"])
                : null);

            _swipeItem.add(
              SwipeItem(
                content: Content(text: users[i]["first_name"]),
                likeAction: () {
                  print("like");
                  actions(context, users[i], "Liked");
                },
                nopeAction: () {
                  print("dislike");
                  actions(context, users[i], 'Rejected');
                },
                superlikeAction: () {
                  print('superlike');
                  actions(context, users[i], "SuperLiked");
                },
              ),
            );
          }
          print(decodedImage.length);

          isLoading = false;
        });
      }
    } else {
      print("retry");
    }
  }
}

Widget buttonWidget(IconData icon, Color color) {
  return Container(
    height: 60,
    width: 60,
    decoration: BoxDecoration(
        border: Border.all(width: 0.3),
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle),
    child: Icon(
      icon,
      color: color,
      size: 30,
    ),
  );
}

Widget imageWidget(String image) {
  return Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.cover,
      ),
    ),
  );
}

class Content {
  final String? text;
  Content({this.text});
}
