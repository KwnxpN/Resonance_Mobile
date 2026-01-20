import 'package:flutter/material.dart';

class MusicTasteResult extends StatelessWidget {
  final Map<String, int> genreCounter;

  const MusicTasteResult({
    super.key,
    required this.genreCounter,
  });

  @override
  Widget build(BuildContext context) {
    final sortedGenres = genreCounter.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Music Taste',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          ...sortedGenres.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                '${entry.key} : ${entry.value}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
