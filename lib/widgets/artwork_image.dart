import 'package:flutter/material.dart';

class ArtworkImage extends StatelessWidget {
  final String? imageUrl;

  const ArtworkImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final hasValidImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: hasValidImage ? null : Colors.grey[800],
        image: hasValidImage
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: hasValidImage
          ? null
          : const Center(
              child: Icon(Icons.music_note, size: 64, color: Colors.white54),
            ),
    );
  }
}
