
import 'package:flutter/material.dart';

class PasswordFielWidget extends StatefulWidget {
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final String? hint;

  const PasswordFielWidget({super.key, this.hint, required this.onChanged, this.validator});
  

  @override
  State<PasswordFielWidget> createState() => _PasswordFielWidgetState();
}

class _PasswordFielWidgetState extends State<PasswordFielWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      decoration: InputDecoration(hintText: widget.hint ?? "Senha", suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off), 
      )), 
      obscureText: _obscureText,
      enableSuggestions: false,
      autocorrect: false,
      validator: (value) {
        if(value == null) return null;

        if (widget.validator != null) {
          return widget.validator!(value);
        }

        if (value.length < 6) {
          return "A senha deve ter mais de 6 caracteres";
        }
        if (value.length > 10) {
          return "A senha deve ter no menos de 10 caracteres";
        }
        if (!RegExp(r'[A-Z]').hasMatch(value)) {
          return "A senha deve conter pelo menos uma letra maiúscula";
        }
        if(!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
          return "A senha deve conter pelo menos um caractere especial";
        }
        return null;
      },
    );
  }
}