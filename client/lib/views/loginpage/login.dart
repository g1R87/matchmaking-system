import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/utils/api.dart';
import 'package:online_matchmaking_system/utils/routesname.dart';
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
    super.initState();
    refressSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Log in"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 150, 235, 152),
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
      ),
      body: Form(
        key: _key,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: getDeviceWidth(context) * 0.07,
                          right: getDeviceWidth(context) * 0.07),
                      child: Container(
                        height: getDeviceHeight(context) * 0.3,
                        width: getDeviceWidth(context) * 0.4,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/renai.png'))),
                      ),
                    ),
                    Email(emailController: _emailController),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 25,
                          left: getDeviceWidth(context) * 0.07,
                          right: getDeviceWidth(context) * 0.07),
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
                    SizedBox(
                      height: getDeviceHeight(context) * 0.05,
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
                        child: const Text(
                          "LOG IN",
                          style: TextStyle(color: Colors.white),
                        ),
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
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    Signupbutton(),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  Future<void> refressSession() async {
    const appurl = Api.appurl;
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
        if (!mounted) return;
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return const DetailsPage();
        }));
      } else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RoutesName.bottonNavBar);
      }
    } else {
      showFailureMessage("Session has expired, Please login");
    }
  }

  Future<void> loginFunc() async {
    const appurl = Api.appurl;

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
      await NetworkHandler.deleteOne("pfp");
      await NetworkHandler.storeValue("token", responseData["token"]);
      await NetworkHandler.storeValue("userId", responseData["userId"]);
      await NetworkHandler.storeValue("refresh", responseData["tokenrefresh"]);
      await NetworkHandler.storeValue("pfp", responseData["pfp"] ?? "");

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
