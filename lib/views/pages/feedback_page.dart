import 'dart:io';

import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/market_controller.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:empulse/views/widgets/feedback_field_info.dart';
import 'package:empulse/controllers/genre_controller.dart';
import 'package:empulse/controllers/image_controller.dart';
import 'package:empulse/controllers/insert_feedback_controller.dart';
import 'package:empulse/controllers/location_controller.dart';
import 'package:empulse/controllers/product_controller.dart';
import 'package:empulse/models/genre.dart';
import 'package:empulse/models/product_model.dart';
import 'package:empulse/views/pages/location_mandatory.dart';
import 'package:empulse/views/widgets/custom_show_image.dart';
import 'package:empulse/views/widgets/custom_slider_switch.dart';
import 'package:empulse/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/instance_manager.dart';
import 'package:location/location.dart';

class FeedbackPage extends StatefulWidget {
  final Function callback;
  const FeedbackPage({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var insertFeedbackController = Get.put(InsertFeedbackController());
  final TextEditingController _outletValue = TextEditingController();
  final TextEditingController _txtProductValue = TextEditingController();
  final TextEditingController _txtMarketValue = TextEditingController();
  bool val = false, showSelectedGenre = false, isEmptyFeedbackType = false;
  // String feedbackType = "1";
  bool isGeneralTrade = true;
  bool isModernTrade = false;
  bool isBtn1Active =
      true; // isBtn1Active -> use to indicate company type ITC is selected.
  bool isBtn2Active =
      false; // isBtn2Active -> use to indicate company type Direct Competitor is selected.
  bool isBtn3Active =
      false; // isBtn3Active -> use to indicate company type Other Player is selected.

  final _suggestionsBoxController = SuggestionsBoxController();
  final _productController = Get.put(ProductController());
  final _genreController = Get.put(GenreController());
  final _marketController = Get.put(MarketNameController());
  String? selectedGenreOfFeedback, selectedProductValue;
  List<Genre> genreOfFeedback = [];
  final _cameraController = ImageController(quality: 70);
  final _cameraController1 = ImageController(quality: 70);
  final _cameraController2 = ImageController(quality: 70);
  List<String> marketList = [];
  @override
  void initState() {
    super.initState();
    insertFeedbackController.feedbackType.text = "1";
    getData();
    getLocationData();
    // getMarketLists();
  }

  getData() {
    if (mounted) {
      _genreController.getGenre();
      setState(() {
        genreOfFeedback = _genreController.genreTypes;
        // _marketController.getMarketList();
        // marketList = _marketController.marketList;
      });
    }
  }

  LocationData? locale;
  getLocationData() async {
    try {
      locale = await getUserLocation();
    } catch (e) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LocationMadatoryNeeded(),
        ),
      );
    }
    // setState(() {});
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _cameraController1.dispose();
    _cameraController2.dispose();
    _outletValue.dispose();
    _txtProductValue.dispose();
    super.dispose();
  }

  void insertData(BuildContext context) {
    insertFeedbackController.productId.text = selectedProductValue.toString();
    insertFeedbackController.genre.text = selectedGenreOfFeedback.toString();
    insertFeedbackController.latitude.text = locale!.latitude.toString();
    insertFeedbackController.longitude.text = locale!.longitude.toString();
    if (isBtn1Active) {
      insertFeedbackController.companyName.text = 'ITC';
    } else if (isBtn2Active) {
      insertFeedbackController.companyName.text = 'Direct Competitor';
    } else {
      insertFeedbackController.companyName.text = 'Other Player';
    }
    if (isGeneralTrade) {
      insertFeedbackController.trade.text = '1';
    } else {
      insertFeedbackController.trade.text = '2';
    }

    if (_cameraController.selectedImagePath.value != '') {
      insertFeedbackController.file1 =
          File(_cameraController.selectedImagePath.value);
    }
    if (_cameraController1.selectedImagePath.value != '') {
      insertFeedbackController.file2 =
          File(_cameraController1.selectedImagePath.value);
    }
    if (_cameraController2.selectedImagePath.value != '') {
      insertFeedbackController.file3 =
          File(_cameraController2.selectedImagePath.value);
    }
    insertFeedbackController.insertFeedback(context, widget.callback);
    setState(() {
      selectedProductValue = null;
      _txtProductValue.clear();
      selectedGenreOfFeedback = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Feedback",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(child: feedbackInfo());
                },
              );
            },
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          _cameraController.selectedImagePath.value = '';
          _cameraController.isImageSelected.value = false;
          _cameraController1.selectedImagePath.value = '';
          _cameraController1.isImageSelected.value = false;
          _cameraController2.selectedImagePath.value = '';
          _cameraController2.isImageSelected.value = false;
          return true;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextfield(
                    hintText: "Enter Outlet name *",
                    textEditingController: insertFeedbackController.outletName,
                    keyboardType: TextInputType.name,
                    obsecureTxt: false,
                    suffixIcon: false,
                    fullBorder: false,
                    centerText: false,
                    validation: () {
                      insertFeedbackController.outletName.text =
                          insertFeedbackController.outletName.text.trim();
                      if (insertFeedbackController.outletName.text.isEmpty) {
                        return "Outlet name is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  TypeAheadFormField(
                    hideSuggestionsOnKeyboardHide: true,
                    suggestionsBoxDecoration: SuggestionsBoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        constraints: const BoxConstraints(maxHeight: 300)),
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _txtMarketValue,
                      decoration: InputDecoration(
                        hintText: "Search Market",
                        hintStyle: TextStyle(
                            fontFamily: AppFonts.regularFont,
                            fontSize: 16.sp,
                            color: Colors.black12.withOpacity(0.5)),
                      ),
                    ),
                    suggestionsBoxController: _suggestionsBoxController,
                    debounceDuration: const Duration(milliseconds: 800),
                    keepSuggestionsOnLoading: false,
                    suggestionsCallback: (query) {
                      return _marketController.getMarketList(query);
                    },
                    onSuggestionSelected: (marketName) {
                      _txtMarketValue.text = marketName.toString();
                      insertFeedbackController.marketName.text =
                          marketName.toString();
                      insertFeedbackController.isMarketSelected.text = '1';
                      setState(() {});
                    },
                    itemBuilder: (context, suggestion) {
                      final String marketName = suggestion.toString();
                      return ListTile(
                        title: Text(
                          marketName.trim(),
                          style: TextStyle(
                            fontFamily: "RobotoCondensed",
                            fontSize: 16.sp,
                          ),
                        ),
                      );
                    },
                    noItemsFoundBuilder: (context) {
                      // print("======> ${_txtMarketValue.text}");
                      // print(_txtMarketValue);
                      insertFeedbackController.marketName.text =
                          _txtMarketValue.text;
                      insertFeedbackController.isMarketSelected.text = '0';
                      return SizedBox(
                        height: 50.h,
                        child: const Center(
                          child: Text("Market not found"),
                        ),
                      );
                    },
                  ),
                  // CustomTextfield(
                  //   hintText: "Enter Market name",
                  //   textEditingController: insertFeedbackController.marketName,
                  //   keyboardType: TextInputType.name,
                  //   obsecureTxt: false,
                  //   suffixIcon: false,
                  //   fullBorder: false,
                  //   centerText: false,
                  //   validation: () {
                  //     // if (insertFeedbackController.marketName.text.isEmpty) {
                  //     //   return "Market name is required";
                  //     // } else {
                  //     return null;
                  //     // }
                  //   },
                  // ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          color: isGeneralTrade
                              ? const Color(0xff108ab3)
                              : Colors.transparent,
                          border: const Border(
                            top: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                            bottom: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                            left: BorderSide(
                                style: BorderStyle.solid, color: Colors.grey),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isGeneralTrade = true;
                              isModernTrade = false;
                            });
                            insertFeedbackController.trade.text = 1.toString();
                          },
                          child: Text(
                            "General Trade",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: AppFonts.regularFont,
                              fontWeight: isGeneralTrade == true
                                  ? FontWeight.w900
                                  : FontWeight.normal,
                              color: isGeneralTrade == true
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                          color: isModernTrade
                              ? const Color(0xff108ab3)
                              : Colors.transparent,
                          border: const Border(
                            top: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                            bottom: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                            right: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isModernTrade = true;
                              isGeneralTrade = false;
                            });
                            insertFeedbackController.trade.text = 2.toString();
                          },
                          child: Text(
                            "Modern Trade",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: AppFonts.regularFont,
                              fontWeight: isModernTrade == true
                                  ? FontWeight.w900
                                  : FontWeight.normal,
                              color: isModernTrade == true
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Feedback Type *",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            fontFamily: AppFonts.regularFont,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        GestureDetector(
                          onTap: () => DialogHelper.showInfoToast(
                              description: 'Please slide the button to use.'),
                          child: CustomSliderSwitch(
                            controller: insertFeedbackController,
                            feedbackType: (v) {
                              if (v == "1" || v == "2") {
                                setState(() {
                                  isBtn2Active = isBtn3Active = false;
                                  isBtn1Active = true;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  (isEmptyFeedbackType)
                      ? Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Text("Select type of feedback to proceed",
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 12.0,
                                )),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          color: isBtn1Active
                              ? const Color(0xff108ab3)
                              : Colors.transparent,
                          border: const Border(
                            top: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                            bottom: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                            left: BorderSide(
                                style: BorderStyle.solid, color: Colors.grey),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (insertFeedbackController.feedbackType.text ==
                                '') {
                              DialogHelper.showInfoToast(
                                  description:
                                      'Please select Feedback Type first');
                            } else {
                              setState(() {
                                isBtn1Active = true;
                                isBtn2Active =
                                    isBtn3Active = showSelectedGenre = false;
                                _txtProductValue.clear();
                                // _txtMarketValue.clear();
                                selectedProductValue = null;
                                selectedGenreOfFeedback = null;
                                insertFeedbackController.feedback.clear();
                                insertFeedbackController.category.clear();
                                insertFeedbackController.subCategory.clear();
                              });
                              insertFeedbackController.companyName.text = 'ITC';
                            }
                          },
                          child: Text(
                            "ITC",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: AppFonts.regularFont,
                              fontWeight: isBtn1Active == true
                                  ? FontWeight.w900
                                  : FontWeight.normal,
                              color: isBtn1Active == true
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                          color: isBtn2Active
                              ? const Color(0xff108ab3)
                              : Colors.transparent,
                          border: const Border(
                            top: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                            bottom: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // print(insertFeedbackController.feedbackType.text);
                            if (insertFeedbackController.feedbackType.text ==
                                '') {
                              DialogHelper.showInfoToast(
                                  description:
                                      'Please select Feedback Type first');
                            } else if (insertFeedbackController
                                    .feedbackType.text ==
                                '1') {
                              setState(() {
                                isBtn2Active = true;
                                isBtn1Active =
                                    isBtn3Active = showSelectedGenre = false;
                                _txtProductValue.clear();
                                selectedProductValue = null;
                                selectedGenreOfFeedback = null;
                                insertFeedbackController.feedback.clear();
                                insertFeedbackController.category.clear();
                                insertFeedbackController.subCategory.clear();
                              });
                              insertFeedbackController.companyName.text =
                                  'Direct Competitor';
                            } else {
                              DialogHelper.showInfoToast(
                                  description:
                                      'You can select Direct Competitor or Other Player if the Feedback type is OBSERVATION');
                            }
                          },
                          child: Text(
                            "Direct Competitor",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: AppFonts.regularFont,
                              fontWeight: isBtn2Active == true
                                  ? FontWeight.w900
                                  : FontWeight.normal,
                              color: isBtn2Active == true
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          color: isBtn3Active
                              ? const Color(0xff108ab3)
                              : Colors.transparent,
                          border: const Border(
                            top: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                            bottom: BorderSide(
                                style: BorderStyle.solid,
                                width: 1,
                                color: Colors.grey),
                            right: BorderSide(
                                style: BorderStyle.solid, color: Colors.grey),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (insertFeedbackController.feedbackType.text ==
                                '') {
                              DialogHelper.showInfoToast(
                                  description:
                                      'Please select Feedback Type first');
                            } else if (insertFeedbackController
                                    .feedbackType.text ==
                                '1') {
                              setState(() {
                                isBtn3Active = true;
                                isBtn1Active =
                                    isBtn2Active = showSelectedGenre = false;
                                _txtProductValue.clear();
                                selectedProductValue = null;
                                selectedGenreOfFeedback = null;
                                insertFeedbackController.feedback.clear();
                                insertFeedbackController.category.clear();
                                insertFeedbackController.subCategory.clear();
                              });
                              insertFeedbackController.companyName.text =
                                  'Other Player';
                            } else {
                              DialogHelper.showInfoToast(
                                  description:
                                      'You can select Direct Competitor or Other Player if the Feedback type is OBSERVATION');
                            }
                          },
                          child: Text(
                            "Other Player",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: AppFonts.regularFont,
                              fontWeight: isBtn3Active == true
                                  ? FontWeight.w900
                                  : FontWeight.normal,
                              color: isBtn3Active == true
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  (isBtn1Active == true)
                      ? TypeAheadFormField<ProductModel>(
                          suggestionsBoxController: _suggestionsBoxController,
                          debounceDuration: const Duration(milliseconds: 700),
                          keepSuggestionsOnLoading: false,
                          suggestionsCallback:
                              _productController.getProductList,
                          itemBuilder: (context, suggestions) {
                            final product = suggestions;
                            return ListTile(
                              title: Text(
                                product.product.trim(),
                                style: TextStyle(
                                  // fontFamily: AppFonts.regularFont,
                                  fontFamily: "RobotoCondensed",
                                  fontSize: 16.sp,
                                ),
                              ),
                              subtitle: Text(product.caregoryDesc +
                                  " || " +
                                  product.subCategoryDesc),
                            );
                          },
                          onSuggestionSelected: (product) {
                            setState(() {});
                            _txtProductValue.text = product.product;
                            selectedProductValue = product.id;
                            insertFeedbackController.category.text =
                                product.caregoryDesc;
                            insertFeedbackController.subCategory.text =
                                product.subCategoryDesc;
                          },
                          validator: (value) {
                            if (value!.isEmpty && isBtn1Active) {
                              return 'Please select a product';
                            } else {
                              return null;
                            }
                          },
                          noItemsFoundBuilder: (context) {
                            return SizedBox(
                              height: 100.h,
                              child: const Center(
                                child: Text("Product not found"),
                              ),
                            );
                          },
                          suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              constraints:
                                  const BoxConstraints(maxHeight: 400)),
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _txtProductValue,
                            decoration: InputDecoration(
                              hintText: "Search Product",
                              hintStyle: TextStyle(
                                  fontFamily: AppFonts.regularFont,
                                  fontSize: 16.sp,
                                  color: Colors.black12.withOpacity(0.5)),
                            ),
                          ),
                        )
                      : CustomTextfield(
                          hintText: "Type product name",
                          textEditingController:
                              insertFeedbackController.productName,
                          keyboardType: TextInputType.name,
                          obsecureTxt: false,
                          suffixIcon: false,
                          fullBorder: false,
                          centerText: false,
                          validation: () {
                            // if (insertFeedbackController
                            //     .productName.text.isEmpty) {
                            //   return "Product name is required";
                            // } else {
                            return null;
                            // }
                          },
                        ),
                  (insertFeedbackController.category.text != '')
                      ? SizedBox(height: 13.h)
                      : Container(),
                  (insertFeedbackController.category.text != '')
                      ? RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: AppFonts.regularFont,
                              fontSize: 15.sp,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                text: "Category: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: insertFeedbackController.category.text,
                              ),
                              const TextSpan(
                                text: "     Sub Category: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: insertFeedbackController.subCategory.text,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 13.h,
                  ),
                  Text(
                    "Genre of Feedback *",
                    style: TextStyle(
                      fontFamily: AppFonts.regularFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                      hintText: "Select genre of feedback",
                      hintStyle: TextStyle(
                        fontFamily: AppFonts.regularFont,
                        fontSize: 16.sp,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          width: 0,
                          // style: BorderStyle.none,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: AppFonts.regularFont,
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                    validator: (value) =>
                        value == null || selectedGenreOfFeedback == null
                            ? "Select a genre of feedback"
                            : null,
                    value: selectedGenreOfFeedback,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGenreOfFeedback = newValue!;
                      });
                    },
                    items: genreOfFeedback
                        .map<DropdownMenuItem<String>>((Genre value) {
                      return DropdownMenuItem(
                        child: Text(value.genre.toString()),
                        value: value.genre,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.h),
                  CustomTextfield(
                    hintText: (selectedGenreOfFeedback != '' &&
                            selectedGenreOfFeedback != null)
                        ? "Enter Your Feedback on " +
                            selectedGenreOfFeedback! +
                            " *"
                        : "Enter Your Feedback *",
                    textEditingController: insertFeedbackController.feedback,
                    keyboardType: TextInputType.text,
                    obsecureTxt: false,
                    suffixIcon: false,
                    maxLine: 5,
                    maxLength: 500,
                    fullBorder: true,
                    centerText: false,
                    validation: () {
                      insertFeedbackController.feedback.text =
                          insertFeedbackController.feedback.text.trim();
                      if (insertFeedbackController.feedback.text.isEmpty) {
                        return "Your feedback is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomShowImage(controller: _cameraController),
                      CustomShowImage(controller: _cameraController1),
                      CustomShowImage(controller: _cameraController2),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 47.h,
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      var validate = _formKey.currentState!.validate();
                      if (insertFeedbackController.feedbackType.text == '') {
                        setState(() {
                          isEmptyFeedbackType = true;
                          validate = false;
                        });
                      }
                      if (insertFeedbackController.feedbackType.text != '') {
                        setState(() {
                          isEmptyFeedbackType = false;
                        });
                      }
                      if (validate) {
                        insertData(context);
                      }
                    },
                    color: const Color(0xff108ab3),
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                        fontFamily: AppFonts.regularFont,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffffffff),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 13.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
