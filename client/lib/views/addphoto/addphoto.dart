import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_matchmaking_system/functions/toastfunction.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/utils/api.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:online_matchmaking_system/views/bottomNavBar/bottomnavbar.dart';

class MultipleImageSelector extends StatefulWidget {
  final Map? detail;

  const MultipleImageSelector({super.key, this.detail});

  @override
  State<MultipleImageSelector> createState() => _MultipleImageSelectorState();
}

class _MultipleImageSelectorState extends State<MultipleImageSelector> {
  // List<File> selectedImages = [];
  // final picker = ImagePicker();
  final appurl = Api.appurl;
  XFile? imageFile1;
  final ImagePicker picker1 = ImagePicker();
  XFile? imageFile2;
  final ImagePicker picker2 = ImagePicker();
  NetworkHandler networkHandler = NetworkHandler();
  bool isEdit = false;
  bool isLoading = false;

  @override
  void initState() {
    final detail = widget.detail;
    if (detail != null) {
      isEdit = true;

      getImageXFileByUrl(detail);
    }
    super.initState();
  }

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
              Center(
                child: SizedBox(
                  height: 45,
                  width: 280,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2B2C43),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35))),
                      onPressed: updateFunc,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
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
                      image: imageFile1 == null
                          ? const AssetImage("images/pfp_default.jpg")
                              as ImageProvider
                          : FileImage(File(imageFile1!.path)),
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
                      image: imageFile2 == null
                          ? const AssetImage("images/pfp_default.jpg")
                              as ImageProvider
                          : FileImage(File(imageFile2!.path)),
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
    final pickedFile = await picker1.pickImage(
      source: source,
    );
    setState(() {
      imageFile1 = pickedFile;
    });
  }

  void chosePhotoo(ImageSource source) async {
    final pickedfile = await picker2.pickImage(
      source: source,
    );
    setState(() {
      imageFile2 = pickedfile;
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

  void getImageXFileByUrl(Map detail) async {
    final String img1 = detail["url2"];
    final String img2 = detail["url3"];
    if (img1.isNotEmpty) {
      var file1 =
          await DefaultCacheManager().getSingleFile("$appurl/image/$img1");
      setState(() {
        imageFile1 = XFile(file1.path);
      });
    }
    if (img2.isNotEmpty) {
      var file2 =
          await DefaultCacheManager().getSingleFile("$appurl/image/$img2");
      if (!mounted) return;
      setState(() {
        imageFile2 = XFile(file2.path);
      });
    }
  }

  Future<void> updateFunc() async {
    setState(() {
      isLoading = true;
    });
    if (imageFile1 == null || imageFile2 == null) {
      showToast("please upload image", "reject");
      setState(() {
        isLoading = false;
      });
    } else {
      final imageResponse1 = await networkHandler.uploadImage(
          "/image/upload/0", imageFile1!.path, "image");
      final imageResponse2 = await networkHandler.uploadImage(
          "/image/upload/1", imageFile2!.path, "image");
      if (imageResponse1.statusCode == 200 &&
          imageResponse2.statusCode == 200) {
        setState(() {
          isLoading = false;
        });

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return const MainPage(
                index: 3,
              );
            },
          ),
        );
      }
    }
  }
}
