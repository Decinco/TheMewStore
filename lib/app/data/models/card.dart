import 'dart:convert';

List<Card> cardFromJson(String str) => List<Card>.from(json.decode(str).map((x) => Card.fromJson(x)));

String cardToJson(List<Card> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Card {
  int cardId;
  String cardName;
  int numberInExpansion;
  String image;
  int expansionId;

  Card({
    required this.cardId,
    required this.cardName,
    required this.numberInExpansion,
    required this.image,
    required this.expansionId,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    cardId: json["card_id"],
    cardName: json["card_name"],
    numberInExpansion: json["number_in_expansion"],
    image: json["image"],
    expansionId: json["expansion_id"],
  );

  Map<String, dynamic> toJson() => {
    "card_id": cardId,
    "card_name": cardName,
    "number_in_expansion": numberInExpansion,
    "image": image,
    "expansion_id": expansionId,
  };
}
