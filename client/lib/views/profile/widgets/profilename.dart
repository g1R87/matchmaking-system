import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/services/models/user_model.dart';
import 'package:online_matchmaking_system/shared_data/device_size.dart';
import 'package:online_matchmaking_system/views/profile/profile.dart';

class Profilename extends StatefulWidget {
  const Profilename({
    super.key,
  });

  @override
  State<Profilename> createState() => _ProfilenameState();
}

class _ProfilenameState extends State<Profilename> {
  List<UserModel>? userdata;
  bool isLoaded = false;
  getprofiledata() async {
    userdata = await profileFetch();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getprofiledata();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              builder: (BuildContext context) {
                return Container(
                    height: 180,
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(20))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Container(
                          height: 7,
                          width: 45,
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        SizedBox(
                          height: getDeviceHeight(context) * 0.01,
                        ),
                        const Expanded(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                            ),
                            title: Text("Rohan_mustafa"),
                            trailing: CircleAvatar(
                              radius: 10,
                              backgroundColor: Color.fromARGB(255, 15, 244, 23),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.black54,
                              ),
                            ),
                            title: Text("Add account"),
                          ),
                        ),
                      ],
                    ));
              });
        },
        child: Visibility(
          child: ListView.builder(
            itemCount: userdata?.length,
            itemBuilder: (context, index) {
              return Row(
                children: [Text(userdata![index].id ?? "")],
              );
            },
          ),
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
