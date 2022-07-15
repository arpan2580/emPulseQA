import 'dart:convert';

ShowCommentModel commentModelFromJson(String str) =>
    ShowCommentModel.fromJson(json.decode(str));

String commentModelToJson(ShowCommentModel data) => json.encode(data.toJson());

class ShowCommentModel {
  ShowCommentModel({
    required this.feedbackId,
  });

  String feedbackId;

  factory ShowCommentModel.fromJson(Map<String, dynamic> json) => ShowCommentModel(
        feedbackId: json["feedback_id"],
      );

  Map<String, dynamic> toJson() => {
        "feedback_id": feedbackId,
      };
}
