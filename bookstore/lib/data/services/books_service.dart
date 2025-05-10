import 'package:bookstore/data/exceptions/custom_exception.dart';
import 'package:dio/dio.dart';
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
    int? page,
    int? size,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await apiClient.api.get(
        '/v1/store/$storeId/book',
        queryParameters: {'page': page ?? 0, 'size': size ?? 10, ...?filters},
      );
      return (response.data as List)
          .map((book) => BookModel.fromMap(book))
          .toList();
    } catch (e) {
      debugPrint('Failed to load books in service: $e');
      throw CustomException(e.toString());
    }
  }

  @override
  Future<BookModel> createBook(int storeId, RequestBookModel book) async {
    try {
      final formData = FormData.fromMap({
        'title': book.title,
        'author': book.author,
        'releasedAt': book.releasedAt,
        'summary': book.summary,
        'available': book.available,
        'rating': book.rating,
      });

      if (book.cover != null) {
        final fileData = await book.cover!.readAsBytes();

        formData.files.add(
          MapEntry(
            "cover",
            MultipartFile.fromBytes(
              fileData,
              filename: 'cover_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          ),
        );
      }

      final response = await apiClient.api.post(
        '/v1/store/$storeId/book',
        options: Options(contentType: 'multipart/form-data'),
        data: formData,
      );
      return BookModel.fromMap(response.data);
    } catch (e) {
      debugPrint('Failed to create book in service: $e');
      throw CustomException(e.toString());
    }
  }

  @override
  Future<void> deleteBook(int storeId, int bookId) async {
    try {
      await apiClient.api.delete('/v1/store/$storeId/book/$bookId');
    } catch (e) {
      debugPrint('Failed to delete book in service: $e');
      throw CustomException(e.toString());
    }
  }

  @override
  Future<BookModel> updateBook(
    int storeId,
    int bookId,
    RequestBookModel book,
  ) async {
    try {
      final formData = FormData.fromMap({
        'title': book.title,
        'author': book.author,
        'releasedAt': book.releasedAt,
        'summary': book.summary,
        'available': book.available,
        'rating': book.rating,
      });

      if (book.cover != null) {
        final fileData = await book.cover!.readAsBytes();

        formData.files.add(
          MapEntry(
            "cover",
            MultipartFile.fromBytes(
              fileData,
              filename: 'cover_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          ),
        );
      }

      final response = await apiClient.api.put(
        '/v1/store/$storeId/book/$bookId',
        options: Options(contentType: 'multipart/form-data'),
        data: formData,
      );

      return BookModel.fromMap(response.data);
    } catch (e) {
      debugPrint('Failed to update book in service: $e');
      throw CustomException(e.toString());
    }
  }

  @override
  Future<BookModel> updateBookavailable(
    int storeId,
    int bookId,
    bool available,
  ) async {
    try {
      final response = await apiClient.api.put(
        '/v1/store/$storeId/book/$bookId/available',
        data: {'available': available},
      );

      return BookModel.fromMap(response.data);
    } catch (e) {
      debugPrint('Failed to update book in service: $e');
      throw CustomException(e.toString());
    }
  }
}
