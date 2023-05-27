import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:online_matchmaking_system/functions/toastfunction.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/views/addphoto/addphoto.dart';
import 'package:http/http.dart' as http;

class DetailsPage extends StatefulWidget {
  final Map? detail;
  const DetailsPage({
    super.key,
    this.detail,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController fnamecontroller = TextEditingController();
  TextEditingController aboutmecontroller = TextEditingController();
  final _globalkey = GlobalKey<FormState>();
  int? byear;
  int? bmonth;
  int? bday;

  bool isLoading = false;
  bool isEdit = false;
  String age = '0';

  //text editing controller for text field

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field

    super.initState();
    final detail = widget.detail;
    if (detail != null) {
      isEdit = true;
      fnamecontroller.text = detail["fname"];
      aboutmecontroller.text = detail["aboutme"];
    }
  }

  String message = '';

  String? gender;
  String? genderInterest;

  String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  NetworkHandler networkHandler = NetworkHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your details"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 150, 235, 152),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 10,
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _globalkey,
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        imageProfile(),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Name can't be empty";
                            }
                            return null;
                          },
                          controller: fnamecontroller,
                          decoration: InputDecoration(
                            label: const Text("User id"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text(
                          "My Birthday",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          child: Center(
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "DOB can't be empty";
                                    }
                                    return null;
                                  },
                                  controller:
                                      dateinput, //editing controller of this TextField
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                    label: const Text("DD/MM/YYYY"),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    //icon of text field

                                    //label text of field
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
                                      setState(() {
                                        age = calculateAge(pickedDate);
                                        byear = pickedDate.year;
                                        bmonth = pickedDate.month;
                                        bday = pickedDate.day;
                                      });
                                    }

                                    if (pickedDate != null) {
                                      print(
                                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
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
                                ),
                              ],
                            ),
                          ),
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
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: const Color.fromARGB(255, 246, 248, 248),
                          child: Column(children: [
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
                          ]),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        //gender interest
                        const Text(
                          "Interest",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: const Color.fromARGB(255, 246, 248, 248),
                          child: Column(children: [
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
                          ]),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please write something about yourself";
                              }
                              return null;
                            },
                            controller: aboutmecontroller,
                            decoration: InputDecoration(
                                hintText: "Write something about yourself",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
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
                                        borderRadius:
                                            BorderRadius.circular(35))),
                                onPressed: updateFunc,
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        "Continue",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: imageFile == null
                ? const AssetImage("images/pfp_default.jpg") as ImageProvider
                : FileImage(File(imageFile!.path)),
          ),
          Positioned(
              bottom: 5,
              right: 5,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context, builder: ((builder) => bottomSheet()));
                },
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.teal,
                  size: 29,
                ),
              ))
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text(
            "Chose Pictures",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  chosePhoto(ImageSource.camera);
                },
                child: const Icon(Icons.camera, size: 40),
              ),
              TextButton(
                onPressed: () {
                  chosePhoto(ImageSource.gallery);
                },
                child: const Icon(Icons.image, size: 40),
              )
            ],
          )
        ],
      ),
    );
  }

  void chosePhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(
      source: source,
    );
    setState(() {
      imageFile = pickedFile;
    });
  }

  Future<void> updateFunc() async {
    setState(() {
      isLoading = true;
    });

    print("$byear $bmonth $bday is the thingg");
    final appurl = dotenv.env["appurl"];
    //get form data
    final fname = fnamecontroller.text;
    final datefiled = dateinput.text;
    // final dobYear = int.parse(bday[0]);
    // final dobMonth = int.parse(bday[1]);
    // final dobDay = int.parse(bday[2]);
    final about = aboutmecontroller.text;
    if (isEdit == false &&
        (gender == null ||
            genderInterest == null ||
            fname.isEmpty ||
            about.isEmpty ||
            datefiled.isEmpty)) {
      showToast("select all fields", "reject");
      setState(() {
        isLoading = false;
      });
    } else {
      final body = {
        "first_name": fname.isNotEmpty ? fname : null,
        "dob_day": bday,
        "dob_month": bmonth,
        "dob_year": byear,
        "gender_identity": gender,
        "gender_interest": genderInterest,
        "about": about.isNotEmpty ? about : null,
        "isUpdated": true,
      };

      final token = await NetworkHandler.getValue("token");
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (imageFile != null) {
          final imageResponse = await networkHandler.updatePfp(imageFile!.path);

          if (imageResponse.statusCode == 200) {
            setState(() {
              isLoading = false;
            });
            final pfpResponse = await networkHandler.getData("/image/pfp");
            final pfpData = jsonDecode(pfpResponse.body);
            if (pfpResponse.statusCode == 200) {
              await NetworkHandler.storeValue("pfp", pfpData["data"] ?? "");
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const MultipleImageSelector();
                },
              ),
            );
          } else {
            showFailureMessage("Please try again");
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
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
