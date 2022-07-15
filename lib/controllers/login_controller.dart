import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/models/login_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:empulse/views/pages/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

class LoginController extends GetxController {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtCaptcha = TextEditingController();
  Future<void> login() async {
    LoginModel loginModel = LoginModel(
        email: txtEmail.text.trim(), captcha: txtCaptcha.text.trim());
    BaseController.showLoading('Please wait while we verify');

    var response =
        await BaseClient().dioPost('/login', loginModelToJson(loginModel));
    BaseController.hideLoading();
    if (response != null) {
      if (response['success']) {
        DialogHelper.showSuccessToast(
            description: response['message'] + ' ' + txtEmail.text);
        DialogHelper.showSuccessToast(description: response['OTP'].toString());
        Get.to(
          () => OtpPage(
            email: txtEmail.text,
          ),
        );
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {
      // ToastMsg().warningToast(response['message']);
    }
  }
}
