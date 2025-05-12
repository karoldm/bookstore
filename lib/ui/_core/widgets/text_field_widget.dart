import 'package:flutter/material.dart';
import 'package:bookstore/ui/_core/theme/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final String hint;
  final Function(String)? onChanged;
  final IconData? suffixIcon;
  final String? initialValue;
  final bool? digitsOnly;
  final int? maxLines;
  final TextEditingController? controller;
  final Function(String)? validator;
  final int? maxLength;

  const TextFieldWidget({
    super.key,
    required this.hint,
    this.onChanged,
    this.suffixIcon,
    this.initialValue,
    this.digitsOnly,
    this.maxLines,
    this.controller,
    this.validator,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      enableSuggestions: true,
      autocorrect: true,
      maxLines: maxLines,
      keyboardType:
          digitsOnly == true ? TextInputType.number : TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: Icon(suffixIcon, color: AppColors.labelColor),
      ),
      initialValue: initialValue,
      onChanged: onChanged,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Campo obrigatório";
        }
        if (validator != null) {
          return validator!(value);
        }
        return null;
      },
    );
  }
}
