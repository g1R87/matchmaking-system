import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/pages/signup.dart';
import 'package:http/http.dart' as http;

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
                height: 80 * 4,
                width: 120 * 4,
                decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('images/renai.png'))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
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
                      return "Enter your Emailid";
                    } else {
                      return null;
                    }
                  },
                  controller: _emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[50],
                    filled: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.email),
                    ),
                    label: const Text("Email/Phone"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28)),
                  ),
                ),
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "forget password??",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  "OR",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("images/facebook.png"))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("images/google.png"))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("images/twitter.png"))),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 3,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return const Signup();
                    }));
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  Future<void> loginFunc() async {
    //gettting data from form
    final email = _emailController.text;
    final password = _passwordController.text;
    final body = {
      "email": email,
      "password": password,
    };
    //sending req
    const url = "http://172.22.210.245:5300/user/login";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {"Content-type": "application/json"},
    );
    if (response.statusCode == 200) {
      showSuccessMessage("nice!");
    } else {
      showFailureMessage("wtf?");
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
