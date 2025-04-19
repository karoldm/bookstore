import 'package:flutter/material.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';

AppBar appBarWidget({
  required BuildContext context,
  String? title,
}) {
  return AppBar(
    title: Text(
      title ?? '',
    ),
    leading: IconButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.defaultColor,
        shape: const CircleBorder(),
      ),
      icon: const Icon(
        Icons.arrow_back_ios,
        size: 16,
        color: AppColors.backgroundColor,
      ),
      onPressed: () {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
    ),
  );
}
