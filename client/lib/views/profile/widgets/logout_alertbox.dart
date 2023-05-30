import 'dart:convert';
import 'package:online_matchmaking_system/services/network_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_matchmaking_system/utils/api.dart';
import 'package:online_matchmaking_system/utils/routesname.dart';
import 'package:online_matchmaking_system/views/loginpage/login.dart';
import 'package:http/http.dart' as http;

class DialogBox extends StatefulWidget {
  const DialogBox({super.key});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Do you want to logout?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "No",
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: logoutFunc,
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }

  Future<void> logoutFunc() async {
    const appurl = Api.appurl;

    var refresh = await NetworkHandler.getValue('refresh');
    print(refresh);
    final body = {
      'tokenrefresh': refresh,
    };

    const url = "$appurl/auth/logout";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {"Content-type": "application/json"},
    );
    if (response.statusCode == 204) {
      await NetworkHandler.deleteAll();
      Navigator.pushNamed(context, RoutesName.login);
    }
  }
}
