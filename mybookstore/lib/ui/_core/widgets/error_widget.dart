import 'package:flutter/material.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
import 'package:mybookstore/ui/_core/widgets/app_bar_widget.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context: context),
      body: Column(
        spacing: 32,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.error, size: 100, color: AppColors.defaultColor),
          const Text(
            'Ocorreu um erro inesperado.',
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.canPop(context)
                  ? Navigator.pop(context)
                  : Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/home",
                    (route) => false,
                  );
            },
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
