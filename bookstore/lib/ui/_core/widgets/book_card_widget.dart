import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bookstore/data/models/book_model.dart';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';
import 'package:bookstore/ui/books/book_detail_screen.dart';

class BookCardWidget extends StatelessWidget {
  final BookModel book;
  final bool? onlySavedBooks;

  const BookCardWidget({required this.book, super.key, this.onlySavedBooks});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 215,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BookDetailScreen(
                    book: book,
                    onlySavedBooks: onlySavedBooks,
                  ),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            book.cover != null && book.cover!.isNotEmpty
                ? Image.memory(
                  base64Decode(book.cover!),
                  width: 150,
                  height: 215,
                )
                : Image.asset(
                  "assets/book_default.png",
                  width: 150,
                  height: 215,
                ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.star_outline),
                    Text(book.rating.toStringAsFixed(1).replaceAll('.', ',')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
