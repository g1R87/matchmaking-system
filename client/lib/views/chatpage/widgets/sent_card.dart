import 'package:flutter/material.dart';

class SendMessageCard extends StatelessWidget {
  const SendMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 55,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: const Color(0xFF00a2c9),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 40, top: 5, bottom: 20),
                child: Text(
                  "asdfasd",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      "time",
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
