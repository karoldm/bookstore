import 'package:flutter/material.dart';
import 'package:bookstore/ui/_core/theme/app_colors.dart';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';

AppBar appBarWidget({required BuildContext context, String? title}) {
  return AppBar(
    title: Text(title ?? '', style: AppFonts.subtitleFontBold),
    leading: IconButton(
      alignment: Alignment.centerRight,
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
