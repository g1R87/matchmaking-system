import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/views/addphoto/addphoto.dart';

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
  bool isLoading = false;
  bool isEdit = false;

  //text editing controller for text field

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field

    super.initState();
    final detail = widget.detail;
    if (detail != null) {
      isEdit = true;
    }
  }

  String message = '';

  String? gender;
  String? genderInterest;

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 10,
                child: ListView(
                  children: [
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
                          child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "DOB can't be empty";
                          }
                          return null;
                        },
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
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please write something about yourself";
                          }
                          return null;
                        },
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
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "Continue",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
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
      maxHeight: 200,
      maxWidth: 200,
    );
    setState(() {
      imageFile = pickedFile;
    });
  }

  Future<void> updateFunc() async {
    setState(() {
      isLoading = true;
    });

    final appurl = dotenv.env["appurl"];
    //get form data
    final bday = dateinput.text.split("-");
    final fname = fnamecontroller.text;
    final dobYear = int.parse(bday[0]);
    final dobMonth = int.parse(bday[1]);
    final dobDay = int.parse(bday[2]);
    final about = aboutmecontroller.text;
    if ((isEdit == false && gender == null) ||
        (isEdit == false && genderInterest == null)) {
      showFailureMessage("Please select your gender/Interest");
    } else {
      final body = {
        "first_name": fname,
        "dob_day": dobDay,
        "dob_month": dobMonth,
        "dob_year": dobYear,
        "gender_identity": gender,
        "gender_interest": genderInterest,
        "about": about,
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
