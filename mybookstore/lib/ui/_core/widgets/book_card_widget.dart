import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/ui/books/book_detail_screen.dart';

class BookCardWidget extends StatelessWidget {
  final BookModel book;

  const BookCardWidget({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 172,
      height: 215,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailScreen(book: book),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            book.cover != null && book.cover!.isNotEmpty
                ? Image.memory(
                  base64Decode(book.cover!),
                  width: 172,
                  height: 215,
                )
                : Image.asset(
                  "assets/book_default.png",
                  width: 172,
                  height: 215,
                ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(book.title, overflow: TextOverflow.ellipsis),
                Text(book.author, overflow: TextOverflow.ellipsis),
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
