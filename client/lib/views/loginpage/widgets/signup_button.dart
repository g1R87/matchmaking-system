import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/utils/routesname.dart';
import 'package:online_matchmaking_system/views/signup_page/signup.dart';

class Signupbutton extends StatelessWidget {
  const Signupbutton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
            Navigator.pushNamed(context, RoutesName.signup);
            // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            //   return const Signup();
            // }));
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
    );
  }
}
