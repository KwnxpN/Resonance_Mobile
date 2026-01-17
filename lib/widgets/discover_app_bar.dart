import 'package:flutter/material.dart';

class DiscoverAppBar extends StatelessWidget {
  const DiscoverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.tune, color: Colors.white),
          Column(
            children: const [
              Text("Discover",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Text("NEARBY",
                  style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 10,
                      letterSpacing: 1)),
            ],
          ),
          const Icon(Icons.videocam, color: Colors.white),
        ],
      ),
    );
  }
}
