import 'package:flutter/material.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';

class SelectCardWidget extends StatelessWidget {
  final bool isSelected;
  final Function() onTap;
  final String title;

  const SelectCardWidget({
    super.key,
    required this.isSelected,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: onTap,
        child: Card(
          color: isSelected ? AppColors.lineColor : Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                      isSelected ? AppColors.headerColor : AppColors.labelColor,
                ),
              ),
              if (isSelected) Icon(Icons.circle, size: 10),
            ],
          ),
        ),
      ),
    );
  }
}
