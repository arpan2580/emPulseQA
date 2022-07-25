import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/models/otp_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:empulse/views/pages/bottom_nav_bar.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

class OtpController extends GetxController {
  TextEditingController txtOtp = TextEditingController();
  TextEditingController txtDeviceName = TextEditingController();
  TextEditingController txtDeviceModel = TextEditingController();
  TextEditingController txtOsVersion = TextEditingController();
  TextEditingController txtOsType = TextEditingController();

  final storeToken = GetStorage();

  void otpCheck(email, deviceToken) async {
    if (deviceToken != null) {
      OtpModel otpModel = OtpModel(
        email: email,
        deviceId: deviceToken,
        otp: txtOtp.text.trim(),
        deviceName: txtDeviceName.text.trim(),
        deviceModel: txtDeviceModel.text.trim(),
        osVersion: txtOsVersion.text.trim(),
        osType: txtOsType.text.trim(),
      );
      BaseController.showLoading('Please wait while we verify');
      var response =
          await BaseClient().dioPost('/login/otp', otpModelToJson(otpModel));
      BaseController.hideLoading();
      if (response != null) {
        if (response['success']) {
          DialogHelper.showSuccessToast(description: response['message']);
          storeToken.write("token", response['token']);
          storeToken.write("refreshToken", response['refresh_token']);
          storeToken.remove("otpKey");
          var response1 = await BaseClient().dioPost('/my-global-data', null);
          if (response1 != null && response1['success']) {
            storeToken.write("unreadNotification",
                response1['data']['unread_notification_count']);
            storeToken.write(
                "assignedPost", response1['data']['assigned_feedback_count']);
          } else {}
          BaseController.unreadNotification.value =
              storeToken.read('unreadNotification');
          BaseController.assignedPosts.value = storeToken.read('assignedPost');
          Get.offAll(() => FeatureDiscovery(
                recordStepsInSharedPreferences: true,
                child: const BottomNavBar(
                  index: 0,
                ),
              ));
        } else {
          DialogHelper.showErrorToast(description: response['message']);
        }
      } else {
        DialogHelper.showErrorToast(
            description: 'Something went wrong. Please try later.');
      }
    } else {
      DialogHelper.showErrorToast(
          description:
              'Your device could not be recognized. Please try later.');
    }
  }
}
