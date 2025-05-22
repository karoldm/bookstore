import 'package:bookstore/ui/_core/widgets/custom_cached_image_network.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/data/models/book_model.dart';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';

class BookCardWidget extends StatelessWidget {
  final BookModel book;
  final Function(BookModel book) onTap;

  const BookCardWidget({required this.book, super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 215,
      child: InkWell(
        onTap: () {
          onTap(book);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            book.cover != null && book.cover!.isNotEmpty
                ? CustomCachedNetworkImage(imageUrl: book.cover!, height: 228)
                : Image.asset(
                  "assets/book_default.png",
                  height: 228,
                  fit: BoxFit.cover,
                ),

            Text(
              book.title,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.labelFont,
            ),
            Text(
              book.author,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.bodySmallMediumFont,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                spacing: 4,
                children: [
                  Icon(Icons.star_outline),
                  Text(book.rating.toStringAsFixed(1).replaceAll('.', ',')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
