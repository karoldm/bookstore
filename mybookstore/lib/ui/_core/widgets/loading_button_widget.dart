import 'package:flutter/material.dart';

class LoadingButtonWidget extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final VoidCallback? onPressed;

  const LoadingButtonWidget({
    super.key,
    required this.isLoading,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child:
          isLoading
              ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
              : child,
    );
  }
}
