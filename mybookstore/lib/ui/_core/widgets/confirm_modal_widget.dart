import 'package:flutter/material.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';

class ConfirmModalWidget extends StatelessWidget {
  final Function()? onConfirm;
  final String label;

  const ConfirmModalWidget({super.key, this.onConfirm, required this.label});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.headerColor,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorColor,
            foregroundColor: AppColors.backgroundColor,
          ),
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            }
            Navigator.pop(context);
          },
          child: const Text("Confirmar"),
        ),
      ],
    );
  }
}
