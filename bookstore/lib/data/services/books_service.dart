import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bookstore/data/api/api.dart';
import 'package:bookstore/data/models/book_model.dart';
import 'package:bookstore/data/models/request_book_model.dart';
import 'package:bookstore/interfaces/services/books_service_interface.dart';

class BooksService implements BooksServiceInterface {
  final Api apiClient = Api();

  @override
  Future<List<BookModel>> fetchBooks(
    int storeId, {
    int? offset,
    int? limit,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await apiClient.api.get(
        '/v1/store/$storeId/book',
        queryParameters: {
          'offset': offset ?? 0,
          'limit': limit ?? 10,
          ...?filters,
        },
      );
      return (response.data as List)
          .map((book) => BookModel.fromMap(book))
          .toList();
    } catch (e) {
      debugPrint('Failed to load books on repository: $e');
      rethrow;
    }
  }

  @override
  Future<BookModel> createBook(int storeId, RequestBookModel book) async {
    try {
      final response = await apiClient.api.post(
        '/v1/store/$storeId/book',
        data: jsonEncode(book.toMap()),
      );
      return BookModel.fromMap(response.data);
    } catch (e) {
      debugPrint('Failed to create book on repository: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteBook(int storeId, int bookId) async {
    try {
      await apiClient.api.delete('/v1/store/$storeId/book/$bookId');
    } catch (e) {
      debugPrint('Failed to delete book on repository: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateBook(
    int storeId,
    int bookId,
    RequestBookModel book,
  ) async {
    try {
      await apiClient.api.put(
        '/v1/store/$storeId/book/$bookId',
        data: jsonEncode(book.toMap()),
      );
    } catch (e) {
      debugPrint('Failed to update book on repository: $e');
      rethrow;
    }
  }
}
