import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/models/profile_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../views/pages/login_page.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var userDetails = [].obs;
  TextEditingController txtBio = TextEditingController();

  void fetchUserProfile() async {
    isLoading(true);
    var response = await BaseClient().dioPost('/me', null);
    if (response != null) {
      if (response['success']) {
        userDetails.clear();
        userDetails.add(ProfileModel.fromJson(response['data']));
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {
      // DialogHelper.showErrorToast(description: 'Something went wrong!');
    }
    isLoading(false);
  }

  void updateProfileImage(File file1) async {
    BaseController.showLoading('Please wait..');
    dynamic response, formData;
    if (file1.path != '') {
      formData = dio.FormData.fromMap({
        "profile_image": await dio.MultipartFile.fromFile(
          file1.path,
          filename: file1.path.split('/').last,
        ),
      });
      response = await BaseClient().dioPost('/update-profile-image', formData);
      BaseController.hideLoading();
      if (response != null) {
        if (response['success']) {
          DialogHelper.showSuccessToast(description: response['message']);
        } else {
          DialogHelper.showErrorToast(description: response['messages']);
        }
      }
    } else {
      DialogHelper.showErrorToast(description: 'Image not recognized');
    }
  }

  Future<List<ProfileModel>> getUserList(String filter) async {
    dynamic userList = <ProfileModel>[];
    var data = {
      's': filter,
    };
    var response =
        await BaseClient().dioPost('/search-user', json.encode(data));
    if (response != null && response['success']) {
      List userJson = response['data'];

      for (Map<String, dynamic> user in userJson) {
        userList.add(ProfileModel.fromJson(user));
      }
      return userList.toList();
    } else {
      return userList.toList();
      // throw Exception("Error ${response.statusCode}");
    }
  }

  Future<void> assignFeedback(feedbackId, userId) async {
    BaseController.showLoading('Please wait while we try to assign');

    var data = {
      'assigned_to': userId,
      'feedback_id': feedbackId,
    };
    var response =
        await BaseClient().dioPost('/assign-feedback', json.encode(data));
    BaseController.hideLoading();
    if (response != null) {
      if (response['success']) {
        DialogHelper.showSuccessToast(description: response['message']);
      } else {
        DialogHelper.showErrorToast(description: response['messages']);
      }
    } else {}
  }

  Future<void> shareFeedback(feedbackId, userId) async {
    BaseController.showLoading('Please wait while we try to share');

    var data = {
      'user_to': userId,
    };
    var response = await BaseClient()
        .dioPost('/feedback/$feedbackId/share', json.encode(data));
    BaseController.hideLoading();
    if (response != null) {
      if (response['success']) {
        DialogHelper.showSuccessToast(description: response['message']);
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {}
  }

  void updateProfileBio() async {
    isLoading(true);
    var data = {
      "bio": txtBio.text.trim(),
    };
    var response = await BaseClient().dioPost('/update-bio', json.encode(data));
    if (response != null) {
      if (response['success']) {
        fetchUserProfile();
        DialogHelper.showSuccessToast(description: response['message']);
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {}
    isLoading(false);
  }

  void logout() {
    final storedToken = GetStorage();
    storedToken.remove("token");
    storedToken.remove("refreshToken");
    storedToken.remove("unreadNotification");
    storedToken.remove("assignedPost");
    storedToken.remove("company");
    storedToken.remove("genre");
    storedToken.remove("baseImgUrl");
    storedToken.remove("aboutAppUrl");
    storedToken.remove("defaultBio");
    storedToken.remove("baseVersionAppUrl");
    storedToken.remove("privacyUrl");
    storedToken.remove("supportUrl");
    Get.offAll(() => const LoginPage());
  }
}
