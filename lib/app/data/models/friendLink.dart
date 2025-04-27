import 'dart:convert';

List<FriendLink> friendLinkFromJson(String str) => List<FriendLink>.from(json.decode(str).map((x) => FriendLink.fromJson(x)));

String friendLinkToJson(List<FriendLink> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

enum Status { Pending, Linked, Canceled }

class FriendLink {
  String userId;
  String friendId;
  int friendLinkId;
  Status status;
  DateTime lastInteraction;

  FriendLink({
    required this.userId,
    required this.friendId,
    required this.friendLinkId,
    required this.status,
    required this.lastInteraction,
  });

  factory FriendLink.fromJson(Map<String, dynamic> json) => FriendLink(
    userId: json["user_id"],
    friendId: json["friend_id"],
    friendLinkId: json["friend_link_id"],
    status: Status.values.firstWhere((e) => e.toString() == 'Status.${json["status"]}'),
    lastInteraction: DateTime.parse(json["last_interaction"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "friend_id": friendId,
    "friend_link_id": friendLinkId,
    "status": status,
    "last_interaction": lastInteraction.toIso8601String(),
  };
}
