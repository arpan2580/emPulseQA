import 'dart:convert';

MasterDataModel masterDataModelFromJson(String str) =>
    MasterDataModel.fromJson(json.decode(str));

String masterDataModelToJson(MasterDataModel data) =>
    json.encode(data.toJson());

class MasterDataModel {
  MasterDataModel({
    required this.baseImageUrl,
    required this.company,
    required this.price,
    required this.packaging,
    required this.productAvailability,
  });

  String baseImageUrl;
  String company;
  String price;
  String packaging;
  String productAvailability;

  factory MasterDataModel.fromJson(Map<String, dynamic> json) =>
      MasterDataModel(
        baseImageUrl: json["BASE_IMAGE_URL"],
        company: json["COMPANY"],
        price: json["PRICE"],
        packaging: json["PACKAGING"],
        productAvailability: json["PRODUCT_AVAILABILITY"],
      );

  Map<String, dynamic> toJson() => {
        "BASE_IMAGE_URL": baseImageUrl,
        "COMPANY": company,
        "PRICE": price,
        "PACKAGING": packaging,
        "PRODUCT_AVAILABILITY": productAvailability,
      };
}
