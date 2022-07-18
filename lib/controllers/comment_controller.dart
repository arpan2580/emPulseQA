import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/models/comment_model.dart';
import 'package:empulse/models/comments.dart';
import 'package:empulse/models/feedback_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  TextEditingController usercomment = TextEditingController();
  var feedbackComments = [].obs;
  var type = ''.obs;
  var isLoading = RxBool(true);
  var feedbackDetails = <FeedbackModel>[].obs;
  RxString ownImage = ''.obs, ownName = ''.obs;
  File? file1;
  File? file2;
  File? file3;

  Future<void> fetchFeedbackDetails(feedbackId, showLoading) async {
    if (showLoading) {
      isLoading(true);
    }

    var response =
        await BaseClient().dioPost('/feedback/$feedbackId/details', null);
    // print(response);
    if (response != null) {
      if (response['success']) {
        feedbackDetails.clear();
        feedbackDetails.add(FeedbackModel.fromJson(response['data']));
      } else {
        DialogHelper.showErrorToast(description: response['message']);
      }
    } else {
      // DialogHelper.showErrorToast(
      //     description: 'Something went wrong! Please try again.');
    }
    if (showLoading) {
      isLoading(false);
    }
  }

  Future<void> addComment(
      int feedbackId, String type, int commentId, int repliedId) async {
    isLoading(true);
    AddCommentsModel commentModel = AddCommentsModel(
        feedbackId: feedbackId.toString(),
        usercomment: usercomment.text.trim(),
        parent: commentId,
        repliedId: repliedId,
        type: type);

    var response = await BaseClient()
        .dioPost('/insert-comment', commentsToJson(commentModel))
        .then((value) {
      showComment(feedbackId, true);
      if (type == '2') {
        if (BaseController.feedbackStatusId.contains(feedbackId)) {
        } else {
          BaseController.feedbackStatusId.add(feedbackId);
        }
      }
    });
    isLoading(false);
  }

  Future<void> showComment(int feedbackId, bool showLoading) async {
    ShowCommentModel commentModel =
        ShowCommentModel(feedbackId: feedbackId.toString());

    fetchFeedbackDetails(feedbackId, showLoading).then((value) async {
      var response = await BaseClient()
          .dioPost('/comments', commentModelToJson(commentModel));
      if (response != null && response['success']) {
        feedbackComments.clear();
        response['data']['items'].forEach((v) {
          feedbackComments.add(AddCommentsModel.fromJson(v));
        });
        ownImage.value = response['data']['me']['profile_image'].toString();
        ownName.value = response['data']['me']['name'].toString();
      } else {
        // print(response);
        // ToastMsg().warningToast(response['message']);
      }
    });
  }

  Future<void> addCommentWithImage(
      int feedbackId, String type, int commentId, int repliedId) async {
    isLoading(true);
    dynamic response;
    dynamic formData;

    if (file1 != null && file1!.path != '' ||
        file2 != null && file2!.path != '' ||
        file3 != null && file3!.path != '') {
      formData = dio.FormData.fromMap({
        'feedback_id': feedbackId.toString().trim(),
        'comment': usercomment.text.trim(),
        'parent': commentId.toString(),
        'replied_id': repliedId.toString(),
        'type': type.toString(),
        "file_1": (file1 != null)
            ? await dio.MultipartFile.fromFile(
                file1!.path,
                filename: file1!.path.split('/').last,
              )
            : null,
        "file_2": (file2 != null)
            ? await dio.MultipartFile.fromFile(
                file2!.path,
                filename: file2!.path.split('/').last,
              )
            : null,
        "file_3": (file3 != null)
            ? await dio.MultipartFile.fromFile(
                file3!.path,
                filename: file3!.path.split('/').last,
              )
            : null,
      });
      response = await BaseClient().dioPost('/insert-comment', formData);
      if (response != null) {
        if (response['success']) {
          if (type == '2') {
            if (BaseController.feedbackStatusId.contains(feedbackId)) {
            } else {
              BaseController.feedbackStatusId.add(feedbackId);
            }
          }
        } else {
          DialogHelper.showErrorToast(description: response['messages']);
        }
      }
    }

    isLoading(false);
  }

  List getImgList(Images? img) {
    List imgList = [];

    imgList.clear();

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
}
