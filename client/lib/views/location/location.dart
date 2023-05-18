// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String location = "Null, press button";
//   String Address = 'Search';

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     return await Geolocator.getCurrentPosition();
//   }

//   Future<void> getAddress(Position position) async {
//     List<Placemark> placemark =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     print(placemark);
//     Placemark place = placemark[0];
//     Address =
//         '${place.street},${place.subLocality},${place.locality},${place.postalCode},${place.country}';
//     setState(() {});
//   }

// // flutter.compileSdkVersion
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Loccation"),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             location,
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           const Text(
//             "Address",
//             style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('${Address}'),
//             ],
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Position position = await _determinePosition();
//               print(position.latitude);
//               location = 'Lat:${position.latitude},long:${position.longitude}';
//               getAddress(position);
//               setState(() {});
//             },
//             child: const Text("Get location"),
//           ),
//         ],
//       ),
//     );
//   }
// }
