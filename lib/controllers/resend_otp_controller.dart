import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/models/resend_otp_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ResendOtpController extends GetxController {
  final newOtpToken = GetStorage();
  void resendOtp(resendOtpToken) async {
    if (resendOtpToken != null) {
      ResendOtp resendOtpModel = ResendOtp(resendOtpToken: resendOtpToken);

      BaseController.showLoading("Please wait Generating new OTP");
      var response = await BaseClient().dioPost(
        "/resend-otp",
        resendOtpToJson(resendOtpModel),
      );
      BaseController.hideLoading();
      if (response != null) {
        if (response['success']) {
          DialogHelper.showSuccessToast(
              description: response['OTP'].toString());
          newOtpToken.write("otpKey", response['resend_otp_token'].toString());
        } else {
          DialogHelper.showErrorToast(description: "Cannot generate new OTP.");
        }
      }
    }
  }
}
