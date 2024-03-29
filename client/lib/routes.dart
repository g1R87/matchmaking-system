import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/utils/routesname.dart';
import 'package:online_matchmaking_system/views/addphoto/addphoto.dart';
import 'package:online_matchmaking_system/views/bottomNavBar/bottomnavbar.dart';
import 'package:online_matchmaking_system/views/homepage/homepage.dart';
import 'package:online_matchmaking_system/views/loginpage/login.dart';
import 'package:online_matchmaking_system/views/signup_page/signup.dart';
import 'package:online_matchmaking_system/views/splashscreen/splashscreen.dart';
import 'package:online_matchmaking_system/views/userdetails/user_details.dart';

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
      case RoutesName.detail:
        return MaterialPageRoute(
          builder: (context) => const DetailsPage(),
        );
      case RoutesName.addphoto:
        return MaterialPageRoute(
          builder: (context) => const MultipleImageSelector(),
        );
      case RoutesName.signup:
        return MaterialPageRoute(
          builder: (context) => const Signup(),
        );
      case RoutesName.homepage:
        return MaterialPageRoute(
          builder: (context) => const ShowingPage(),
        );
      case RoutesName.bottonNavBar:
        return MaterialPageRoute(
          builder: (context) => const MainPage(),
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
