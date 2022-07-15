import 'dart:convert';

import 'package:empulse/models/feedback_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AssignedFeedbackController extends GetxController {
  dynamic nextPageUrl;
  dynamic perPage;
  var isLoading = true.obs;
  var userDetails = [].obs;
  var myAssignedList = <FeedbackModel>[].obs;

  Future<void> fetchAssignedFeedback() async {
    var data = {
      's': '',
    };
    if (myAssignedList.isEmpty) {
      isLoading(true);
    }

    var response =
        await BaseClient().dioPost('/assigned-feedbacks', json.encode(data));
    if (response != null) {
      myAssignedList.clear();
      if (response['success']) {
        if (response['data'].length > 0) {
          response['data']['items'].forEach((v) {
            myAssignedList.add(FeedbackModel.fromJson(v));
          });
          nextPageUrl = response['data']['next_page_url'];
          perPage = response['data']['per_page'];
        }
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {
      // DialogHelper.showErrorToast(description: 'Something went wrong!');
    }
    isLoading(false);
  }

  Future<void> fetchMore(nextUrl) async {
    final url = Uri.parse(nextUrl);
    final endPoint = '/' + url.pathSegments.last + '?' + url.query;
    var data = {
      's': '',
    };
    var response = await BaseClient().dioPost(endPoint, json.encode(data));
    if (response != null) {
      if (response['success']) {
        response['data']['items'].forEach((v) {
          myAssignedList.add(FeedbackModel.fromJson(v));
        });

        nextPageUrl = response['data']['next_page_url'];
        perPage = response['data']['per_page'];
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {
      // DialogHelper.showErrorToast(description: 'Something went wrong!');
    }
  }
}
