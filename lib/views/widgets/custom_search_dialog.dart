import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/instance_manager.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../controllers/feedback_controller.dart';
import '../../controllers/genre_controller.dart';
import '../../models/category.dart';
import '../../models/genre.dart';

class CustomSearchDialog extends StatefulWidget {
  const CustomSearchDialog({Key? key}) : super(key: key);

  @override
  State<CustomSearchDialog> createState() => _CustomSearchDialogState();
}

class _CustomSearchDialogState extends State<CustomSearchDialog> {
  final _genreController = Get.put(GenreController());
  final feedbackController = Get.put(FeedbackController());
  List<Genre> genreOfFeedback = [];
  List<MultiSelectItem> feedbackType = ['Observation', 'Action'].map((data) {
    return MultiSelectItem(data, data);
  }).toList();
  List<MultiSelectItem> company =
      ['ITC', 'Direct Competitor', 'Other Player'].map((comp) {
    return MultiSelectItem(comp, comp);
  }).toList();
  List<MultiSelectItem> tradeType =
      ['General Trade', 'Modern Trade'].map((tradeTyp) {
    return MultiSelectItem(tradeTyp, tradeTyp);
  }).toList();
  List<MultiSelectItem> postStatus = ['In Progress', 'Closed'].map((tradeTyp) {
    return MultiSelectItem(tradeTyp, tradeTyp);
  }).toList();
  List<Category> categoryList = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List selectedGenreOfFeedback = [],
      selectedTypeOfFeedback = [],
      selectedCompanyType = [],
      selectedTradeType = [],
      selectedPostStatus = [],
      selectedCategory = [];
  final RxBool _enabled = true.obs;

  bool searching = false;

  bool isFilterClicked = false;

  @override
  void initState() {
    getData();
  }

  getData() {
    if (mounted) {
      _genreController.getGenreData();
      _genreController.getCategory();

      setState(() {
        // genreOfFeedback = _genreController.genreTypes;
        // categoryList = _genreController.categoryTypes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(top: kToolbarHeight + 30.h),
      alignment: Alignment.topCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: isFilterClicked ? Get.height * 0.65 : 150,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                15,
                16.0,
                15.0,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Search using keywords from feedback",
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      width: 1,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    isFilterClicked
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(
                              16,
                              5,
                              16.0,
                              5.0,
                            ),
                            child: Column(
                              children: [
                                MultiSelectDialogField(
                                  dialogHeight: 200,
                                  items: _genreController.dropDownData,
                                  title: Text(
                                    "Choose genre",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  selectedColor: Colors.black87,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  buttonIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.blue,
                                  ),
                                  buttonText: Text(
                                    "Choose one or more genre",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  onConfirm: (results) {
                                    selectedGenreOfFeedback = [];
                                    for (var data in results) {
                                      Genre str = data as Genre;
                                      selectedGenreOfFeedback.add(str.genre);
                                    }
                                    print("data $selectedGenreOfFeedback");
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                MultiSelectDialogField(
                                  dialogHeight: 200,
                                  items: feedbackType,
                                  title: Text(
                                    "Choose type of feedback",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  selectedColor: Colors.black87,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  buttonIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.blue,
                                  ),
                                  buttonText: Text(
                                    "Choose one or more feedback type",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  onConfirm: (results) {
                                    selectedTypeOfFeedback = [];
                                    for (var data in results) {
                                      selectedTypeOfFeedback.add(data);
                                    }
                                    print("data $selectedTypeOfFeedback");
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                MultiSelectDialogField(
                                  dialogHeight: 200,
                                  items: company,
                                  title: Text(
                                    "Choose type of company",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  selectedColor: Colors.black87,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  buttonIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.blue,
                                  ),
                                  buttonText: Text(
                                    "Choose one or more company",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  onConfirm: (results) {
                                    selectedCompanyType = [];
                                    for (var data in results) {
                                      selectedCompanyType.add(data);
                                    }
                                    print("data $selectedCompanyType");
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                MultiSelectDialogField(
                                  dialogHeight: 200,
                                  items: tradeType,
                                  title: Text(
                                    "Choose type of trade",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  selectedColor: Colors.black87,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  buttonIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.blue,
                                  ),
                                  buttonText: Text(
                                    "Choose one or more trade type",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  onConfirm: (results) {
                                    selectedTradeType = [];
                                    for (var data in results) {
                                      selectedTradeType.add(data);
                                    }
                                    print("data $selectedTradeType");
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                MultiSelectDialogField(
                                  dialogHeight: 200,
                                  items: postStatus,
                                  title: Text(
                                    "Choose status of feedback",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  selectedColor: Colors.black87,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  buttonIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.blue,
                                  ),
                                  buttonText: Text(
                                    "Choose one or more status",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  onConfirm: (results) {
                                    selectedPostStatus = [];
                                    for (var data in results) {
                                      selectedPostStatus.add(data);
                                    }
                                    print("data $selectedPostStatus");
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                MultiSelectDialogField(
                                  dialogHeight: 200,
                                  items: _genreController.categoryDropDownData,
                                  title: Text(
                                    "Choose category",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  selectedColor: Colors.black87,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  buttonIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.blue,
                                  ),
                                  buttonText: Text(
                                    "Choose one or more category",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  onConfirm: (results) {
                                    selectedCategory = [];
                                    for (var data in results) {
                                      Category str = data as Category;
                                      selectedCategory.add(str.categoryName);
                                    }
                                    print("data $selectedCategory");
                                  },
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isFilterClicked
                      ? SearchFilterButton(
                          text: "Cancel Filter",
                          icon: Icons.filter_alt_off,
                          onPressed: () {
                            setState(() {
                              isFilterClicked = false;
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                selectedGenreOfFeedback = [];
                                selectedTypeOfFeedback = [];
                                selectedCompanyType = [];
                                selectedTradeType = [];
                                selectedPostStatus = [];
                                _enabled.value = true;
                              });
                            });
                          },
                        )
                      : SearchFilterButton(
                          text: "Apply Filter",
                          icon: Icons.filter_alt_outlined,
                          onPressed: () {
                            setState(() {
                              _enabled.value = true;
                              isFilterClicked = true;
                            });
                          },
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  SearchFilterButton(
                    text: "Search",
                    icon: Icons.search,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        // isFilterClicked = false;
                        searching = !searching;
                      });
                      feedbackController.txtSearch.text = '';
                      // feedbackController
                      //     .search(index);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchFilterButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Function() onPressed;
  const SearchFilterButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3 + 10,
      child: MaterialButton(
        color: const Color(0xff24aaff),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            // Text("A"),
            const SizedBox(
              width: 5,
            ),
            Text(
              text == null ? "NULL" : text!,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
