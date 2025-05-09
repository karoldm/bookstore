import 'dart:io';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bookstore/ui/_core/theme/app_colors.dart';

class ImageFieldWidget extends StatefulWidget {
  final Function({required XFile? imageData}) onChanged;
  final String hint;
  final String? initialImageUrl;
  final bool? canDelete;

  const ImageFieldWidget({
    required this.hint,
    required this.onChanged,
    super.key,
    this.initialImageUrl,
    this.canDelete = true,
  });

  @override
  State<ImageFieldWidget> createState() => _ImageFieldWidgetState();
}

class _ImageFieldWidgetState extends State<ImageFieldWidget> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  File? preview;

  bool _error = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          spacing: 8,
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
                        int size = await pickedImage.length();
                        if (size > 10 * 1024 * 1024) {
                          setState(() {
                            _error = true;
                          });
                          return;
                        } else {
                          setState(() {
                            _error = false;
                            image = pickedImage;
                            preview = File(pickedImage.path);
                          });
                        }
                      }

                      if (image != null) {
                        widget.onChanged(imageData: image);
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
                  hintText:
                      image != null
                          ? image!.name
                          : (widget.initialImageUrl ?? widget.hint),
                ),
              ),
            ),
            Center(
              child:
                  preview != null
                      ? Image(
                        fit: BoxFit.cover,
                        image: FileImage(preview!) as ImageProvider,
                        width: 54,
                        height: 54,
                      )
                      : (widget.initialImageUrl != null
                          ? CachedNetworkImage(
                            imageUrl: widget.initialImageUrl!,
                            fit: BoxFit.cover,
                            width: 54,
                            height: 54,
                          )
                          : SizedBox.shrink()),
            ),
            if (widget.canDelete == true)
              InkWell(
                onTap: () {
                  setState(() {
                    image = null;
                    preview = null;
                  });
                  widget.onChanged(imageData: null);
                },
                child: Icon(Icons.delete),
              ),
          ],
        ),
        Text(
          "Tamanho máximo: 10MB",
          style: AppFonts.bodySmallFont.copyWith(
            color: _error ? AppColors.errorColor : AppColors.defaultColor,
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
