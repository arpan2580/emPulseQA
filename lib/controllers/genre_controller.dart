import 'dart:convert';

import 'package:empulse/models/genre.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../models/category.dart';
import '../models/company.dart';
import '../models/feedback_type.dart';
import '../models/status_type.dart';
import '../models/sub_category.dart';
import '../models/trade_type.dart';
import '../services/base_client.dart';

class GenreController extends GetxController {
  var genreTypes = <Genre>[].obs;
  // List<MultiSelectItem> dropDownData = [];

  var categoryTypes = <Category>[].obs;
  // List<MultiSelectItem> categoryDropDownData = [];

  var subCategoryTypes = <SubCategory>[].obs;
  // List<MultiSelectItem> subCategoryDropDownData = [];

  var feedbackType = <FeedbackType>[].obs;
  // List<MultiSelectItem> feedbackTypeDropDownData = [];

  var tradeType = <TradeType>[].obs;
  // List<MultiSelectItem> tradeTypeDropDownData = [];

  var statusType = <StatusType>[].obs;
  // List<MultiSelectItem> statusTypeDropDownData = [];

  var companyType = <Company>[].obs;
  // List<MultiSelectItem> companyDropDownData = [];

  var companyForActionType = <Company>[].obs;
  // List<MultiSelectItem> companyForActionData = [];

  getAllData() {
    getGenreData();
    getCategory();
    getFeedbackType();
    getTradeType();
    getStatusType();
    getCompany();
    getCompanyForAction();
  }

  getGenre() {
    genreTypes.clear();
    final storeMasterData = GetStorage();
    var genreOfFeedbacks = storeMasterData.read('genre');
    if (genreOfFeedbacks != null) {
      genreOfFeedbacks
          .split(':')
          .forEach((data) => genreTypes.add(Genre(data)));
    }
  }

  getGenreData() {
    genreTypes.clear();
    // dropDownData.clear();

    final storeMasterData = GetStorage();
    var genreOfFeedbacks = storeMasterData.read('genre');

    if (genreOfFeedbacks != null) {
      genreOfFeedbacks
          .split(':')
          .forEach((data) => genreTypes.add(Genre(data)));

      // dropDownData = genreTypes.map((data) {
      //   return MultiSelectItem(data, data.genre);
      // }).toList();
    }
  }

  getCategory() async {
    categoryTypes.clear();
    // categoryDropDownData.clear();

    var response = await BaseClient().dioPost('/search-category', null);
    if (response != null) {
      if (response['success']) {
        response['data']
            .forEach((data) => categoryTypes.add(Category(data.toString())));
        // categoryDropDownData = categoryTypes.map((data) {
        //   return MultiSelectItem(data, data.categoryName);
        // }).toList();
      }
    }
  }

  getSubCategory(List selectedCategory) async {
    subCategoryTypes.clear();
    // subCategoryDropDownData.clear();

    var data = {
      'category': selectedCategory,
    };

    var response =
        await BaseClient().dioPost('/search-sub-category', json.encode(data));
    if (response != null) {
      if (response['success']) {
        response['data'].forEach(
            (data) => subCategoryTypes.add(SubCategory(data.toString())));
        // subCategoryDropDownData = subCategoryTypes.map((data) {
        //   return MultiSelectItem(data, data.subCategoryName);
        // }).toList();
        // update();
      }
    }
  }

  getFeedbackType() {
    feedbackType.clear();
    // feedbackTypeDropDownData.clear();
    feedbackType.add(FeedbackType("1", "Observation"));
    feedbackType.add(FeedbackType("2", "Action"));
    // feedbackTypeDropDownData = feedbackType.map((data) {
    //   return MultiSelectItem(data.feedbackTypeId, data.feedbackName);
    // }).toList();
  }

  getTradeType() {
    tradeType.clear();
    // tradeTypeDropDownData.clear();
    tradeType.add(TradeType("1", "General Trade"));
    tradeType.add(TradeType("2", "Modern Trade"));
    // tradeTypeDropDownData = tradeType.map((data) {
    //   return MultiSelectItem(data.tradeTypeId, data.tradeName);
    // }).toList();
  }

  getStatusType() {
    statusType.clear();
    // statusTypeDropDownData.clear();
    statusType.add(StatusType("200", "In Progress"));
    statusType.add(StatusType("300", "Closed"));
    // statusTypeDropDownData = statusType.map((data) {
    //   return MultiSelectItem(data.statusTypeId, data.statusName);
    // }).toList();
  }

  getCompany() {
    companyType.clear();
    // companyDropDownData.clear();
    companyType.add(Company("ITC"));
    companyType.add(Company("Direct Competitor"));
    companyType.add(Company("Other Player"));

    // companyDropDownData = companyType.map((data) {
    //   return MultiSelectItem(data.companyName, data.companyName);
    // }).toList();
  }

  getCompanyForAction() {
    companyForActionType.clear();
    // companyForActionData.clear();
    companyForActionType.add(Company("ITC"));
    // companyForActionData = companyForActionType.map((data) {
    //   return MultiSelectItem(data.companyName, data.companyName);
    // }).toList();
  }
}
