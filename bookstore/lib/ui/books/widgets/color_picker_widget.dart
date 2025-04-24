import 'package:bookstore/ui/_core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatefulWidget {
  final Function(Color color) onColorChanged;
  const ColorPickerWidget({super.key, required this.onColorChanged});

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  Color pickerColor = AppColors.defaultColor;
  Color currentColor = AppColors.defaultColor;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    widget.onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Selecionar cor'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: changeColor,
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Selecionar'),
                    onPressed: () {
                      setState(() => currentColor = pickerColor);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
        );
      },
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Selecionar cor'),
          CircleAvatar(backgroundColor: currentColor, radius: 8),
        ],
      ),
    );
  }
}
