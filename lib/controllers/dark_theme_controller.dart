import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DarkThemeController {
  static final isLoggedIn = GetStorage();
  static RxBool isDarkThemeEnabled = isLoggedIn.read("darkTheme") != null &&
          isLoggedIn.read("darkTheme") == true
      ? true.obs
      : false.obs;

  static void toggleTheme(bool isDark) {
    isLoggedIn.write("darkTheme", isDark);
    isDarkThemeEnabled.value = isDark;
  }
}
