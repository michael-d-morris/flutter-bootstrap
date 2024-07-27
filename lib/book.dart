class Book {
  String? id;
  String title;
  String author;
  String genre;
  int rating;
  bool isFinished;
  String imageLink;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.rating,
    required this.isFinished,
    required this.imageLink
  });
}