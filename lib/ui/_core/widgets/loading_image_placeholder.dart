import 'package:flutter/material.dart';

class LoadingImagePlaceholder extends StatelessWidget {
  const LoadingImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
