import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.notificationId,
    required this.feedbackId,
    required this.message,
    required this.fromUserId,
    required this.name,
    required this.email,
    this.profileImage,
    required this.status,
    required this.type,
    required this.created,
  });

  String? notificationId;
  String feedbackId;
  String message;
  String fromUserId;
  String name;
  String email;
  String? profileImage;
  String status;
  String type;
  String created;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        notificationId: json["notification_id"].toString(),
        feedbackId: json["feedback_id"],
        message: json["message"],
        fromUserId: json["from_user_id"],
        name: json["name"],
        email: json["email"],
        profileImage: json["profile_image"],
        status: json["status"],
        type: json["type"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "feedback_id": feedbackId,
        "message": message,
      };
}
