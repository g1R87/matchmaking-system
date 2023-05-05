import 'package:flutter/material.dart';

class Forgetpassword extends StatelessWidget {
  const Forgetpassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
