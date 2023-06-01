import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/searchwall.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarColor: Colors.grey[50],
        //   statusBarBrightness: Brightness.dark,
        // ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: const Text(
          "Search",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: getDeviceWidth(context) * 0.05,
            right: getDeviceWidth(context) * 0.05),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: searchboxController,
              decoration: InputDecoration(
                  hintText: "What do you wanna talk about?",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              minLines: 3,
              maxLines: 6,
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 45,
              width: getDeviceWidth(context) * 0.9,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2B2C43),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  onPressed: searchFunc,
                  child: const Text(
                    "Find",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void searchFunc() async {
    final userId = await NetworkHandler.getValue("userId");

    final interests = searchboxController.text.toLowerCase();
    final iList = interests.split(" ");
    if (!mounted) return;

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return SearchWall(
        id: userId as String,
        interest: iList,
      );
    }));
  }
}
