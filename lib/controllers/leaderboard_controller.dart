import 'package:empulse/models/profile_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LeaderboardController extends GetxController {
  var topUsersList = [].obs;
  var isLoading = true.obs;

  Future<void> fetchLeaderboard() async {
    isLoading(true);
    topUsersList.clear();

    var response = await BaseClient().dioPost('/leader-board', null);
    if (response != null) {
      if (response['success']) {
        response['data'].forEach((v) {
          topUsersList.add(ProfileModel.fromJson(v));
        });
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {
      // DialogHelper.showErrorToast(description: 'Something went wrong!');
    }
    isLoading(false);
  }
}
