class CustomException implements Exception {
  final String message;

  CustomException([this.message = "Unknown error"]);

  @override
  String toString() =>
      message.replaceAll('DioException', '').replaceAll('[bad response]: ', '');
}
