import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/utils/api.dart';
import 'package:online_matchmaking_system/views/loginpage/login.dart';

import '../loginpage/widgets/loginbutton.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool passwordVisible = true;
  bool repasswordVisible = true;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordContoller = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passwordContoller.dispose();
    _repasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Sign up"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 150, 235, 152),
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
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: getDeviceWidth(context) * 0.07,
                      right: getDeviceWidth(context) * 0.07),
                  child: Container(
                    height: getDeviceHeight(context) * 0.32,
                    width: getDeviceWidth(context) * 0.5,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/renai.png'))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
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
                      controller: _userController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Password";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey[50],
                          filled: true,
                          prefixIcon: const Icon(Icons.email),
                          label: const Text("Email/Phone"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28))),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 30,
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
                      controller: _passwordContoller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Password";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.grey[50],
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        label: const Text("Create password"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28)),
                      ),
                      obscureText: passwordVisible,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 30,
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
                      controller: _repasswordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Password";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey[50],
                          filled: true,
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  repasswordVisible = !repasswordVisible;
                                });
                              },
                              icon: Icon(repasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          label: const Text("Re-enter password"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28))),
                      obscureText: repasswordVisible,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                        backgroundColor: const Color.fromRGBO(43, 45, 66, 1),
                      ),
                      onPressed: signupFunc,
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(
                  height: getDeviceHeight(context) * 0.08,
                ),
              ],
            ),
            Column(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                Login(),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signupFunc() async {
    const appurl = Api.appurl;

    //gettting data from form
    final email = _userController.text;
    final password = _passwordContoller.text;
    final conpas = _repasswordController.text;
    final body = {
      "email": email,
      "password": password,
      "confirmPassword": conpas,
    };
    //sending req
    final url = "$appurl/user/signup";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        "Content-type": "application/json",
      },
    );
    if (response.statusCode == 201) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ));
    } else {
      print("Not created");
    }
  }
}
