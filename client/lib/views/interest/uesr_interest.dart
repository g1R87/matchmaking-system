import 'package:flutter/material.dart';
import 'package:online_matchmaking_system/services/network_handler.dart';
import 'package:online_matchmaking_system/views/addphoto/addphoto.dart';
import 'package:online_matchmaking_system/views/bottomNavBar/bottomnavbar.dart';

class InterestsPage extends StatefulWidget {
  final List<String>? interest;
  const InterestsPage({super.key, this.interest});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  NetworkHandler networkHandler = NetworkHandler();
  List<String> selectedInterests = [];
  bool isLoading = false;
  bool isEdit = false;

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  @override
  void initState() {
    var exInterest = widget.interest;
    if (exInterest != null) {
      isEdit = true;
      selectedInterests = [...exInterest];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Interests'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 150, 235, 152),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Select your interests:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Wrap(
            alignment: WrapAlignment.start,
            children: _buildInterestButtons(),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Selected Interests:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            children: selectedInterests.map((interest) {
              return Chip(
                label: Text(interest),
                onDeleted: () {
                  toggleInterest(interest);
                },
              );
            }).toList(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff2B2C43),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35))),
            onPressed: updateFunc,
            child: isLoading
                ? const CircularProgressIndicator()
                : Text(
                    selectedInterests.isNotEmpty ? "Continue" : "Skip",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInterestButtons() {
    //!max length of string = 8 characters
    final List<String> interests = [
      'Sports',
      'Music',
      'Art',
      'Reading',
      'Cooking',
      'Travel',
      'Photo',
      'Gardening',
      'Fashion',
      'Tech',
      'Fitness',
      'Movies',
      'Dancing',
      'Writing',
      'Pets',
    ];

    return interests.map((interest) {
      final bool isSelected = selectedInterests.contains(interest);

      return Container(
        width: MediaQuery.of(context).size.width / 4,
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10.0),
        child: ElevatedButton(
          onPressed: () {
            toggleInterest(interest);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? null : const Color(0xff2B2C43),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35))),
          child: Text(
            interest,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> updateFunc() async {
    setState(() {
      isLoading = true;
    });

    final body = {
      "interest": selectedInterests,
    };

    final response = await networkHandler.updateData("/user", body);
    if (response.statusCode == 200) {
      print("success");
    } else {
      print("fail");
    }
    if (!mounted) return;
    if (isEdit) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const MainPage(
              index: 3,
            );
          },
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const MultipleImageSelector();
          },
        ),
      );
    }
  }
}
