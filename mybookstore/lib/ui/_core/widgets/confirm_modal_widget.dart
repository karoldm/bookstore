import 'package:flutter/material.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
import 'package:mybookstore/ui/_core/theme/app_fonts.dart';

class ConfirmModalWidget extends StatelessWidget {
  final Function()? onConfirm;
  final String label;

  const ConfirmModalWidget({super.key, this.onConfirm, required this.label});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(32),
      title: Text(
        label,
        textAlign: TextAlign.center,
        style: AppFonts.labelFont.copyWith(fontSize: 18),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancelar",
            style: AppFonts.labelFont.copyWith(color: AppColors.defaultColor),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorColor,
          ),
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            }
            Navigator.pop(context);
          },
          child: Text(
            "Confirmar",
            style: AppFonts.labelFont.copyWith(
              color: AppColors.backgroundColor,
            ),
          ),
        ),
      ],
    );
  }
}
