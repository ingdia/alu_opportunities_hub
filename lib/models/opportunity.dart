class Opportunity {
  final String id;
  final String title;
  final String description;
  final String location;
  final String category;
  final DateTime deadline;
  final String author;
  final int likes;
  final bool isLiked;

  Opportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.deadline,
    required this.author,
    required this.likes,
    this.isLiked = false,
  });
}
