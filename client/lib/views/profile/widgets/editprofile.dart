import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/views/userdetails/user_details.dart';

class Editprofile extends StatelessWidget {
  const Editprofile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const DetailsPage(),
            )),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                  child: Text(
                "Edit Profile",
                style: TextStyle(fontWeight: FontWeight.w500),
              )),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)),
            child: const Center(
                child: Text(
              "Share profile",
              style: TextStyle(fontWeight: FontWeight.w500),
            )),
          ),
        ),
      ],
    );
  }
}
