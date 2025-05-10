import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoreBanner extends StatelessWidget {
  final String imageUrl;

  const StoreBanner({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 124,
        width: double.infinity,
        child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
