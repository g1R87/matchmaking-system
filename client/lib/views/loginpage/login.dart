import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/views/addphoto/addphoto.dart';
import 'package:online_matchmaking_system/views/loginpage/widgets/email.dart';
import 'package:online_matchmaking_system/views/loginpage/widgets/forget_password.dart';
import 'package:online_matchmaking_system/views/loginpage/widgets/signup_button.dart';
import 'package:online_matchmaking_system/views/userdetails/user_details.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = true;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refressSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
              child: Container(
                height: 75 * 3,
                width: 120 * 3,
                decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('images/renai.png'))),
              ),
            ),
            Email(emailController: _emailController),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black38,
                          blurRadius: 11,
                          offset: Offset(0, 7))
                    ]),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your Password";
                    } else {
                      return null;
                    }
                  },
                  controller: _passwordController,
                  decoration: InputDecoration(
                      fillColor: Colors.grey[50],
                      filled: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.password),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off)),
                      ),
                      label: const Text("Password"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28))),
                  obscureText: passwordVisible,
                ),
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.86,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2B2D42),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28))),
                onPressed: loginFunc,
                child: const Text("LOG IN"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Forgetpassword(),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: getDeviceHeight(context) * 0.08,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.black,
              ),
            ),
            const Signupbutton()
          ]),
        ),
      ),
    );
  }

  Future<void> refressSession() async {
    final appurl = dotenv.env["appurl"];
    var refresh = await NetworkHandler.getValue('refresh');
    print(refresh);
    final body = {
      'tokenrefresh': refresh,
    };

    final url = "$appurl/auth/refresh";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {"Content-type": "application/json"},
    );
    var responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await NetworkHandler.storeValue("token", responseData["token"]);
      await NetworkHandler.storeValue("userId", responseData["userId"]);
      if (!responseData["isUpdated"]) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return const DetailsPage();
        }));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return const MultipleImageSelector();
        }));
      }
    } else {
      showFailureMessage("Session has expired, Please login");
    }
  }

  Future<void> loginFunc() async {
    final appurl = dotenv.env["appurl"];

    //gettting data from form
    final email = _emailController.text;
    final password = _passwordController.text;
    final body = {
      "email": email,
      "password": password,
    };
    //sending req
    final url = "$appurl/auth/login";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {"Content-type": "application/json"},
    );
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await NetworkHandler.storeValue("token", responseData["token"]);
      await NetworkHandler.storeValue("userId", responseData["userId"]);
      await NetworkHandler.storeValue("refresh", responseData["tokenrefresh"]);
      if (!responseData["isUpdated"]) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return const DetailsPage();
        }));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return const MultipleImageSelector();
        }));
      }
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
