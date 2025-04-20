import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';

class CircleAvatarWidget extends StatelessWidget {
  final String? image;
  final String? name;
  final double radius;

  const CircleAvatarWidget({
    super.key,
    this.image,
    this.name,
    this.radius = 64,
  });

  @override
  Widget build(BuildContext context) {
    final names = name?.split(" ");
    String content = "";
    if (names != null) {
      if (names.length > 1 && names[0].isNotEmpty && names[1].isNotEmpty) {
        content = names[0][0] + names[1][0];
      } else if (names.length == 1) {
        content = names[0].isEmpty ? "" : names[0][0];
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.defaultColor,
      backgroundImage: image != null ? MemoryImage(base64Decode(image!)) : null,
      child:
          image == null
              ? Text(
                content.toUpperCase(),
                style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontSize: radius * 0.5,
                ),
              )
              : null,
    );
  }
}
