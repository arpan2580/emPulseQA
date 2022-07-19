import 'package:empulse/models/genre.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../models/category.dart';
import '../models/sub_category.dart';
import '../services/base_client.dart';

class GenreController extends GetxController {
  var genreTypes = <Genre>[].obs;
  List<MultiSelectItem> dropDownData = [];

  var categoryTypes = <Category>[].obs;
  List<MultiSelectItem> categoryDropDownData = [];

  var subCategoryTypes = <SubCategory>[].obs;
  List<MultiSelectItem> subCategoryDropDownData = [];

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
    dropDownData.clear();

    final storeMasterData = GetStorage();
    var genreOfFeedbacks = storeMasterData.read('genre');

    if (genreOfFeedbacks != null) {
      genreOfFeedbacks
          .split(':')
          .forEach((data) => genreTypes.add(Genre(data)));

      dropDownData = genreTypes.map((data) {
        return MultiSelectItem(data, data.genre);
      }).toList();
    }
  }

  getCategory() async {
    categoryTypes.clear();
    categoryDropDownData.clear();

    var response = await BaseClient().dioPost('/search-category', null);
    print(response.toString());
    if (response != null) {
      if (response['success']) {
        response['data']
            .forEach((data) => categoryTypes.add(Category(data.toString())));
        categoryDropDownData = categoryTypes.map((data) {
          return MultiSelectItem(data, data.categoryName);
        }).toList();
      }
    }
  }
}
