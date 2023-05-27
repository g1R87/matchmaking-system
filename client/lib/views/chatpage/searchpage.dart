import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_matchmaking_system/views/chatpage/widgets/searchchat.dart';

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
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.grey[50],
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.grey[50],
          elevation: 0,
          title: const Text(
            "Search",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please write something about yourself";
                  }
                  return null;
                },
                controller: searchboxController,
                decoration: InputDecoration(
                    hintText: "What do you wanna talk about?",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                minLines: 3,
                maxLines: 6,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Center(
              child: SizedBox(
                height: 45,
                width: 150,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2B2C43),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35))),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return const SearchWall();
                      }));
                    },
                    child: const Text(
                      "Find",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    )),
              ),
            )
          ],
        ));
  }
}
