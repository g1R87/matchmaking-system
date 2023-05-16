// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import '../services/network_handler.dart';
// import '../views/addphoto/addphoto.dart';
// import '../views/userdetails/user_details.dart';

// Future<void> refressSession() async {
//   final appurl = dotenv.env["appurl"];
//   var refresh = await NetworkHandler.getValue('refresh');
//   print(refresh);
//   final body = {
//     'tokenrefresh': refresh,
//   };

//   final url = "$appurl/auth/refresh";
//   final uri = Uri.parse(url);
//   final response = await http.post(
//     uri,
//     body: jsonEncode(body),
//     headers: {"Content-type": "application/json"},
//   );
//   var responseData = jsonDecode(response.body);
//   if (response.statusCode == 200) {
//     await NetworkHandler.storeValue("token", responseData["token"]);
//     await NetworkHandler.storeValue("userId", responseData["userId"]);
//     if (!responseData["isUpdated"]) {
//       Navigator.of(context)
//           .pushReplacement(MaterialPageRoute(builder: (context) {
//         return const DetailsPage();
//       }));
//     } else {
//       Navigator.of(context)
//           .pushReplacement(MaterialPageRoute(builder: (context) {
//         return const MultipleImageSelector();
//       }));
//     }
//   } else {
//     showFailureMessage("Session has expired, Please login");
//   }
// }

// void showSuccessMessage(String message) {
//   final snackBar = SnackBar(content: Text(message));
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }

// void showFailureMessage(String message) {
//   final snackBar = SnackBar(
//     backgroundColor: Colors.red,
//     content: Text(
//       message,
//       style: const TextStyle(
//         color: Colors.white,
//       ),
//     ),
//   );
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
