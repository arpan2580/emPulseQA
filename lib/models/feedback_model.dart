import 'dart:convert';

FeedbackModel feedbackModelFromJson(String str) =>
    FeedbackModel.fromJson(json.decode(str));

String feedbackModelToJson(FeedbackModel data) => json.encode(data.toJson());

class FeedbackModel {
  FeedbackModel({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.profileImage,
    this.outletName,
    this.marketName,
    this.isMarketSelected,
    this.company,
    this.productId,
    this.productName,
    this.category,
    this.subCategory,
    required this.genre,
    required this.feedback,
    this.images,
    required this.type,
    this.status,
    required this.latitude,
    required this.longitude,
    this.liked,
    this.commented,
    this.isLiked,
    this.isDisliked,
    this.file1,
    this.file2,
    this.file3,
    this.created,
    required this.trade,
  });

  int? id;
  String? userId;
  String? name;
  String? email;
  String? profileImage;
  dynamic outletName;
  dynamic marketName;
  String? isMarketSelected;

  dynamic trade;
  dynamic company;
  dynamic productId;
  dynamic productName;
  dynamic category;
  dynamic subCategory;
  String genre;
  String feedback;
  Images? images;
  String type; // 1 => Observation  ,  2 => For Action
  String? status;
  String latitude;
  String longitude;
  String? liked;
  String? commented;
  bool? isLiked;
  bool? isDisliked;
  String? file1;
  String? file2;
  String? file3;
  String? created;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        profileImage: json["profile_image"],
        outletName: json["outlet_name"],
        marketName: json["market_name"],
        trade: json["trade_type"],
        company: json["company"],
        productId: json["product_id"],
        productName: json["product_name"],
        category: json["category"],
        subCategory: json["sub_category"],
        genre: json["genre"],
        feedback: json["feedback"],
        images: json["images"] != null ? Images.fromJson(json["images"]) : null,
        type: json["type"],
        status: json["status"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        liked: json["liked"].toString(),
        commented: json["commented"].toString(),
        isLiked: json["is_liked"],
        isDisliked: json["is_disliked"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "outlet_name": outletName,
        "market_name": marketName,
        "is_market_selected": isMarketSelected,
        "trade_type": trade,
        "company": company,
        "product_id": productId,
        "product_name": productName,
        "category": category,
        "sub_category": subCategory,
        "genre": genre,
        "feedback": feedback,
        // "images": images?.toJson(),
        "type": type,
        "status": status,
        "latitude": latitude,
        "longitude": longitude,
        "liked": liked,
        "commented": commented,
        "is_liked": isLiked,
        "is_disliked": isDisliked,
        "file_1": file1,
        "file_2": file2,
        "file_3": file3,
      };
}

class Images {
  Images({
    this.file1,
    this.file2,
    this.file3,
  });

  String? file1, file2, file3;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        file1: json["file_1"],
        file2: json["file_2"],
        file3: json["file_3"],
      );

  Map<String, dynamic> toJson() => {
        "file_1": file1,
        "file_2": file2,
        "file_3": file3,
      };
}
