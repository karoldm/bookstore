import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';

class TextFieldWidget extends StatelessWidget {
  final String hint;
  final Function(String)? onChanged;
  final IconData? suffixIcon;
  final String? initialValue;
  final bool? digitsOnly;
  final int? maxLines;
  final TextEditingController? controller;
  final Function(String)? validator;

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
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      inputFormatters:
          digitsOnly == true ? [FilteringTextInputFormatter.digitsOnly] : [],
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
