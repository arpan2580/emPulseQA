import 'package:empulse/models/feedback_type.dart';
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MultiSelectDialogField(
                                  chipDisplay: MultiSelectChipDisplay.none(),
                                  dialogHeight: 300,
                                  items: _genreController.dropDownData,
                                  title: Text(
                                    "Choose genre",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  // initialValue: feedbackController
                                  //     .selectedGenreOfFeedback
                                  //     .map((e) => Genre(e))
                                  //     .toList(),
                                  selectedColor: Colors.blue,
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
                                    feedbackController.selectedGenreOfFeedback
                                        .clear();
                                    for (var data in results) {
                                      Genre str = data as Genre;
                                      feedbackController.selectedGenreOfFeedback
                                          .add(str.genre);
                                    }
                                  },
                                ),
                                Obx(
                                  () => (feedbackController
                                          .selectedGenreOfFeedback.isNotEmpty)
                                      ? SizedBox(
                                          height: 50.0,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: feedbackController
                                                  .selectedGenreOfFeedback
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 7.0),
                                                  child: ActionChip(
                                                    label: Text(feedbackController
                                                            .selectedGenreOfFeedback[
                                                        index]),
                                                    onPressed: () {},
                                                  ),
                                                );
                                              }),
                                        )
                                      : Container(),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                MultiSelectDialogField(
                                  chipDisplay: MultiSelectChipDisplay.none(),
                                  dialogHeight: 120,
                                  items:
                                      _genreController.feedbackTypeDropDownData,
                                  title: Text(
                                    "Choose type of feedback",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  // initialValue: feedbackController
                                  //     .selectedTypeOfFeedback
                                  //     .map((e) => e)
                                  //     .toList(),
                                  selectedColor: Colors.blue,
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
                                    feedbackController.selectedTypeOfFeedback
                                        .clear();
                                    for (var data in results) {
                                      feedbackController.selectedTypeOfFeedback
                                          .add(data);
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
                                Obx(
                                  () => (feedbackController
                                          .selectedTypeOfFeedback.isNotEmpty)
                                      ? SizedBox(
                                          height: 50.0,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: feedbackController
                                                  .selectedTypeOfFeedback
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 7.0),
                                                  child: ActionChip(
                                                    label: (feedbackController
                                                                    .selectedTypeOfFeedback[
                                                                index] ==
                                                            '1')
                                                        ? const Text(
                                                            "Observation")
                                                        : const Text("Action"),
                                                    onPressed: () {},
                                                  ),
                                                );
                                              }),
                                        )
                                      : Container(),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Obx(
                                  () => MultiSelectDialogField(
                                    chipDisplay: MultiSelectChipDisplay.none(),
                                    dialogHeight: 200,
                                    items: isActionType.value
                                        ? _genreController.companyForActionData
                                        : _genreController.companyDropDownData,
                                    title: Text(
                                      "Choose type of company",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    selectedColor: Colors.blue,
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
                                      feedbackController.selectedCompanyType
                                          .clear();
                                      for (var data in results) {
                                        feedbackController.selectedCompanyType
                                            .add(data);
                                      }
                                    },
                                  ),
                                ),
                                Obx(
                                  () => (feedbackController
                                          .selectedCompanyType.isNotEmpty)
                                      ? SizedBox(
                                          height: 50.0,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: feedbackController
                                                  .selectedCompanyType.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 7.0),
                                                  child: ActionChip(
                                                    label: Text(feedbackController
                                                            .selectedCompanyType[
                                                        index]),
                                                    onPressed: () {},
                                                  ),
                                                );
                                              }),
                                        )
                                      : Container(),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                MultiSelectDialogField(
                                  chipDisplay: MultiSelectChipDisplay.none(),
                                  dialogHeight: 120,
                                  items: _genreController.tradeTypeDropDownData,
                                  title: Text(
                                    "Choose type of trade",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  selectedColor: Colors.blue,
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
                                    feedbackController.selectedTradeType
                                        .clear();
                                    for (var data in results) {
                                      feedbackController.selectedTradeType
                                          .add(data);
                                    }
                                  },
                                ),
                                Obx(
                                  () => (feedbackController
                                          .selectedTradeType.isNotEmpty)
                                      ? SizedBox(
                                          height: 50.0,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: feedbackController
                                                  .selectedTradeType.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 7.0),
                                                  child: ActionChip(
                                                    label: (feedbackController
                                                                    .selectedTradeType[
                                                                index] ==
                                                            '1')
                                                        ? const Text(
                                                            "General Trade")
                                                        : const Text(
                                                            "Modern Trade"),
                                                    onPressed: () {},
                                                  ),
                                                );
                                              }),
                                        )
                                      : Container(),
                                ),
                                Obx(
                                  () => isObservationType.value
                                      ? Container()
                                      : SizedBox(
                                          height: 10.h,
                                        ),
                                ),
                                Obx(
                                  () => isObservationType.value
                                      ? Container()
                                      : MultiSelectDialogField(
                                          chipDisplay:
                                              MultiSelectChipDisplay.none(),
                                          dialogHeight: 120,
                                          items: _genreController
                                              .statusTypeDropDownData,
                                          title: Text(
                                            "Choose status of feedback",
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          selectedColor: Colors.blue,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
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
                                            feedbackController
                                                .selectedPostStatus
                                                .clear();
                                            for (var data in results) {
                                              feedbackController
                                                  .selectedPostStatus
                                                  .add(data);
                                            }
                                          },
                                        ),
                                ),
                                Obx(
                                  () => (feedbackController
                                          .selectedPostStatus.isNotEmpty)
                                      ? SizedBox(
                                          height: 50.0,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: feedbackController
                                                  .selectedPostStatus.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 7.0),
                                                  child: ActionChip(
                                                    label: (feedbackController
                                                                    .selectedPostStatus[
                                                                index] ==
                                                            '200')
                                                        ? const Text(
                                                            "In Progress")
                                                        : const Text("Closed"),
                                                    onPressed: () {},
                                                  ),
                                                );
                                              }),
                                        )
                                      : Container(),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                MultiSelectDialogField(
                                  chipDisplay: MultiSelectChipDisplay.none(),
                                  dialogHeight: 300,
                                  items: _genreController.categoryDropDownData,
                                  title: Text(
                                    "Choose category",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  selectedColor: Colors.blue,
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
                                    feedbackController.selectedCategory.clear();
                                    for (var data in results) {
                                      Category str = data as Category;
                                      feedbackController.selectedCategory
                                          .add(str.categoryName);
                                    }
                                    _genreController.getSubCategory(
                                        feedbackController.selectedCategory);
                                  },
                                ),
                                Obx(
                                  () => (feedbackController
                                          .selectedCategory.isNotEmpty)
                                      ? SizedBox(
                                          height: 50.0,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: feedbackController
                                                  .selectedCategory.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 7.0),
                                                  child: ActionChip(
                                                    label: Text(feedbackController
                                                            .selectedCategory[
                                                        index]),
                                                    onPressed: () {},
                                                  ),
                                                );
                                              }),
                                        )
                                      : Container(),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Obx(
                                  () => _genreController
                                          .subCategoryTypes.isNotEmpty
                                      ? MultiSelectDialogField(
                                          chipDisplay:
                                              MultiSelectChipDisplay.none(),
                                          dialogHeight: 300,
                                          items: _genreController
                                              .subCategoryDropDownData,
                                          title: Text(
                                            "Choose sub category",
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          selectedColor: Colors.blue,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                          buttonIcon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.blue,
                                          ),
                                          buttonText: Text(
                                            "Choose one or more sub category",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          onConfirm: (results) {
                                            feedbackController
                                                .selectedSubCategory
                                                .clear();
                                            for (var data in results) {
                                              SubCategory str =
                                                  data as SubCategory;
                                              feedbackController
                                                  .selectedSubCategory
                                                  .add(str.subCategoryName);
                                            }
                                          },
                                        )
                                      : Container(),
                                ),
                                Obx(
                                  () => (feedbackController
                                          .selectedSubCategory.isNotEmpty)
                                      ? SizedBox(
                                          height: 50.0,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: feedbackController
                                                  .selectedSubCategory.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 7.0),
                                                  child: ActionChip(
                                                    label: Text(feedbackController
                                                            .selectedSubCategory[
                                                        index]),
                                                    onPressed: () {},
                                                  ),
                                                );
                                              }),
                                        )
                                      : Container(),
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
                          icon: Icons.filter_alt_off_outlined,
                          onPressed: () {
                            setState(() {
                              isFilterClicked = false;
                              FocusManager.instance.primaryFocus?.unfocus();
                              feedbackController.selectedGenreOfFeedback
                                  .clear();
                              feedbackController.selectedTypeOfFeedback.clear();
                              feedbackController.selectedCompanyType.clear();
                              feedbackController.selectedTradeType.clear();
                              feedbackController.selectedPostStatus.clear();
                              feedbackController.selectedCategory.clear();
                              feedbackController.selectedSubCategory.clear();
                              _genreController.getAllData();
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
                      setState(() {
                        // isFilterClicked = false;
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
