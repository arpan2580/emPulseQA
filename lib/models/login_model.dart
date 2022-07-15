import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.email,
    required this.captcha,
  });

  String email, captcha;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        email: json["email"],
        captcha: json["captcha"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "captcha": captcha,
      };
}
