// To parse this JSON data, do
//
//     final resendOtp = resendOtpFromJson(jsonString);

import 'dart:convert';

ResendOtp resendOtpFromJson(String str) => ResendOtp.fromJson(json.decode(str));

String resendOtpToJson(ResendOtp data) => json.encode(data.toJson());

class ResendOtp {
  ResendOtp({
    this.success,
    this.message,
    required this.resendOtpToken,
    this.otp,
  });

  bool? success;
  String? message;
  String resendOtpToken;
  int? otp;

  factory ResendOtp.fromJson(Map<String, dynamic> json) => ResendOtp(
        success: json["success"],
        message: json["message"],
        resendOtpToken: json["resend_otp_token"],
        otp: json["OTP"],
      );

  Map<String, dynamic> toJson() => {
        "resend_otp_token": resendOtpToken,
      };
}
