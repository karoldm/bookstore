class RequestBookModel {
  String? cover;
  String title;
  String author;
  int year;
  String synopsis;
  bool available;
  int rating;

  RequestBookModel({
    required this.title,
    required this.author,
    required this.year,
    required this.synopsis,
    required this.available,
    required this.rating,
    this.cover,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'cover': cover,
      'year': year,
      'synopsis': synopsis,
      'available': available,
      'rating': rating,
    };
  }

  factory RequestBookModel.empty() {
    return RequestBookModel(
      title: '',
      author: '',
      year: 0,
      synopsis: '',
      available: false,
      rating: 1,
      cover: null,
    );
  }

  @override
  String toString() {
    return 'RegisterBookModel(title: $title, author: $author, cover: $cover, year: $year, synopsis: $synopsis, available: $available, rating: $rating)';
  }
}
