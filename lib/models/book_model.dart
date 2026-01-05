class BookModel {
  final String id;
  final String title;
  final String author;
  final int totalCopies;
  final int availableCopies;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.totalCopies,
    required this.availableCopies,
  });

  factory BookModel.fromMap(String id, Map<String, dynamic> data) {
    return BookModel(
      id: id,
      title: data['title'],
      author: data['author'],
      totalCopies: data['totalCopies'],
      availableCopies: data['availableCopies'],
    );
  }
}
