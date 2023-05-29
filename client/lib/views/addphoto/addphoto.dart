import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/utils/routesname.dart';

class MultipleImageSelector extends StatefulWidget {
  const MultipleImageSelector({Key? key}) : super(key: key);

  @override
  State<MultipleImageSelector> createState() => _MultipleImageSelectorState();
}

class _MultipleImageSelectorState extends State<MultipleImageSelector> {
  // List<File> selectedImages = [];
  // final picker = ImagePicker();
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  XFile? imagefile;
  final ImagePicker pickerr = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 150, 235, 152),
          title: const Text("Add Photos"),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Choose two photos",
                style: TextStyle(
                    fontSize: 18, color: Colors.black.withOpacity(0.7)),
              ),
              const SizedBox(
                height: 30,
              ),
              imageProfile(),
              const SizedBox(
                height: 20,
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.4,
              //   width: 300.0,
              //   child: selectedImages.isEmpty
              //       ? GestureDetector(
              //           onTap: () {
              //             getImages();
              //           },
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               imagebox(),
              //               const SizedBox(
              //                 width: 10,
              //               ),
              //               imagebox(),
              //               const SizedBox(
              //                 width: 10,
              //               ),
              //               imagebox(),
              //             ],
              //           ),
              //         )
              //       : GridView.builder(
              //           scrollDirection: Axis.vertical,
              //           itemCount: selectedImages.length,
              //           gridDelegate:
              //               const SliverGridDelegateWithFixedCrossAxisCount(
              //                   mainAxisSpacing: 20, crossAxisCount: 3),
              //           itemBuilder: (BuildContext context, int index) {
              //             return Center(
              //               child: kIsWeb
              //                   ? Container(
              //                       height: MediaQuery.of(context).size.height *
              //                           0.13,
              //                       width:
              //                           MediaQuery.of(context).size.width * 0.2,
              //                       decoration: BoxDecoration(
              //                           border: Border.all(width: 1)),
              //                       child: Image.network(
              //                         selectedImages[index].path,
              //                         fit: BoxFit.cover,
              //                       ))
              //                   : Container(
              //                       height: MediaQuery.of(context).size.height *
              //                           0.13,
              //                       width:
              //                           MediaQuery.of(context).size.width * 0.2,
              //                       decoration: BoxDecoration(
              //                           border: Border.all(width: 1)),
              //                       child: Image.file(
              //                         selectedImages[index],
              //                         fit: BoxFit.cover,
              //                       ),
              //                     ),
              //             );
              //           },
              //         ),
              // ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.05,
              // ),
              Center(
                child: SizedBox(
                  height: 45,
                  width: 280,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2B2C43),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35))),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, RoutesName.bottonNavBar);
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      )),
                ),
              ),
              SizedBox(
                height: getDeviceHeight(context) * 0.08,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: <Widget>[
              Container(
                height: 160,
                width: 90,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageFile == null
                          ? const AssetImage("images/pfp_default.jpg")
                              as ImageProvider
                          : FileImage(File(imageFile!.path)),
                      fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()));
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.teal,
                    size: 29,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Stack(
            children: <Widget>[
              Container(
                height: 160,
                width: 90,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imagefile == null
                          ? const AssetImage("images/pfp_default.jpg")
                              as ImageProvider
                          : FileImage(File(imagefile!.path)),
                      fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheett()));
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.teal,
                    size: 29,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Chose Pictures",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  chosePhoto(ImageSource.camera);
                },
                child: const Icon(Icons.camera, size: 40),
              ),
              TextButton(
                onPressed: () {
                  chosePhoto(ImageSource.gallery);
                },
                child: const Icon(Icons.image, size: 40),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget bottomSheett() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Chose Pictures",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  chosePhotoo(ImageSource.camera);
                },
                child: const Icon(Icons.camera, size: 40),
              ),
              TextButton(
                onPressed: () {
                  chosePhotoo(ImageSource.gallery);
                },
                child: const Icon(Icons.image, size: 40),
              )
            ],
          )
        ],
      ),
    );
  }

  void chosePhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(
      source: source,
      maxHeight: 200,
      maxWidth: 200,
    );
    setState(() {
      imageFile = pickedFile;
    });
  }

  void chosePhotoo(ImageSource source) async {
    final pickedfile = await picker.pickImage(
      source: source,
      maxHeight: 200,
      maxWidth: 200,
    );
    setState(() {
      imagefile = pickedfile;
    });
  }

  // Future getImages() async {
  //   final pickedFile = await picker.pickMultiImage(
  //       imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
  //   List<XFile> xfilePick = pickedFile;

  //   setState(
  //     () {
  //       if (xfilePick.isNotEmpty) {
  //         for (var i = 0; i < xfilePick.length; i++) {
  //           selectedImages.add(File(xfilePick[i].path));
  //         }
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('Nothing is selected')));
  //       }
  //     },
  //   );
  // }
}
