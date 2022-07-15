import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/models/feedback_model.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:flutter/material.dart';

class InsertFeedbackController extends GetxController {
  TextEditingController outletName = TextEditingController();
  TextEditingController marketName = TextEditingController();
  TextEditingController isMarketSelected = TextEditingController();
  TextEditingController feedbackType = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController productId = TextEditingController();
  TextEditingController productName = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController subCategory = TextEditingController();
  TextEditingController genre = TextEditingController();
  TextEditingController feedback = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController trade = TextEditingController();

  File? file1;
  File? file2;
  File? file3;
  var isLoading = true.obs;

  void insertFeedback(context, callback) async {
    dynamic response, formData;
    BaseController.showLoading('Please wait..');
    if (file1 != null && file1!.path != '' ||
        file2 != null && file2!.path != '' ||
        file3 != null && file3!.path != '') {
      if (productId.text != 'null') {
        formData = dio.FormData.fromMap({
          'outlet_name': outletName.text.trim(),
          'market_name': marketName.text.trim(),
          'is_market_selected': isMarketSelected.text.trim(),
          'trade_type': trade.text.trim(),
          'company': companyName.text.trim(),
          'product_id': productId.text.trim(),
          'type': feedbackType.text.trim(),
          'genre': genre.text.trim(),
          'feedback': feedback.text.trim(),
          'latitude': latitude.text.trim(),
          'longitude': longitude.text.trim(),
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
      }
      if (productName.text != '') {
        formData = dio.FormData.fromMap({
          'outlet_name': outletName.text.trim(),
          'market_name': marketName.text.trim(),
          'is_market_selected': isMarketSelected.text.trim(),
          'trade_type': trade.text.trim(),
          'company': companyName.text.trim(),
          'product_name': productName.text.trim(),
          'type': feedbackType.text.trim(),
          'genre': genre.text.trim(),
          'feedback': feedback.text.trim(),
          'latitude': latitude.text.trim(),
          'longitude': longitude.text.trim(),
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
      }

      response = await BaseClient().dioPost('/insert-feedback', formData);
      print(response.toString());
      BaseController.hideLoading();

      if (response != null) {
        if (response['success']) {
          DialogHelper.showSuccessToast(description: response['message']);
        } else {
          DialogHelper.showErrorToast(description: response['messages']);
        }
        callback(1);
        Navigator.of(context).pop();
      }
    } else {
      FeedbackModel addFeedback;
      if (productId.text != 'null') {
        addFeedback = FeedbackModel(
          outletName: outletName.text.trim(),
          marketName: marketName.text.trim(),
          isMarketSelected: isMarketSelected.text.trim(),
          trade: trade.text.trim(),
          company: companyName.text.trim(),
          productId: productId.text.trim(),
          type: feedbackType.text.trim(),
          genre: genre.text.trim(),
          feedback: feedback.text.trim(),
          latitude: latitude.text.trim(),
          longitude: longitude.text.trim(),
        );
      } else {
        addFeedback = FeedbackModel(
          outletName: outletName.text.trim(),
          marketName: marketName.text.trim(),
          isMarketSelected: isMarketSelected.text.trim(),
          trade: trade.text.trim(),
          company: companyName.text.trim(),
          productName: productName.text.trim(),
          type: feedbackType.text.trim(),
          genre: genre.text.trim(),
          feedback: feedback.text.trim(),
          latitude: latitude.text.trim(),
          longitude: longitude.text.trim(),
        );
      }

      response = await BaseClient()
          .dioPost('/insert-feedback', feedbackModelToJson(addFeedback));
      BaseController.hideLoading();

      if (response != null) {
        if (response['success']) {
          DialogHelper.showSuccessToast(description: response['message']);
        } else {
          DialogHelper.showErrorToast(description: response['message']);
        }
        callback(1);
        Navigator.of(context).pop();
      } else {}
    }
  }
}
