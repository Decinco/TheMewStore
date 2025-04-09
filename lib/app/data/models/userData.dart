import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  String userId;
  dynamic userName;
  int rating;
  String userCode;
  String region;
  dynamic description;
  String email;

  UserData({
    required this.userId,
    required this.userName,
    required this.rating,
    required this.userCode,
    required this.region,
    required this.description,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    userId: json["user_id"],
    userName: json["user_name"],
    rating: json["rating"],
    userCode: json["user_code"],
    region: json["region"],
    description: json["description"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "user_name": userName,
    "rating": rating,
    "user_code": userCode,
    "region": region,
    "description": description,
    "email": email,
  };
}
