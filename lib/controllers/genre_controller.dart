import 'package:empulse/models/genre.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class GenreController extends GetxController {
  var genreTypes = <Genre>[].obs;

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
}
