import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:empulse/controllers/otp_controller.dart';
import 'package:empulse/views/pages/splash_page.dart';
import 'package:empulse/views/widgets/custom_button.dart';
import 'package:empulse/views/widgets/custom_textfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

class OtpPage extends StatefulWidget {
  final String email;
  const OtpPage({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // late String _otp;
  String deviceToken = '';
  var otpController = Get.put(OtpController());

  String? osType, osVersion, deviceName, deviceModel;

  final storeUserMail = GetStorage();

  Future<void> getDeviceToken() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    deviceToken = token.toString();
    print("Token Value $deviceToken");
  }

  Future<void> getDeviceDetails() async {
    DeviceInfoPlugin _deviceDetails = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var _androidInfo = await _deviceDetails.androidInfo;
      deviceName = _androidInfo.device;
      deviceModel = _androidInfo.model;
      osVersion = _androidInfo.version.release;
      osType = "ANDROID";
    }
    if (Platform.isIOS) {
      var _iosInfo = await _deviceDetails.iosInfo;
      deviceName = _iosInfo.name;
      deviceModel = _iosInfo.model;
      osVersion = _iosInfo.systemVersion;
      osType = "IOS";
    }

    otpController.txtDeviceName.text = deviceName!;
    otpController.txtDeviceModel.text = deviceModel!;
    otpController.txtOsVersion.text = osVersion!;
    otpController.txtOsType.text = osType!;

    // print(
    //     "Device Name: $deviceName \nOS Version: $osVersion \nDevice Model: $deviceModel \nOS Type: $osType");
  }

  @override
  void initState() {
    super.initState();
    getDeviceToken();
    getDeviceDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/Main_Background.jpg',
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.loose,
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 77.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 172.h),
                            Image(
                              image: const AssetImage(
                                  "assets/images/otp_screen_image.png"),
                              height: 240.h,
                              width: 190.w,
                            ),
                            SizedBox(height: 35.h),
                            CustomTextfield(
                              textEditingController: otpController.txtOtp,
                              hintText: "Type your OTP here",
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true),
                              obsecureTxt: true,
                              suffixIcon: true,
                              maxLength: 6,
                              counterText: "",
                              fullBorder: false,
                              maxLine: 1,
                              centerText: true,
                              validation: () {
                                otpController.txtOtp.text =
                                    otpController.txtOtp.text.trim();
                                if (otpController.txtOtp.text.isEmpty) {
                                  return "Please enter your OTP to login";
                                } else if (otpController.txtOtp.text.length <
                                    6) {
                                  return "Please enter correct OTP to proceed";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 29.h),
                            CustomButton(
                              btnText: "Confirm",
                              formKey: _formKey,
                              action: () {
                                var validate =
                                    _formKey.currentState!.validate();
                                if (validate) {
                                  _formKey.currentState!.save();
                                  otpController.otpCheck(
                                      widget.email, deviceToken);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: -10,
                  top: 30,
                  child: EmpulseLogo(
                    width: 150,
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
