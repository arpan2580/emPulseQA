import 'dart:convert';

OtpModel otpModelFromJson(String str) => OtpModel.fromJson(json.decode(str));

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
  OtpModel({
    required this.email,
    required this.deviceId,
    required this.otp,
    required this.deviceName,
    required this.deviceModel,
    required this.osVersion,
    required this.osType,
  });

  String email;
  String deviceId;
  String otp;
  String deviceName;
  String deviceModel;
  String osVersion;
  String osType;

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        email: json["email"],
        deviceId: json["device_id"],
        otp: json["otp"],
        deviceName: json["device_name"],
        deviceModel: json["device_model"],
        osVersion: json["os_version"],
        osType: json["os_type"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "device_id": deviceId,
        "otp": otp,
        "device_name": deviceName,
        "device_model": deviceModel,
        "os_version": osVersion,
        "os_type": osType,
      };
}
