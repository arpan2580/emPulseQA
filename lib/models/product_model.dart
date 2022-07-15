import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    required this.id,
    required this.caregory,
    required this.caregoryDesc,
    required this.subCategory,
    required this.subCategoryDesc,
    required this.product,
  });

  String id;
  String caregory;
  String caregoryDesc;
  String subCategory;
  String subCategoryDesc;
  String product;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        caregory: json["caregory"],
        caregoryDesc: json["caregory_desc"],
        subCategory: json["sub_category"],
        subCategoryDesc: json["sub_category_desc"],
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "caregory": caregory,
        "caregory_desc": caregoryDesc,
        "sub_category": subCategory,
        "sub_category_desc": subCategoryDesc,
        "product": product,
      };
}
