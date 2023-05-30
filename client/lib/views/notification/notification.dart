import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_matchmaking_system/views/notification/widgets/RequestList.dart';

import '../../utils/routesname.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, RoutesName.bottonNavBar);
          },
          child: const Icon(Icons.arrow_back_ios_outlined),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.grey[50],
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: const Text(
          "Requests",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: const RequestList(),
    );
  }
}
