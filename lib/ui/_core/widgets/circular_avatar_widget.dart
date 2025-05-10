import 'package:bookstore/ui/_core/icons/book_store_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/ui/_core/theme/app_colors.dart';

final iconsAvatar = [
  BookStoreIcons.cat_1,
  BookStoreIcons.cat_2,
  BookStoreIcons.cat_3,
  BookStoreIcons.cat_4,
  BookStoreIcons.cat_5,
  BookStoreIcons.cat_6,
  BookStoreIcons.cat_7,
  BookStoreIcons.cat_8,
  BookStoreIcons.cat_9,
];

class CircleAvatarWidget extends StatelessWidget {
  final String? name;
  final double iconSize;

  const CircleAvatarWidget({super.key, this.name, this.iconSize = 80});

  @override
  Widget build(BuildContext context) {
    int index =
        name == null || name!.trim() == ""
            ? 0
            : name!
                    .trim()
                    .split("")
                    .map((e) {
                      return e.codeUnitAt(0);
                    })
                    .reduce((a, b) => a + b) %
                iconsAvatar.length;

    return Container(
      padding: EdgeInsets.all(0.3 * iconSize),
      decoration: BoxDecoration(
        color: AppColors.inputColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconsAvatar[index],
        size: iconSize,
        color: AppColors.defaultColor,
      ),
    );
  }
}
