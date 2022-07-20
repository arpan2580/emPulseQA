import 'dart:convert';

import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/models/feedback_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';

class FeedbackController extends GetxController {
  var feedbackList = <FeedbackModel>[].obs;
  var myFeedbackList = <FeedbackModel>[].obs;
  var topUsersList = [].obs;
  dynamic nextPageUrl;
  dynamic perPage;
  var isLoading = true.obs;
  late FeedbackModel feedbackModel;
  TextEditingController txtSearch = TextEditingController();

  bool isFilterApplied = false;
  List selectedGenreOfFeedback = [].obs,
      selectedTypeOfFeedback = [].obs,
      selectedCompanyType = [].obs,
      selectedTradeType = [].obs,
      selectedPostStatus = [].obs,
      selectedCategory = [].obs,
      selectedSubCategory = [].obs;

  List showSelectedTypeOfFeedback = [].obs,
      showSelectedTradeType = [].obs,
      showSelectedPostStatus = [].obs;

  RxBool isObservationType = false.obs,
      isActionType = false.obs,
      isSearchApplied = false.obs;

  void search(bool isMyFeedback) async {
    Map<String, dynamic> data = {};

    if (txtSearch.text.trim() != '') {
      data['s'] = txtSearch.text.trim();
    }
    if (selectedGenreOfFeedback.isNotEmpty) {
      data['genre'] = selectedGenreOfFeedback;
    }
    if (selectedTypeOfFeedback.isNotEmpty) {
      data['type'] = selectedTypeOfFeedback;
    }
    if (selectedCompanyType.isNotEmpty) {
      data['company'] = selectedCompanyType;
    }
    if (selectedTradeType.isNotEmpty) {
      data['trade_type'] = selectedTradeType;
    }
    if (selectedPostStatus.isNotEmpty) {
      data['status'] = selectedPostStatus;
    }
    if (selectedCategory.isNotEmpty) {
      data['category'] = selectedCategory;
    }
    if (selectedSubCategory.isNotEmpty) {
      data['sub_category'] = selectedSubCategory;
    }

    if (selectedGenreOfFeedback.isNotEmpty ||
        selectedTypeOfFeedback.isNotEmpty ||
        selectedCompanyType.isNotEmpty ||
        selectedTradeType.isNotEmpty ||
        selectedPostStatus.isNotEmpty ||
        selectedCategory.isNotEmpty ||
        selectedSubCategory.isNotEmpty) {
      isFilterApplied = true;
      isSearchApplied = true.obs;
    } else {
      isFilterApplied = false;
      isSearchApplied = false.obs;
    }
    print(data.toString());

    // BaseController.showLoading('Searching...');
    isLoading(true);
    if (isMyFeedback) {
      var response =
          await BaseClient().dioPost('/my-feedbacks', json.encode(data));
      myFeedbackList.clear();

      if (response != null) {
        if (response['success']) {
          response['data']['items'].forEach((v) {
            myFeedbackList.add(FeedbackModel.fromJson(v));
          });
          nextPageUrl = response['data']['next_page_url'];
          perPage = response['data']['per_page'];
        } else {
          DialogHelper.showErrorToast(description: response['message']);
        }
      } else {
        // DialogHelper.showErrorToast(description: 'Something went wrong!');
      }
    } else {
      var response =
          await BaseClient().dioPost('/search-feedback', json.encode(data));
      feedbackList.clear();

      if (response != null) {
        if (response['success']) {
          response['data']['items'].forEach((v) {
            feedbackList.add(FeedbackModel.fromJson(v));
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
    isLoading(false);
  }

  Future<void> fetchFeedback() async {
    var data = {
      's': '',
    };
    if (feedbackList.isEmpty) {
      isLoading(true);
    }
    BaseController.likedFeedbackId.clear();
    BaseController.postLikedCount.clear();
    BaseController.isLikedPost.clear();
    BaseController.feedbackStatusId.clear();

    var response =
        await BaseClient().dioPost('/search-feedback', json.encode(data));
    if (response != null) {
      feedbackList.clear();
      if (response['success']) {
        response['data']['items'].forEach((v) {
          feedbackList.add(FeedbackModel.fromJson(v));
        });
        nextPageUrl = response['data']['next_page_url'];
        perPage = response['data']['per_page'];
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {
      // DialogHelper.showErrorToast(description: 'Something went wrong!');
    }
    isLoading(false);
  }

  Future<void> fetchMyFeedback() async {
    var data = {
      's': '',
    };
    if (myFeedbackList.isEmpty) {
      isLoading(true);
    }
    BaseController.likedFeedbackId.clear();
    BaseController.postLikedCount.clear();
    BaseController.isLikedPost.clear();
    BaseController.feedbackStatusId.clear();
    var response =
        await BaseClient().dioPost('/my-feedbacks', json.encode(data));
    if (response != null) {
      myFeedbackList.clear();
      if (response['success']) {
        response['data']['items'].forEach((v) {
          myFeedbackList.add(FeedbackModel.fromJson(v));
        });
        nextPageUrl = response['data']['next_page_url'];
        perPage = response['data']['per_page'];
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {
      // DialogHelper.showErrorToast(description: 'Something went wrong!');
    }
    isLoading(false);
  }

  List getImgList(Images? img) {
    List imgList = [];

    if (img != null && img.file1 != null && img.file1 != '') {
      imgList.add(img.file1);
    }
    if (img != null && img.file2 != null && img.file2 != '') {
      imgList.add(img.file2);
    }
    if (img != null && img.file3 != null && img.file3 != '') {
      imgList.add(img.file3);
    }

    return imgList;
  }

  Future<void> fetchMore(nextUrl, isMyFeedback) async {
    // needs to be updated respect to fetchuserpost
    final url = Uri.parse(nextUrl);
    final endPoint = '/' + url.pathSegments.last + '?' + url.query;
    var data = {
      's': '',
    };

    var response = await BaseClient().dioPost(endPoint, json.encode(data));
    if (response != null) {
      if (response['success']) {
        if (isMyFeedback) {
          response['data']['items'].forEach((v) {
            myFeedbackList.add(FeedbackModel.fromJson(v));
          });
        } else {
          response['data']['items'].forEach((v) {
            feedbackList.add(FeedbackModel.fromJson(v));
          });
        }

        nextPageUrl = response['data']['next_page_url'];
        perPage = response['data']['per_page'];
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {
      // DialogHelper.showErrorToast(description: 'Something went wrong!');
    }
  }

  Future<bool> fetchMasterData() async {
    final storeMasterData = GetStorage();
    bool isComplete = false;
    var response1 = await BaseClient().dioPost('/top-users', null);
    if (response1 != null && response1['success']) {
      topUsersList.clear();
      response1['data'].forEach((v) {
        topUsersList.add(v);
      });
      if (storeMasterData.read("company") == null ||
          storeMasterData.read("genre") == null ||
          storeMasterData.read("baseImgUrl") == null ||
          storeMasterData.read("aboutAppUrl") == null ||
          storeMasterData.read("defaultBio") == null ||
          storeMasterData.read("baseVersionAppUrl") == null ||
          storeMasterData.read("privacyUrl") == null ||
          storeMasterData.read("supportUrl") == null) {
        var response =
            await BaseClient().dioPost('/master-selection-data', null);
        if (response != null && response['success']) {
          storeMasterData.write("company", response['data']['COMPANY']);
          storeMasterData.write("genre", response['data']['GENRE']);
          storeMasterData.write(
              "baseImgUrl", response['data']['BASE_IMAGE_URL']);
          storeMasterData.write("aboutAppUrl", response['data']['ABOUT_URL']);
          storeMasterData.write(
              "baseVersionAppUrl", response['data']['BASE_APP_VERSION_URL']);
          storeMasterData.write("defaultBio", response['data']['DEFAULT_BIO']);
          storeMasterData.write("privacyUrl", response['data']['PRIVACY_URL']);
          storeMasterData.write("supportUrl", response['data']['SUPPORT_URL']);
        } else {}
      }
      isComplete = true;
    } else {}

    BaseController.baseImgUrl = storeMasterData.read("baseImgUrl");
    return isComplete;
  }
}
