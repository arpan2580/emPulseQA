import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/models/notification_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  var notificationList = <NotificationModel>[].obs;
  var isLoading = true.obs;
  late NotificationModel notificationModel;
  dynamic nextPageUrl;
  dynamic perPage;

  Future<void> fetchNotification() async {
    isLoading(true);
    notificationList.clear();

    var response = await BaseClient().dioPost('/notifications', null);
    if (response != null) {
      if (response['success']) {
        response['data']['items'].forEach((v) {
          notificationList.add(NotificationModel.fromJson(v));
        });
        nextPageUrl = response['data']['next_page_url'];
        perPage = response['data']['per_page'];
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {}
    isLoading(false);
  }

  Future<void> fetchMore(nextUrl) async {
    final url = Uri.parse(nextUrl);
    final endPoint = '/' + url.pathSegments.last + '?' + url.query;

    var response = await BaseClient().dioPost(endPoint, null);
    if (response != null) {
      if (response['success']) {
        response['data']['items'].forEach((v) {
          notificationList.add(NotificationModel.fromJson(v));
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

  Future<void> readNotification(id) async {
    final storage = GetStorage();
    var response =
        await BaseClient().dioPost('/notification/$id/mark-as-read', null);
    if (response != null) {
      if (response['success']) {
        var unreadCount = BaseController.unreadNotification.value - 1;
        if (unreadCount < 0) {
          unreadCount = 0;
        }
        BaseController.unreadNotification.value = unreadCount;
        storage.write(
            "unreadNotification", BaseController.unreadNotification.value);
        notificationList.clear();
        response['data']['items'].forEach((v) {
          notificationList.add(NotificationModel.fromJson(v));
        });
        nextPageUrl = response['data']['next_page_url'];
        perPage = response['data']['per_page'];
      } else {}
    } else {}
  }

  Future<void> deleteNotification(id, status) async {
    // isLoading(true);
    final storage = GetStorage();
    var response = await BaseClient().dioPost('/notification/$id/delete', null);
    if (response != null) {
      if (response['success']) {
        if (status == "0") {
          var unreadCount = BaseController.unreadNotification.value - 1;
          if (unreadCount < 0) {
            unreadCount = 0;
          }
          BaseController.unreadNotification.value = unreadCount;
          storage.write(
              "unreadNotification", BaseController.unreadNotification.value);
        }
        notificationList.clear();
        response['data']['items'].forEach((v) {
          notificationList.add(NotificationModel.fromJson(v));
        });
        nextPageUrl = response['data']['next_page_url'];
        perPage = response['data']['per_page'];
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {}
    // isLoading(false);
  }

  Future<void> readAllNotifications() async {
    final storage = GetStorage();
    var response =
        await BaseClient().dioPost('/notification/mark-as-read-all', null);
    if (response != null) {
      if (response['success']) {
        BaseController.unreadNotification.value = 0;
        storage.write(
            "unreadNotification", BaseController.unreadNotification.value);
        notificationList.clear();
        response['data']['items'].forEach((v) {
          notificationList.add(NotificationModel.fromJson(v));
        });
        nextPageUrl = response['data']['next_page_url'];
        perPage = response['data']['per_page'];
      } else {}
    } else {}
  }

  Future<void> deleteAllNotifications() async {
    final storage = GetStorage();
    var response = await BaseClient().dioPost('/notification/delete-all', null);
    if (response != null) {
      if (response['success']) {
        BaseController.unreadNotification.value = 0;
        storage.write(
            "unreadNotification", BaseController.unreadNotification.value);
        notificationList.clear();
        response['data']['items'].forEach((v) {
          notificationList.add(NotificationModel.fromJson(v));
        });
        nextPageUrl = response['data']['next_page_url'];
        perPage = response['data']['per_page'];
      } else {}
    } else {}
  }
}
