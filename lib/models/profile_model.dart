import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    this.id,
    this.name,
    required this.email,
    this.mobile,
    this.profileImage,
    this.totalFeedbacks,
    this.pendingFeedbacks,
    this.openFeedbacks,
    this.closedFeedbacks,
    this.assignedFeedbacks,
    this.totalComments,
    this.totalLikes,
    this.bio,
    this.score,
  });

  dynamic id;
  String? name;
  String email;
  String? mobile;
  String? profileImage;
  int? totalFeedbacks;
  int? pendingFeedbacks;
  int? openFeedbacks;
  int? closedFeedbacks;
  int? assignedFeedbacks;
  int? totalComments;
  int? totalLikes;
  dynamic bio;
  dynamic score;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["user_id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        profileImage: json["profile_image"],
        totalFeedbacks: json["total_feedbacks"],
        pendingFeedbacks: json["pending_feedbacks"],
        openFeedbacks: json["open_feedbacks"],
        closedFeedbacks: json["closed_feedbacks"],
        assignedFeedbacks: json["assigned_feedbacks"],
        totalComments: json["total_comments"],
        totalLikes: json["total_likes"],
        bio: json["bio"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "mobile": mobile,
        "profile_image": profileImage,
        "total_feedbacks": totalFeedbacks,
        "pending_feedbacks": pendingFeedbacks,
        "open_feedbacks": openFeedbacks,
        "closed_feedbacks": closedFeedbacks,
        "total_comments": totalComments,
        "total_likes": totalLikes,
      };
}
