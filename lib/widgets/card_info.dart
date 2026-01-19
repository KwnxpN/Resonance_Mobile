import 'package:flutter/material.dart';
import '../models/track.dart';

class CardInfo extends StatelessWidget {
  final Track track;

  const CardInfo({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(track.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          Text(track.artist,
              style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: track.genre
                .map((genre) => Chip(
                      label: Text(genre),
                      backgroundColor: Colors.white10,
                      labelStyle:
                          const TextStyle(color: Colors.white, fontSize: 12),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Text(track.description,
              style: const TextStyle(color: Colors.white54, fontSize: 13)),
        ],
      ),
    );
  }
}
