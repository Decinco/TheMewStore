import 'package:get/get.dart';

class Comment {
  final String user;
  final String text;
  final int rating;
  final DateTime createdAt;
  RxBool isFavorite;

  Comment({
    required this.user,
    required this.text,
    required this.rating,
    required this.createdAt,
    RxBool? isFavorite,
  }) : isFavorite = isFavorite ?? false.obs;

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      user: map['user_data']?['user_name'] ?? 'Anon',
      text: map['content'] ?? '',
      rating: map['rating'] ?? 0,
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toString()),
    );
  }
}
