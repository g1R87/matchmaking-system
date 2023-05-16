import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';

class Email extends StatelessWidget {
  const Email({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: getDeviceHeight(context) * 0.03,
          left: getDeviceWidth(context) * 0.07,
          right: getDeviceWidth(context) * 0.07),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black38, blurRadius: 11, offset: Offset(0, 7))
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
          ),
        ),
      ),
    );
  }
}
