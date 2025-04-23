import 'dart:convert';

List<Album> albumFromJson(String str) =>
    List<Album>.from(json.decode(str).map((x) => Album.fromJson(x)));

String albumToJson(List<Album> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Album {
  int albumCardId;
  String userId;
  int cardId;

  Album({
    required this.albumCardId,
    required this.userId,
    required this.cardId,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        albumCardId: json["album_card_id"],
        userId: json["user_id"],
        cardId: json["card_id"],
      );

  Map<String, dynamic> toJson() => {
        "album_card_id": albumCardId,
        "user_id": userId,
        "card_id": cardId,
      };
}
