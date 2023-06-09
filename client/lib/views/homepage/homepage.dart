import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/model/requestmodel.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/utils/api.dart';
import 'package:online_matchmaking_system/views/notification/notification.dart';
import 'package:online_matchmaking_system/views/profile/profile.dart';
import 'package:online_matchmaking_system/views/user_search/user_search.dart';
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
  final appurl = Api.appurl;

  bool isLoading = true;
  NetworkHandler networkHandler = NetworkHandler();
  String image = "";
  int notf = 0;
  List<dynamic> users = [];
  List<dynamic> decodedImage = [];
  List<dynamic> netImage = [];
  List<dynamic> loadedImage = [];

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
                  imageWidget(image),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UserSearch(),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.search),
                          SizedBox(
                            width: 12,
                          ),
                          Text("Search user"),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return const NotificationPage();
                      }));
                    },
                    child: notf > 0
                        ? buttonWidget(
                            Icons.notifications, Colors.grey.shade400)
                        : Stack(
                            children: [
                              buttonWidget(
                                  Icons.notifications, Colors.grey.shade400),
                              const Positioned(
                                left: 35,
                                bottom: 5,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.red,
                                ),
                              )
                            ],
                          ),
                  ),
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
                                  // : CachedNetworkImageProvider(
                                  //     "$appurl/image/${netImage[index]}",
                                  //   ),
                                  // image: AssetImage(images[index]),
                                  fit: BoxFit.cover),
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
                                        requestModel: RequestModel(
                                          name: users[index]["first_name"],
                                          about: users[index]["about"],
                                          gender: users[index]
                                              ["gender_identity"],
                                          ginterest: users[index]
                                              ["gender_interest"],
                                          image: users[index]["pfp"] != null
                                              ? users[index]["pfp"]["data"]
                                              : "",
                                          year: users[index]["dob_year"],
                                          month: users[index]["dob_month"],
                                          day: users[index]["dob_day"],
                                          image2: users[index]["url2"] ?? "",
                                          image3: users[index]["url3"] ?? "",
                                          interest: users[index]["interest"],
                                        ),
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
          ],
        ),
      ),
    );
  }

  void fetchUsers() async {
    final img = await NetworkHandler.getValue("pfp");
    final response = await networkHandler.getData("/user/fetchuser");
    // final pending = await networkHandler.getData("/user/fetchpending");
    final fetchedUsers = await jsonDecode(response.body);
    // final pendingList = await jsonDecode(pending.body);
    if (response.statusCode == 200) {
      // for (int i = 0; i < fetchedUsers.length; i++) {
      //   var imgRes =
      //       await networkHandler.getData('/image/${fetchedUsers[i]["url1"]}');
      //   if (imgRes.statusCode == 200) {
      //     decodedImage.add(imgRes.bodyBytes);
      //   } else {
      //     decodedImage.add(null);
      //   }
      // }
      if (mounted) {
        setState(() {
          // notf = pendingList.length;
          // print(notf);
          image = img as String;
          users = fetchedUsers;
          for (int i = 0; i < users.length; i++) {
            decodedImage.add(users[i]["pfp"] != null
                ? base64Decode(users[i]["pfp"]["data"])
                : null);
            netImage.add(users[i]["url1"]);
            loadedImage.add(users[i]['url1'] != null
                ? NetworkImage("$appurl/image/${users[i]['url1']}")
                : null);

            _swipeItem.add(
              SwipeItem(
                content: Content(text: users[i]["first_name"]),
                likeAction: () {
                  print("like");

                  //!  temporarily commented
                  voteFunc(users[i]["_id"], "voteup");

                  // actions(context, users[i]["first_name"], "Liked");
                },
                nopeAction: () {
                  print("dislike");

                  //!  temporarily commented
                  voteFunc(users[i]["_id"], "votedown");

                  // actions(context, users[i]["first_name"], 'Rejected');
                },
              ),
            );
          }

          isLoading = false;
        });
      }
    } else {
      print("retry");
    }
  }

  void voteFunc(String id, String type) async {
    if (type == "voteup") {
      final response = await networkHandler.vote("/user/voteup?id=$id");
      response.statusCode == 200 ? print("success") : print("fail");
    } else {
      final response = await networkHandler.vote("/user/votedown?id=$id");
      response.statusCode == 200 ? print("success") : print("fail");
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
        image: image.isEmpty
            ? const AssetImage("images/pfp_default.jpg") as ImageProvider
            : MemoryImage(base64Decode(image)),
        fit: BoxFit.cover,
      ),
    ),
  );
}

class Content {
  final String? text;
  Content({this.text});
}
