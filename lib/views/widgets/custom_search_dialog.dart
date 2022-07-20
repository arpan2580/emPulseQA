import 'package:dropdown_search/dropdown_search.dart';
import 'package:empulse/models/feedback_type.dart';
import 'package:empulse/models/trade_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../controllers/feedback_controller.dart';
import '../../controllers/genre_controller.dart';
import '../../models/category.dart';
import '../../models/genre.dart';
import '../../models/sub_category.dart';

class CustomSearchDialog extends StatefulWidget {
  final bool isMyFeedback;
  final bool isFilterApplied;
  final GenreController genreController;
  final FeedbackController feedbackController;
  final dynamic dialogContext;
  const CustomSearchDialog({
    Key? key,
    required this.isMyFeedback,
    required this.isFilterApplied,
    required this.genreController,
    required this.feedbackController,
    required this.dialogContext,
  }) : super(key: key);

  @override
  State<CustomSearchDialog> createState() => _CustomSearchDialogState();
}

class _CustomSearchDialogState extends State<CustomSearchDialog> {
  late GenreController _genreController;
  late FeedbackController feedbackController;

  final RxBool _enabled = true.obs,
      isObservationType = false.obs,
      isActionType = false.obs;

  bool searching = false;

  bool isFilterClicked = false;

  @override
  void initState() {
    super.initState();
    _genreController = widget.genreController;
    feedbackController = widget.feedbackController;
    if (widget.isFilterApplied) {
      isFilterClicked = true;
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
                controller: feedbackController.txtSearch,
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
                            child: Obx(
                              () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownSearch<String>.multiSelection(
                                    mode: Mode.MENU,
                                    dropdownSearchDecoration:
                                        const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 12.0, top: 6.0, bottom: 6.0),
                                      hintText: "Choose one or more genre",
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    items: _genreController.genreTypes
                                        .map((element) => element.genre)
                                        .toList(),
                                    enabled: _enabled.value,
                                    showSelectedItems: true,
                                    selectedItems: feedbackController
                                        .selectedGenreOfFeedback
                                        .cast(),
                                    onChanged: (values) {
                                      print(values);
                                      feedbackController.selectedGenreOfFeedback
                                          .clear();
                                      for (var data in values) {
                                        feedbackController
                                            .selectedGenreOfFeedback
                                            .add(data);
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  DropdownSearch<String>.multiSelection(
                                    mode: Mode.MENU,
                                    dropdownSearchDecoration:
                                        const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 12.0, top: 6.0, bottom: 6.0),
                                      hintText:
                                          "Choose one or more feedback type",
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    items: _genreController.feedbackType
                                        .map((element) => element.feedbackName)
                                        .toList(),
                                    enabled: _enabled.value,
                                    showSelectedItems: true,
                                    selectedItems: feedbackController
                                        .selectedTypeOfFeedback
                                        .cast(),
                                    onChanged: (values) {
                                      feedbackController.selectedTypeOfFeedback
                                          .clear();
                                      for (var data in values) {
                                        var id = '';
                                        if (data == 'Observation') {
                                          id = '1';
                                        }
                                        if (data == 'Action') {
                                          id = '2';
                                        }
                                        feedbackController
                                            .selectedTypeOfFeedback
                                            .add(id);
                                      }
                                      if (feedbackController
                                          .selectedTypeOfFeedback
                                          .contains('1')) {
                                        isObservationType.value = true;
                                      } else {
                                        isObservationType.value = false;
                                      }
                                      if (feedbackController
                                          .selectedTypeOfFeedback
                                          .contains('2')) {
                                        isActionType.value = true;
                                      } else {
                                        isActionType.value = false;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  DropdownSearch<String>.multiSelection(
                                    mode: Mode.MENU,
                                    dropdownSearchDecoration:
                                        const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 12.0, top: 6.0, bottom: 6.0),
                                      hintText: "Choose one or more company",
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    items: isActionType.value
                                        ? _genreController.companyForActionType
                                            .map((element) =>
                                                element.companyName)
                                            .toList()
                                        : _genreController.companyType
                                            .map((element) =>
                                                element.companyName)
                                            .toList(),
                                    enabled: _enabled.value,
                                    showSelectedItems: true,
                                    selectedItems: feedbackController
                                        .selectedCompanyType
                                        .cast(),
                                    onChanged: (values) {
                                      print(values);
                                      feedbackController.selectedCompanyType
                                          .clear();
                                      for (var data in values) {
                                        feedbackController.selectedCompanyType
                                            .add(data);
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  DropdownSearch<String>.multiSelection(
                                    mode: Mode.MENU,
                                    dropdownSearchDecoration:
                                        const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 12.0, top: 6.0, bottom: 6.0),
                                      hintText:
                                          "Choose one or more type of trade",
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    items: _genreController.tradeType
                                        .map((element) => element.tradeName)
                                        .toList(),
                                    enabled: _enabled.value,
                                    showSelectedItems: true,
                                    selectedItems: feedbackController
                                        .selectedTradeType
                                        .cast(),
                                    onChanged: (values) {
                                      feedbackController.selectedTradeType
                                          .clear();
                                      for (var data in values) {
                                        var id = '';
                                        if (data == 'General Trade') {
                                          id = '1';
                                        }
                                        if (data == 'Modern Trade') {
                                          id = '2';
                                        }
                                        feedbackController.selectedTradeType
                                            .add(id);
                                      }
                                      print(feedbackController.selectedTradeType
                                          .toString());
                                    },
                                  ),
                                  isObservationType.value
                                      ? Container()
                                      : SizedBox(
                                          height: 10.h,
                                        ),
                                  isObservationType.value
                                      ? Container()
                                      : DropdownSearch<String>.multiSelection(
                                          mode: Mode.MENU,
                                          dropdownSearchDecoration:
                                              const InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 12.0,
                                                top: 6.0,
                                                bottom: 6.0),
                                            hintText:
                                                "Choose one or more status of feedback",
                                            isDense: true,
                                            border: OutlineInputBorder(),
                                          ),
                                          items: _genreController.statusType
                                              .map((element) =>
                                                  element.statusName)
                                              .toList(),
                                          enabled: _enabled.value,
                                          showSelectedItems: true,
                                          selectedItems: feedbackController
                                              .selectedPostStatus
                                              .cast(),
                                          onChanged: (values) {
                                            feedbackController
                                                .selectedPostStatus
                                                .clear();
                                            for (var data in values) {
                                              var id = '';
                                              if (data == 'In Progress') {
                                                id = '200';
                                              }
                                              if (data == 'Closed') {
                                                id = '300';
                                              }
                                              feedbackController
                                                  .selectedPostStatus
                                                  .add(id);
                                            }
                                            print(feedbackController
                                                .selectedPostStatus
                                                .toString());
                                          },
                                        ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  DropdownSearch<String>.multiSelection(
                                    mode: Mode.MENU,
                                    dropdownSearchDecoration:
                                        const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 12.0, top: 6.0, bottom: 6.0),
                                      hintText: "Choose one or more category",
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    items: _genreController.categoryTypes
                                        .map((element) => element.categoryName)
                                        .toList(),
                                    enabled: _enabled.value,
                                    showSearchBox: true,
                                    showSelectedItems: true,
                                    selectedItems: feedbackController
                                        .selectedCategory
                                        .cast(),
                                    onChanged: (values) {
                                      print(values);
                                      feedbackController.selectedCategory
                                          .clear();
                                      for (var data in values) {
                                        feedbackController.selectedCategory
                                            .add(data);
                                      }
                                      _genreController.getSubCategory(
                                          feedbackController.selectedCategory);
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  _genreController.subCategoryTypes.isNotEmpty
                                      ? DropdownSearch<String>.multiSelection(
                                          mode: Mode.MENU,
                                          dropdownSearchDecoration:
                                              const InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 12.0,
                                                top: 6.0,
                                                bottom: 6.0),
                                            hintText:
                                                "Choose one or more sub category",
                                            isDense: true,
                                            border: OutlineInputBorder(),
                                          ),
                                          items: _genreController
                                              .subCategoryTypes
                                              .map((element) =>
                                                  element.subCategoryName)
                                              .toList(),
                                          enabled: _enabled.value,
                                          showSearchBox: true,
                                          showSelectedItems: true,
                                          selectedItems: feedbackController
                                              .selectedCategory
                                              .cast(),
                                          onChanged: (values) {
                                            print(values);
                                            feedbackController
                                                .selectedSubCategory
                                                .clear();
                                            for (var data in values) {
                                              feedbackController
                                                  .selectedSubCategory
                                                  .add(data);
                                            }
                                          },
                                        )
                                      : Container(),
                                ],
                              ),
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
                          icon: Icons.filter_alt_off_outlined,
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            feedbackController.selectedGenreOfFeedback.clear();
                            feedbackController.selectedTypeOfFeedback.clear();
                            feedbackController.selectedCompanyType.clear();
                            feedbackController.selectedTradeType.clear();
                            feedbackController.selectedPostStatus.clear();
                            feedbackController.selectedCategory.clear();
                            feedbackController.selectedSubCategory.clear();
                            isObservationType.value = false;
                            isActionType.value = false;
                            _genreController.getAllData();
                            setState(() {
                              isFilterClicked = false;
                            });
                          },
                        )
                      : SearchFilterButton(
                          text: "Apply Filter",
                          icon: Icons.filter_alt_outlined,
                          onPressed: () {
                            setState(() {
                              // _enabled.value = true;
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
                      feedbackController.search(widget.isMyFeedback);
                      _enabled.value = false;
                      setState(() {
                        searching = !searching;
                      });
                      Navigator.pop(widget.dialogContext);
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
