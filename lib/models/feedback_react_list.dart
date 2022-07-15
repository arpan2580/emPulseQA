// To parse this JSON data, do
//
//     final feedbackReactList = feedbackReactListFromJson(jsonString);

import 'dart:convert';

FeedbackReactList feedbackReactListFromJson(String str) => FeedbackReactList.fromJson(json.decode(str));

String feedbackReactListToJson(FeedbackReactList data) => json.encode(data.toJson());

class FeedbackReactList {
    FeedbackReactList({
        required this.userId,
        this.name,
        this.email,
        this.mobile,
        this.profileImage,
    });

    int userId;
    String? name;
    String? email;
    String? mobile;
    String? profileImage;

    factory FeedbackReactList.fromJson(Map<String, dynamic> json) => FeedbackReactList(
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        profileImage: json["profile_image"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "email": email,
        "mobile": mobile,
        "profile_image": profileImage,
    };
}
