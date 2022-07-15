import 'dart:convert';

import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/models/feedback_model.dart';
import 'package:empulse/models/profile_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UserFeedbackController extends GetxController {
  var userFeedbackList = <FeedbackModel>[].obs;
  dynamic nextPageUrl;
  dynamic perPage;
  var isLoading = true.obs;
  var userDetails = [].obs;
  var myAssignedList = <FeedbackModel>[].obs;

  Future<void> fetchUserFeedback(userId) async {
    var data = {
      's': '',
      'user_id': userId,
    };
    isLoading(true);
    BaseController.likedFeedbackId.clear();
    BaseController.postLikedCount.clear();
    BaseController.isLikedPost.clear();
    BaseController.feedbackStatusId.clear();
    var response = await BaseClient().dioPost('/user/$userId', null);
    if (response != null) {
      if (response['success']) {
        userDetails.clear();
        userDetails.add(ProfileModel.fromJson(response['data']));
      }
    }
    var response1 =
        await BaseClient().dioPost('/search-user-feedback', json.encode(data));
    if (response1 != null) {
      userFeedbackList.clear();

      if (response1['success']) {
        response1['data']['items'].forEach((v) {
          userFeedbackList.add(FeedbackModel.fromJson(v));
        });
        nextPageUrl = response1['data']['next_page_url'];
        perPage = response1['data']['per_page'];
      } else {
        DialogHelper.showErrorToast(description: response1['message']);
      }
    }
    isLoading(false);
  }

  Future<void> fetchMore(nextUrl, userId) async {
    final url = Uri.parse(nextUrl);
    final endPoint = '/' + url.pathSegments.last + '?' + url.query;
    var data = {
      's': '',
      'user_id': userId,
    };

    var response = await BaseClient().dioPost(endPoint, json.encode(data));
    if (response != null) {
      if (response['success']) {
        response['data']['items'].forEach((v) {
          userFeedbackList.add(FeedbackModel.fromJson(v));
        });

        nextPageUrl = response['data']['next_page_url'];
        perPage = response['data']['per_page'];
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {}
  }
}
