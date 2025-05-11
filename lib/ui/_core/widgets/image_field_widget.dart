import 'dart:typed_data';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';
import 'package:bookstore/ui/_core/widgets/custom_cached_image_network.dart';
import 'package:bookstore/ui/_core/widgets/loading_image_placeholder.dart';
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
  XFile? preview;

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
                            preview = XFile(pickedImage.path);
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  preview != null
                      ? FutureBuilder<Uint8List>(
                        future: preview!.readAsBytes(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: 54,
                              height: 54,
                            );
                          }

                          return LoadingImagePlaceholder();
                        },
                      )
                      : (widget.initialImageUrl != null
                          ? CustomCachedNetworkImage(
                            imageUrl: widget.initialImageUrl!,
                            width: 54,
                            height: 54,
                          )
                          : const SizedBox.shrink()),
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
