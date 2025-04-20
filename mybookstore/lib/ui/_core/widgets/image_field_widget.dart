import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';

/// A widget that allows the user to select an image from the gallery and
/// converts it to a base64 string.
class ImageFieldWidget extends StatefulWidget {
  final Function({required String imageBase64}) onChanged;
  final String hint;
  final String? initialValue;

  const ImageFieldWidget({
    required this.hint,
    required this.onChanged,
    this.initialValue,
    super.key,
  });

  @override
  State<ImageFieldWidget> createState() => _ImageFieldWidgetState();
}

class _ImageFieldWidgetState extends State<ImageFieldWidget> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            validator: (value) => null,
            readOnly: true,
            decoration: InputDecoration(
              fillColor: AppColors.backgroundColor,
              hintStyle: const TextStyle(color: AppColors.defaultColor),
              prefixIcon: IconButton(
                onPressed: () async {
                  final XFile? pickedImage = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (pickedImage != null) {
                    setState(() {
                      image = pickedImage;
                    });
                  }

                  if (image != null) {
                    final bytes = await image!.readAsBytes();
                    String imageBase64 = base64Encode(bytes);
                    widget.onChanged(imageBase64: imageBase64);
                  }
                },
                icon: Icon(
                  Icons.upload_outlined,
                  color: AppColors.defaultColor,
                ),
              ),
              border: border,
              enabledBorder: border,
              focusedBorder: border,
              hintText: image != null ? image!.name : widget.hint,
            ),
          ),
        ),
      ],
    );
  }
}

final OutlineInputBorder border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: BorderSide(color: AppColors.defaultColor),
);
