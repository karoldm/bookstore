import 'package:flutter/material.dart';

class PasswordFielWidget extends StatefulWidget {
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final String? hint;

  const PasswordFielWidget({
    super.key,
    this.hint,
    required this.onChanged,
    this.validator,
  });

  @override
  State<PasswordFielWidget> createState() => _PasswordFielWidgetState();
}

class _PasswordFielWidgetState extends State<PasswordFielWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hint ?? "Senha",
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      obscureText: _obscureText,
      enableSuggestions: false,
      autocorrect: false,
      validator: (value) {
        if (value == null) return null;

        if (widget.validator != null) {
          return widget.validator!(value);
        }

        if (value.length < 8) {
          return "A senha deve ter mais de 8 caracteres";
        }

        return null;
      },
    );
  }
}
