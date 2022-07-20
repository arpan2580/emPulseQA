import 'dart:convert';

import 'package:empulse/models/genre.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

import '../models/category.dart';
import '../models/company.dart';
import '../models/feedback_type.dart';
import '../models/status_type.dart';
import '../models/sub_category.dart';
import '../models/trade_type.dart';
import '../services/base_client.dart';

class GenreController extends GetxController {
  var genreTypes = <Genre>[].obs;

  var categoryTypes = <Category>[].obs;

  var subCategoryTypes = <SubCategory>[].obs;

  var feedbackType = <FeedbackType>[].obs;

  var tradeType = <TradeType>[].obs;

  var statusType = <StatusType>[].obs;

  var companyType = <Company>[].obs;

  var companyForActionType = <Company>[].obs;

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

    final storeMasterData = GetStorage();
    var genreOfFeedbacks = storeMasterData.read('genre');

    if (genreOfFeedbacks != null) {
      genreOfFeedbacks
          .split(':')
          .forEach((data) => genreTypes.add(Genre(data)));
    }
  }

  getCategory() async {
    categoryTypes.clear();

    var response = await BaseClient().dioPost('/search-category', null);
    if (response != null) {
      if (response['success']) {
        response['data']
            .forEach((data) => categoryTypes.add(Category(data.toString())));
      }
    }
  }

  getSubCategory(List selectedCategory) async {
    subCategoryTypes.clear();

    var data = {
      'category': selectedCategory,
    };

    var response =
        await BaseClient().dioPost('/search-sub-category', json.encode(data));
    if (response != null) {
      if (response['success']) {
        response['data'].forEach(
            (data) => subCategoryTypes.add(SubCategory(data.toString())));
      }
    }
  }

  getFeedbackType() {
    feedbackType.clear();
    feedbackType.add(FeedbackType("1", "Observation"));
    feedbackType.add(FeedbackType("2", "Action"));
  }

  getTradeType() {
    tradeType.clear();
    tradeType.add(TradeType("1", "General Trade"));
    tradeType.add(TradeType("2", "Modern Trade"));
  }

  getStatusType() {
    statusType.clear();
    statusType.add(StatusType("200", "In Progress"));
    statusType.add(StatusType("300", "Closed"));
  }

  getCompany() {
    companyType.clear();
    companyType.add(Company("ITC"));
    companyType.add(Company("Direct Competitor"));
    companyType.add(Company("Other Player"));
  }

  getCompanyForAction() {
    companyForActionType.clear();
    companyForActionType.add(Company("ITC"));
  }
}
