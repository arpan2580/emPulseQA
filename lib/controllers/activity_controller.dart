import 'package:empulse/models/activity_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ActivityController extends GetxController {
  var activityList = <ActivityModel>[].obs;
  var isLoading = true.obs;

  Future<void> fetchActivityData(feedbackId) async {
    isLoading(true);

    var response =
        await BaseClient().dioPost('/feedback/$feedbackId/timeline', null);
    if (response != null) {
      if (response['success']) {
        activityList.add(ActivityModel.fromJson(response['data']));
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {
      // DialogHelper.showErrorToast(description: 'Something went wrong!');
    }
    isLoading(false);
  }
}
