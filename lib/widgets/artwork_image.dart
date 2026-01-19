import 'package:flutter/material.dart';

class ArtworkImage extends StatelessWidget {
  final String? imageUrl;

  const ArtworkImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(
            imageUrl ?? '',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}