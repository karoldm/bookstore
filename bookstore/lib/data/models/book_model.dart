class BookModel {
  final int id;
  String? cover;
  String title;
  String author;
  String releasedAt;
  String createdAt;
  String summary;
  bool available;
  int rating;
  bool isSaved = false;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.releasedAt,
    required this.createdAt,
    required this.summary,
    required this.available,
    required this.rating,
    this.cover,
  });

  factory BookModel.fromMap(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      cover: json['cover'],
      releasedAt: json['releasedAt'],
      createdAt: json['createdAt'],
      summary: json['summary'],
      available: json['available'],
      rating: json['rating'],
    );
  }

  @override
  String toString() {
    return 'BookModel(id: $id, title: $title, author: $author, cover: $cover, releasedAt: $releasedAt, summary: $summary, available: $available, rating: $rating)';
  }
}
