import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/utils/routesname.dart';
import 'package:online_matchmaking_system/views/loginpage/login.dart';
import 'package:online_matchmaking_system/views/signup_page/signup.dart';
import 'package:online_matchmaking_system/views/splashscreen/splashscreen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case RoutesName.login:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );

      case RoutesName.signup:
        return MaterialPageRoute(
          builder: (context) => const Signup(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text("No routes defined")),
          ),
        );
    }
  }
}
