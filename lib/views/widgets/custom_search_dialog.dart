import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

import '../../controllers/feedback_controller.dart';
import '../../controllers/genre_controller.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      insetPadding: EdgeInsets.only(top: kToolbarHeight + 30.h),
      alignment: Alignment.topCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: isFilterClicked ? Get.height * 0.63 : 150,
        decoration: const BoxDecoration(
          // color: Colors.white,
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
                  hintStyle: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.5)),
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      width: 1,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
                style: TextStyle(color: Theme.of(context).primaryColor),
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
                                    popupProps: PopupPropsMultiSelection.menu(
                                      showSelectedItems: true,
                                      menuProps: MenuProps(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 12.0, top: 6.0, bottom: 6.0),
                                        hintText: "Choose one or more genre",
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5)),
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                    items: _genreController.genreTypes
                                        .map((element) => element.genre)
                                        .toList(),
                                    selectedItems: feedbackController
                                        .selectedGenreOfFeedback
                                        .cast(),
                                    onChanged: (values) {
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
                                    popupProps: PopupPropsMultiSelection.menu(
                                      showSelectedItems: true,
                                      menuProps: MenuProps(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      constraints: const BoxConstraints(
                                        maxHeight: 180,
                                      ),
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 12.0, top: 6.0, bottom: 6.0),
                                        hintText:
                                            "Choose one or more feedback type",
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5)),
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                    items: _genreController.feedbackType
                                        .map((element) => element.feedbackName)
                                        .toList(),
                                    selectedItems: feedbackController
                                        .showSelectedTypeOfFeedback
                                        .cast(),
                                    onChanged: (values) {
                                      feedbackController.selectedTypeOfFeedback
                                          .clear();
                                      feedbackController
                                          .showSelectedTypeOfFeedback
                                          .clear();

                                      feedbackController.selectedPostStatus
                                          .clear();
                                      feedbackController.showSelectedPostStatus
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
                                      feedbackController
                                          .showSelectedTypeOfFeedback
                                          .addAll(values);
                                      if (feedbackController
                                          .selectedTypeOfFeedback
                                          .contains('1')) {
                                        feedbackController
                                            .isObservationType.value = true;
                                      } else {
                                        feedbackController
                                            .isObservationType.value = false;
                                      }
                                      if (feedbackController
                                          .selectedTypeOfFeedback
                                          .contains('2')) {
                                        feedbackController.isActionType.value =
                                            true;
                                      } else {
                                        feedbackController.isActionType.value =
                                            false;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  DropdownSearch<String>.multiSelection(
                                    popupProps: PopupPropsMultiSelection.menu(
                                      showSelectedItems: true,
                                      menuProps: MenuProps(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      constraints: const BoxConstraints(
                                        maxHeight: 230,
                                      ),
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 12.0, top: 6.0, bottom: 6.0),
                                        hintText: "Choose one or more company",
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5)),
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                    items: feedbackController.isActionType.value
                                        ? _genreController.companyForActionType
                                            .map((element) =>
                                                element.companyName)
                                            .toList()
                                        : _genreController.companyType
                                            .map((element) =>
                                                element.companyName)
                                            .toList(),
                                    selectedItems: feedbackController
                                        .selectedCompanyType
                                        .cast(),
                                    onChanged: (values) {
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
                                    popupProps: PopupPropsMultiSelection.menu(
                                      showSelectedItems: true,
                                      menuProps: MenuProps(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      constraints: const BoxConstraints(
                                        maxHeight: 180,
                                      ),
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 12.0, top: 6.0, bottom: 6.0),
                                        hintText:
                                            "Choose one or more type of trade",
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5)),
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                    items: _genreController.tradeType
                                        .map((element) => element.tradeName)
                                        .toList(),
                                    selectedItems: feedbackController
                                        .showSelectedTradeType
                                        .cast(),
                                    onChanged: (values) {
                                      feedbackController.selectedTradeType
                                          .clear();
                                      feedbackController.showSelectedTradeType
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
                                        feedbackController.showSelectedTradeType
                                            .add(data);
                                      }
                                    },
                                  ),
                                  feedbackController.isObservationType.value
                                      ? Container()
                                      : SizedBox(
                                          height: 10.h,
                                        ),
                                  feedbackController.isObservationType.value
                                      ? Container()
                                      : DropdownSearch<String>.multiSelection(
                                          popupProps:
                                              PopupPropsMultiSelection.menu(
                                            showSelectedItems: true,
                                            searchFieldProps:
                                                const TextFieldProps(
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            menuProps: MenuProps(
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                            constraints: const BoxConstraints(
                                              maxHeight: 180,
                                            ),
                                          ),
                                          dropdownDecoratorProps:
                                              DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 12.0,
                                                      top: 6.0,
                                                      bottom: 6.0),
                                              hintText:
                                                  "Choose one or more status of feedback",
                                              hintStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.5)),
                                              isDense: true,
                                              border:
                                                  const OutlineInputBorder(),
                                            ),
                                          ),
                                          items: _genreController.statusType
                                              .map((element) =>
                                                  element.statusName)
                                              .toList(),
                                          selectedItems: feedbackController
                                              .showSelectedPostStatus
                                              .cast(),
                                          onChanged: (values) {
                                            feedbackController
                                                .selectedPostStatus
                                                .clear();
                                            feedbackController
                                                .showSelectedPostStatus
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
                                              feedbackController
                                                  .showSelectedPostStatus
                                                  .add(data);
                                            }
                                          },
                                        ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  DropdownSearch<String>.multiSelection(
                                    popupProps: PopupPropsMultiSelection.menu(
                                      showSelectedItems: true,
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: OutlineInputBorder(),
                                        ),
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      menuProps: MenuProps(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 12.0, top: 6.0, bottom: 6.0),
                                        hintText: "Choose one or more category",
                                        hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5)),
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                    items: _genreController.categoryTypes
                                        .map((element) => element.categoryName)
                                        .toList(),
                                    selectedItems: feedbackController
                                        .selectedCategory
                                        .cast(),
                                    onChanged: (values) {
                                      feedbackController.selectedCategory
                                          .clear();
                                      feedbackController.selectedSubCategory
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
                                          popupProps:
                                              PopupPropsMultiSelection.menu(
                                            showSelectedItems: true,
                                            showSearchBox: true,
                                            searchFieldProps: TextFieldProps(
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                border: OutlineInputBorder(),
                                              ),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            menuProps: MenuProps(
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                          ),
                                          dropdownDecoratorProps:
                                              DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 12.0,
                                                      top: 6.0,
                                                      bottom: 6.0),
                                              hintText:
                                                  "Choose one or more sub category",
                                              hintStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.5)),
                                              isDense: true,
                                              border:
                                                  const OutlineInputBorder(),
                                            ),
                                          ),
                                          items: _genreController
                                              .subCategoryTypes
                                              .map((element) =>
                                                  element.subCategoryName)
                                              .toList(),
                                          selectedItems: feedbackController
                                              .selectedSubCategory
                                              .cast(),
                                          onChanged: (values) {
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SearchFilterButton(
                      text: "Clear All",
                      icon: null,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        feedbackController.txtSearch.text = '';
                        _genreController.clearAllData(feedbackController);
                        _genreController.getAllData();
                        feedbackController.search(widget.isMyFeedback);
                        setState(() {
                          isFilterClicked = false;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    isFilterClicked
                        ? SearchFilterButton(
                            text: "Cancel Filter",
                            icon: Icons.filter_alt_off_outlined,
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _genreController.clearAllData(feedbackController);
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
                                isFilterClicked = true;
                              });
                            },
                          ),
                    const SizedBox(
                      width: 7,
                    ),
                    SearchFilterButton(
                      text: "Search",
                      icon: Icons.search,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        feedbackController.search(widget.isMyFeedback);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
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
      child: MaterialButton(
        color: const Color(0xff24aaff),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (icon != null)
                ? Icon(
                    icon,
                    color: Colors.white,
                    size: 20.sp,
                  )
                : Container(),
            (icon != null)
                ? SizedBox(
                    width: 2.w,
                  )
                : Container(),
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
