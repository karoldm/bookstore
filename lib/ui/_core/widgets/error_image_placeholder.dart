import 'package:flutter/material.dart';

class ErrorImagePlaceholder extends StatelessWidget {
  final int size;
  const ErrorImagePlaceholder({super.key, this.size = 54});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.broken_image, color: Colors.grey);
  }
}
