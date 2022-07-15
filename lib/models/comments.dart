// To parse this JSON data, do
//
//     final comments = commentsFromJson(jsonString);

import 'dart:convert';

import 'package:empulse/models/feedback_model.dart';

AddCommentsModel commentsFromJson(String str) =>
    AddCommentsModel.fromJson(json.decode(str));

String commentsToJson(AddCommentsModel data) => json.encode(data.toJson());

class AddCommentsModel {
  AddCommentsModel({
    this.name,
    this.email,
    this.commentId,
    this.feedbackId,
    this.userId,
    required this.usercomment,
    this.images,
    this.children,
    this.type,
    this.parent,
    this.repliedId,
    this.profileImage,
    this.file1,
    this.file2,
    this.file3,
    this.created,
  });

  String? name;
  String? email;
  int? commentId;
  String? feedbackId;
  String? userId;
  String usercomment;
  // List<dynamic>? images;
  Images? images;
  List<dynamic>? children;
  int? parent;
  int? repliedId;
  String? type;
  String? profileImage;
  String? file1;
  String? file2;
  String? file3;
  String? created;

  factory AddCommentsModel.fromJson(Map<String, dynamic> json) =>
      AddCommentsModel(
        name: json["name"],
        email: json["email"],
        commentId: json["comment_id"],
        feedbackId: json["feedback_id"],
        userId: json["user_id"],
        usercomment: json["comment"],
        parent: json["parent"],
        // images: List<dynamic>.from(json["images"].map((x) => x)),
        images: json["images"] != null ? Images.fromJson(json["images"]) : null,
        children: List<dynamic>.from(json["children"].map((x) => x)),
        type: json['type'],
        profileImage: json['profile_image'],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "feedback_id": feedbackId,
        "user_id": userId,
        "comment": usercomment,
        "type": type,
        "parent": parent,
        "replied_id": repliedId,
        "profile_image": profileImage,
        // "images": List<dynamic>.from(images.map((x) => x)),
        // "children": List<dynamic>.from(children!.map((x) => x)),
      };
}
