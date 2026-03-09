import 'package:flutter/material.dart';
import '../../../models/track.dart';

class CardInfo extends StatelessWidget {
  final Track track;

  const CardInfo({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    final genres = track.genre.take(4).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Title(track.title),
          _Artist(track.artist),

          const SizedBox(height: 10),

          _GenreList(genres),

          const SizedBox(height: 12),

          _Description(track.description),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _Artist extends StatelessWidget {
  final String text;

  const _Artist(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.white54));
  }
}

class _GenreList extends StatelessWidget {
  final List<String> genres;

  const _GenreList(this.genres);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Wrap(
        spacing: 8,
        runSpacing: 1,
        children: genres.map((g) => _GenreChip(g)).toList(),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String genre;

  const _GenreChip(this.genre);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(genre),
      backgroundColor: Colors.white10,
      labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
    );
  }
}

class _Description extends StatelessWidget {
  final String text;

  const _Description(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white54, fontSize: 13),
    );
  }
}
