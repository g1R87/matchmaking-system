import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/views/addphoto/addphoto.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController fnamecontroller = TextEditingController();
  TextEditingController aboutmecontroller = TextEditingController();
  ScrollController scrollViewColtroller = ScrollController();

  //text editing controller for text field

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    scrollViewColtroller = ScrollController();
    scrollViewColtroller.addListener(_scrollListener);
    super.initState();
  }

  String message = '';
  bool _direction = false;

  _scrollListener() {
    if (scrollViewColtroller.offset >=
            scrollViewColtroller.position.maxScrollExtent &&
        !scrollViewColtroller.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
        _direction = true;
      });
    }
    if (scrollViewColtroller.offset <=
            scrollViewColtroller.position.minScrollExtent &&
        !scrollViewColtroller.position.outOfRange) {
      setState(() {
        message = "reach the top";
        _direction = false;
      });
    }
  }

  _moveUp() {
    scrollViewColtroller.animateTo(scrollViewColtroller.offset - 50,
        curve: Curves.linear, duration: const Duration(milliseconds: 500));
  }

  _moveDown() {
    scrollViewColtroller.animateTo(scrollViewColtroller.offset + 50,
        curve: Curves.linear, duration: const Duration(milliseconds: 500));
  }

  String? gender;
  String? genderInterest;

  @override
  void dispose() {
    super.dispose();
    scrollViewColtroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Visibility(
            visible: _direction,
            maintainSize: false,
            child: FloatingActionButton(
              onPressed: () {
                _moveUp();
              },
              child: const RotatedBox(
                  quarterTurns: 1, child: Icon(Icons.chevron_left)),
            ),
          ),
          Visibility(
            maintainSize: false,
            visible: !_direction,
            child: FloatingActionButton(
              onPressed: () {
                _moveDown();
              },
              child: const RotatedBox(
                  quarterTurns: 3, child: Icon(Icons.chevron_left)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollViewColtroller.position.userScrollDirection ==
                ScrollDirection.reverse) {
              print('User is going down');
              setState(() {
                message = 'going down';
                _direction = true;
              });
            } else {
              if (scrollViewColtroller.position.userScrollDirection ==
                  ScrollDirection.forward) {
                print('User is going up');
                setState(() {
                  message = 'going up';
                  _direction = false;
                });
              }
            }
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: ListView(
                  controller: scrollViewColtroller,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: fnamecontroller,
                      decoration: const InputDecoration(
                        hintText: "First name",
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "My Birthday",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: Center(
                          child: TextField(
                        controller:
                            dateinput, //editing controller of this TextField
                        decoration: const InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            hintText: "DD/MM/YYYY" //label text of field
                            ),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  1950), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              dateinput.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      )),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("Your age will be public"),
                    const SizedBox(
                      height: 50,
                    ),
                    //gender
                    const Text(
                      "Gender",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RadioListTile(
                      title: const Text("Male"),
                      value: "male",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text("Female"),
                      value: "female",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),

                    RadioListTile(
                      title: const Text("Other"),
                      value: "other",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    //gender interest
                    const Text(
                      "Interest",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RadioListTile(
                      title: const Text("Male"),
                      value: "male",
                      groupValue: genderInterest,
                      onChanged: (value) {
                        setState(() {
                          genderInterest = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text("Female"),
                      value: "female",
                      groupValue: genderInterest,
                      onChanged: (value) {
                        setState(() {
                          genderInterest = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text("Other"),
                      value: "other",
                      groupValue: genderInterest,
                      onChanged: (value) {
                        setState(() {
                          genderInterest = value.toString();
                        });
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: TextField(
                        controller: aboutmecontroller,
                        decoration: const InputDecoration(
                          hintText: "Write something about yourself",
                        ),
                        keyboardType: TextInputType.multiline,
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
                        width: 280,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff2B2C43),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35))),
                            onPressed: updateFunc,
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateFunc() async {
    final appurl = dotenv.env["appurl"];
    //get form data
    final bday = dateinput.text.split("-");
    final fname = fnamecontroller.text;
    final dobYear = int.parse(bday[0]);
    final dobMonth = int.parse(bday[1]);
    final dobDay = int.parse(bday[2]);
    final about = aboutmecontroller.text;
    final body = {
      "first_name": fname,
      "dob_day": dobDay,
      "dob_month": dobMonth,
      "dob_year": dobYear,
      "gender_identity": gender,
      "gender_interest": genderInterest,
      "about": about,
    };
    final token = await NetworkHandler.getToken("token");
    //put request
    final url = "$appurl/user";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        "Content-type": "application/json",
        "authorization": "Bearer $token",
      },
    );
    var responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      showSuccessMessage("All set!");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const MultipleImageSelector();
          },
        ),
      );
    } else {
      showFailureMessage(responseData["msg"]);
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showFailureMessage(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
