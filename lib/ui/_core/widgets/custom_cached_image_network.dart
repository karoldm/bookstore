import 'package:bookstore/ui/_core/widgets/error_image_placeholder.dart';
import 'package:bookstore/ui/_core/widgets/loading_image_placeholder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      height: height,
      width: width,
      placeholder: (context, url) => const LoadingImagePlaceholder(),
      errorWidget: (context, url, error) => const ErrorImagePlaceholder(),
    );
  }
}
