import 'package:bookstore/ui/_core/widgets/custom_cached_image_network.dart';
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
        child: CustomCachedNetworkImage(imageUrl: imageUrl),
      ),
    );
  }
}
