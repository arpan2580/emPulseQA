import 'package:empulse/models/feedback_react_list.dart';
import 'package:empulse/services/base_client.dart';
import 'package:get/get.dart';

class FeedbackReactListController extends GetxController {
  final userName = ''.obs;
  final userProfileImage = ''.obs;
  var isLoading = RxBool(true);
  var reactList = <FeedbackReactList>[].obs;

  Future<void> fetchReactList(feedbackId) async {
    reactList.clear();
    var response =
        await BaseClient().dioPost('/feedback/$feedbackId/liked-by', null);
    if (response != null && response['success']) {
      response['data'].forEach((v) {
        reactList.add(FeedbackReactList.fromJson(v));
      });
    }
    // print(reactList[0].name);
    isLoading(false);
  }
}
