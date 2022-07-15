import 'dart:math';

import 'package:empulse/controllers/feedback_controller.dart';
import 'package:empulse/views/pages/all_feedback_page.dart';
import 'package:empulse/views/pages/feedback_page.dart';
import 'package:empulse/views/pages/leaderboard_page.dart';
import 'package:empulse/views/pages/my_all_post.dart';
import 'package:empulse/views/pages/profile_page.dart';
import 'package:empulse/views/widgets/custom_notification_icon.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

import '../../consts/app_fonts.dart';
import '../../controllers/genre_controller.dart';
import '../../models/genre.dart';
import '../dialogs/dialog_helper.dart';

class BottomNavBar extends StatefulWidget {
  final int index;
  const BottomNavBar({Key? key, required this.index}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final storedToken = GetStorage();
  final isAppTourDone = GetStorage();

  bool isSearch = false;
  bool searching = false;

  RxInt index = 0.obs;
  // int active = 0; // FOR CHANGING THE BOTTOM ICON COLOR

  var feedbackController = Get.put(FeedbackController());
  final _genreController = Get.put(GenreController());
  List<Genre> genreOfFeedback = [];
  List feedbackType = ['Observation', 'Action'];
  List company = ['ITC', 'Direct Competitor', 'Other Player'];
  List tradeType = ['General Trade', 'Modern Trade'];
  List postStatus = ['In Progress', 'Closed', 'Observation'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedGenreOfFeedback,
      selectedTypeOfFeedback,
      selectedCompanyType,
      selectedTradeType,
      selectedPostStatus;
  final RxBool _enabled = true.obs;

  bool? shouldPop;
  @override
  void initState() {
    super.initState();
    shouldPop = false;
    index = widget.index.obs;
    // active = index.value;
    if (isAppTourDone.read('app_tour') == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        FeatureDiscovery.discoverFeatures(
          context,
          [
            'home',
            'my_posts',
            'leaderboard',
            'my_profile',
            'add_feedback',
            'notification',
          ],
        );
      });
    }
  }

  getData() {
    if (mounted) {
      _genreController.getGenre();
      setState(() {
        genreOfFeedback = _genreController.genreTypes;
      });
    }
  }

  void callback(index) {
    if (index == 1) {
      feedbackController.fetchMyFeedback();
    }

    this.index.value = index;
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardIsActive = MediaQuery.of(context).viewInsets.bottom != 0.0;
    final screens = [
      AllFeedbackPage(isSearch: isSearch, callback: callback),
      MyAllPost(isSearch: isSearch),
      const LeaderboardPage(),
      const ProfilePage()
    ];

    return WillPopScope(
      onWillPop: () async {
        shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: GestureDetector(
        onTap: () {
          FeatureDiscovery.completeCurrentStep(context);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: customAppbar(index),
          body: SafeArea(child: Obx(() => screens[index.value])),

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          // isKeyboardIsActive -> USED FOR CHECKING IN THE PROFILE SCREEN WHETHER FAB IS VISIBLE IN TOP OF KEYBOARD. BY THIS VARIABLE WE SIMPLY HIDE THE FAB WHEN KEYBOARD IS ACTIVE.
          floatingActionButton: isKeyboardIsActive
              ? null
              : SizedBox(
                  height: 61.h,
                  width: 61.w,
                  child: DescribedFeatureOverlay(
                    featureId: 'add_feedback',
                    backgroundColor: Colors.green.shade100,
                    barrierDismissible: false,
                    onBackgroundTap: () async {
                      FeatureDiscovery.completeCurrentStep(context);
                      return false;
                    },
                    description: Column(
                      children: [
                        const Text(
                          "To submit your feedback.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                FeatureDiscovery.dismissAll(context);
                                isAppTourDone.write('app_tour', 'done');
                              },
                              child: Text(
                                "Skip All",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                FeatureDiscovery.completeCurrentStep(context);
                              },
                              child: const Text("Next >"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    title: const Text(
                      "Add Feedback",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    tapTarget: SvgPicture.asset(
                      'assets/icons/Add.svg',
                      width: 23.w,
                      height: 23.h,
                      color: Colors.black,
                    ),
                    child: FloatingActionButton(
                      heroTag: Random(),
                      onPressed: () {
                        // FirebaseCrashlytics.instance.crash();
                        Get.to(
                          () => FeedbackPage(callback: callback),
                        );
                      },
                      tooltip: 'Increment',
                      backgroundColor: const Color(0xff24aaff),
                      child: SvgPicture.asset(
                        'assets/icons/Add.svg',
                        height: 21.h,
                        width: 21.w,
                      ),
                      shape: StadiumBorder(
                          side: BorderSide(
                              color: Colors.white.withOpacity(0.9), width: 4)),
                    ),
                  ),
                ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 0,
            elevation: 25,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Obx(
                      () => DescribedFeatureOverlay(
                        featureId: 'home',
                        backgroundColor: Colors.red.shade100,
                        barrierDismissible: false,
                        onBackgroundTap: () async {
                          FeatureDiscovery.completeCurrentStep(context);
                          return false;
                        },
                        description: Column(
                          children: [
                            const Text(
                              "Displays feedback posted by all emPulse app users.",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    FeatureDiscovery.dismissAll(context);
                                    isAppTourDone.write('app_tour', 'done');
                                  },
                                  child: Text(
                                    "Skip All",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FeatureDiscovery.completeCurrentStep(
                                        context);
                                  },
                                  child: const Text("Next >"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        title: const Text(
                          "Home Tab",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        tapTarget: SvgPicture.asset(
                          'assets/icons/Home.svg',
                          width: 23.w,
                          height: 23.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: const EdgeInsets.only(top: 7.0),
                              constraints: const BoxConstraints(),
                              icon: SvgPicture.asset(
                                'assets/icons/Home.svg',
                                width: 23.w,
                                height: 23.h,
                                color: index.value != 0
                                    ? Colors.black
                                    : const Color(0xff24aaff),
                              ),
                              onPressed: () {
                                index.value = 0;
                              },
                            ),
                            GestureDetector(
                              onTap: () => index.value = 0,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "Home",
                                  style: TextStyle(
                                    // backgroundColor: Color(0xff24aaff),
                                    color: index.value == 0
                                        ? const Color(0xff24aaff)
                                        : Colors.black45,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => DescribedFeatureOverlay(
                        featureId: 'my_posts',
                        backgroundColor: Colors.yellow.shade100,
                        barrierDismissible: false,
                        onBackgroundTap: () async {
                          FeatureDiscovery.completeCurrentStep(context);
                          return false;
                        },
                        description: Column(
                          children: [
                            const Text(
                              "Displays feedback posted by you & actions for closure remarks assigned to you.",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    FeatureDiscovery.dismissAll(context);
                                    isAppTourDone.write('app_tour', 'done');
                                  },
                                  child: Text(
                                    "Skip All",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FeatureDiscovery.completeCurrentStep(
                                        context);
                                  },
                                  child: const Text("Next >"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        title: const Text(
                          "My Posts Tab",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        tapTarget: SvgPicture.asset(
                          'assets/icons/My-feedback.svg',
                          width: 23.w,
                          height: 23.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: const EdgeInsets.only(top: 7.0),
                              constraints: const BoxConstraints(),
                              icon: SvgPicture.asset(
                                'assets/icons/My-feedback.svg',
                                width: 23.w,
                                height: 25.h,
                                color: index.value != 1
                                    ? Colors.black
                                    : const Color(0xff24aaff),
                              ),
                              onPressed: () {
                                index.value = 1;
                              },
                            ),
                            GestureDetector(
                              onTap: () => index.value = 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "My Posts",
                                  style: TextStyle(
                                    // backgroundColor: Color(0xff24aaff),
                                    color: index.value == 1
                                        ? const Color(0xff24aaff)
                                        : Colors.black45,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // const Expanded(child: Text('')),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Obx(
                      () => DescribedFeatureOverlay(
                        featureId: 'leaderboard',
                        backgroundColor: Colors.blue.shade100,
                        barrierDismissible: false,
                        onBackgroundTap: () async {
                          FeatureDiscovery.completeCurrentStep(context);
                          return false;
                        },
                        description: Column(
                          children: [
                            const Text(
                              "Display list of top emPulse app users.",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    FeatureDiscovery.dismissAll(context);
                                    isAppTourDone.write('app_tour', 'done');
                                  },
                                  child: Text(
                                    "Skip All",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FeatureDiscovery.completeCurrentStep(
                                        context);
                                  },
                                  child: const Text("Next >"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        title: const Text(
                          "Leaderboard Tab",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        tapTarget: SvgPicture.asset(
                          'assets/icons/Graph.svg',
                          width: 23.w,
                          height: 23.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: const EdgeInsets.only(top: 7.0),
                              constraints: const BoxConstraints(),
                              icon: SvgPicture.asset(
                                'assets/icons/Graph.svg',
                                width: 23.w,
                                height: 23.h,
                                color: index.value != 2
                                    ? Colors.black
                                    : const Color(0xff24aaff),
                              ),
                              onPressed: () {
                                index.value = 2;
                              },
                            ),
                            GestureDetector(
                              onTap: () => index.value = 2,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "Leaderboard",
                                  style: TextStyle(
                                    // backgroundColor: Color(0xff24aaff),
                                    color: index.value == 2
                                        ? const Color(0xff24aaff)
                                        : Colors.black45,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => DescribedFeatureOverlay(
                        featureId: 'my_profile',
                        backgroundColor: Colors.red.shade100,
                        barrierDismissible: false,
                        onBackgroundTap: () async {
                          FeatureDiscovery.completeCurrentStep(context);
                          return false;
                        },
                        description: Column(
                          children: [
                            const Text(
                              "To update your status, photo and view your participation in emPulse.",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    FeatureDiscovery.dismissAll(context);
                                    isAppTourDone.write('app_tour', 'done');
                                  },
                                  child: Text(
                                    "Skip All",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FeatureDiscovery.completeCurrentStep(
                                        context);
                                  },
                                  child: const Text("Next >"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        title: const Text(
                          "My Profile Tab",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        tapTarget: SvgPicture.asset(
                          'assets/icons/Profile.svg',
                          width: 23.w,
                          height: 23.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: const EdgeInsets.only(top: 7.0),
                              constraints: const BoxConstraints(),
                              icon: SvgPicture.asset(
                                'assets/icons/Profile.svg',
                                width: 23.w,
                                height: 23.h,
                                color: index.value != 3
                                    ? Colors.black
                                    : const Color(0xff24aaff),
                              ),
                              onPressed: () {
                                index.value = 3;
                              },
                            ),
                            GestureDetector(
                              onTap: () => index.value = 3,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "My Profile",
                                  style: TextStyle(
                                    // backgroundColor: Color(0xff24aaff),
                                    color: index.value == 3
                                        ? const Color(0xff24aaff)
                                        : Colors.black45,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showWarning(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text("Exit App"),
            content: const Text("Press confirm to Exit the Application"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("No")),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Confirm")),
            ],
          );
        });
  }

  AppBar customAppbar(index) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      title: Image(
        image: const AssetImage('assets/images/Logo_empulse.png'),
        height: 50.h,
      ),
      // leadingWidth: 40.w,
      actions: [
        DescribedFeatureOverlay(
          featureId: 'searchFilter',
          backgroundColor: Colors.green.shade100,
          barrierDismissible: false,
          onComplete: () async {
            isAppTourDone.write('app_tour', 'done');
            return true;
          },
          onBackgroundTap: () async {
            isAppTourDone.write('app_tour', 'done');
            FeatureDiscovery.completeCurrentStep(context);
            return true;
          },
          description: Column(
            children: [
              const Text(
                "Search & Filter feedbacks.",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      FeatureDiscovery.dismissAll(context);
                      isAppTourDone.write('app_tour', 'done');
                    },
                    child: Text(
                      "Skip All",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      FeatureDiscovery.completeCurrentStep(context);
                      isAppTourDone.write("app_tour", "done");
                    },
                    child: const Text("Done"),
                  ),
                ],
              ),
            ],
          ),
          title: const Text(
            "Search and Filter Tab",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          tapTarget: SvgPicture.asset(
            'assets/icons/Search.svg',
            height: 29.h,
            width: 29.w,
          ),
          child: IconButton(
            onPressed: () {
              feedbackController.txtSearch.text = '';
              setState(() {
                isSearch = !isSearch;
              });
              showGeneralDialog(
                barrierLabel: "search",
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 400),
                context: context,
                pageBuilder: (context, anim1, anim2) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 61.h,
                      child: Material(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search feedback",
                            contentPadding: const EdgeInsets.all(5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: InkWell(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  getData();

                                  // setState(() {
                                  //   searching = !searching;
                                  // });
                                  // feedbackController.search(index);

                                  // FilterDialog().openFilterDialog(
                                  //     context,
                                  //     genreOfFeedback,
                                  //     feedbackType,
                                  //     company,
                                  //     tradeType,
                                  //     postStatus);

                                  showGeneralDialog(
                                    barrierLabel: "filter",
                                    barrierDismissible: false,
                                    barrierColor: Colors.black.withOpacity(0.1),
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                    context: context,
                                    pageBuilder: (context, anim1, anim2) {
                                      return Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: Get.height * 0.55,
                                          width: Get.width,
                                          child: Form(
                                            key: _formKey,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(13.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Material(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10.0),
                                                      child: Text(
                                                        "Apply Filter",
                                                        style: TextStyle(
                                                          fontFamily: AppFonts
                                                              .regularFont,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: MediaQuery
                                                        .removePadding(
                                                      context: context,
                                                      removeTop: true,
                                                      child: Obx(
                                                        () => ListView(
                                                          children: [
                                                            Material(
                                                              child: Text(
                                                                "Genre of Feedback",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .regularFont,
                                                                  // fontWeight: FontWeight.w700,
                                                                  fontSize:
                                                                      16.sp,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Material(
                                                              child:
                                                                  DropdownButtonFormField(
                                                                isExpanded:
                                                                    true,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Choose genre of feedback",
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .regularFont,
                                                                    fontSize:
                                                                        16.sp,
                                                                  ),
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          15,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      width: 0,
                                                                      // style: BorderStyle.none,
                                                                    ),
                                                                  ),
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .regularFont,
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                                value:
                                                                    selectedGenreOfFeedback,
                                                                onChanged: _enabled
                                                                        .value
                                                                    ? (String?
                                                                        newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedGenreOfFeedback =
                                                                              newValue!;
                                                                        });
                                                                      }
                                                                    : null,
                                                                items: genreOfFeedback.map<
                                                                    DropdownMenuItem<
                                                                        String>>((Genre
                                                                    value) {
                                                                  return DropdownMenuItem(
                                                                    child: Text(value
                                                                        .genre
                                                                        .toString()),
                                                                    value: value
                                                                        .genre,
                                                                  );
                                                                }).toList(),
                                                                disabledHint:
                                                                    selectedGenreOfFeedback !=
                                                                            null
                                                                        ? Text(selectedGenreOfFeedback
                                                                            .toString())
                                                                        : null,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Material(
                                                              child: Text(
                                                                "Feedback Type",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .regularFont,
                                                                  // fontWeight: FontWeight.w700,
                                                                  fontSize:
                                                                      16.sp,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Material(
                                                              child:
                                                                  DropdownButtonFormField(
                                                                isExpanded:
                                                                    true,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Choose type of feedback",
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .regularFont,
                                                                    fontSize:
                                                                        16.sp,
                                                                  ),
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          15,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      width: 0,
                                                                      // style: BorderStyle.none,
                                                                    ),
                                                                  ),
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .regularFont,
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                                value:
                                                                    selectedTypeOfFeedback,
                                                                onChanged: _enabled
                                                                        .value
                                                                    ? (String?
                                                                        newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedTypeOfFeedback =
                                                                              newValue!;
                                                                        });
                                                                      }
                                                                    : null,
                                                                items: feedbackType.map<
                                                                        DropdownMenuItem<
                                                                            String>>(
                                                                    (value) {
                                                                  return DropdownMenuItem(
                                                                    child: Text(
                                                                        value
                                                                            .toString()),
                                                                    value:
                                                                        value,
                                                                  );
                                                                }).toList(),
                                                                disabledHint:
                                                                    selectedTypeOfFeedback !=
                                                                            null
                                                                        ? Text(selectedTypeOfFeedback
                                                                            .toString())
                                                                        : null,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Material(
                                                              child: Text(
                                                                "Company",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .regularFont,
                                                                  // fontWeight: FontWeight.w700,
                                                                  fontSize:
                                                                      16.sp,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Material(
                                                              child:
                                                                  DropdownButtonFormField(
                                                                isExpanded:
                                                                    true,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Choose Company",
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .regularFont,
                                                                    fontSize:
                                                                        16.sp,
                                                                  ),
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          15,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      width: 0,
                                                                      // style: BorderStyle.none,
                                                                    ),
                                                                  ),
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .regularFont,
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                                value:
                                                                    selectedCompanyType,
                                                                onChanged: _enabled
                                                                        .value
                                                                    ? (String?
                                                                        newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedCompanyType =
                                                                              newValue!;
                                                                        });
                                                                      }
                                                                    : null,
                                                                items: company.map<
                                                                        DropdownMenuItem<
                                                                            String>>(
                                                                    (value) {
                                                                  return DropdownMenuItem(
                                                                    child: Text(
                                                                        value
                                                                            .toString()),
                                                                    value:
                                                                        value,
                                                                  );
                                                                }).toList(),
                                                                disabledHint:
                                                                    selectedCompanyType !=
                                                                            null
                                                                        ? Text(selectedCompanyType
                                                                            .toString())
                                                                        : null,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Material(
                                                              child: Text(
                                                                "Trade Type",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .regularFont,
                                                                  // fontWeight: FontWeight.w700,
                                                                  fontSize:
                                                                      16.sp,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Material(
                                                              child:
                                                                  DropdownButtonFormField(
                                                                isExpanded:
                                                                    true,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Choose trade type",
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .regularFont,
                                                                    fontSize:
                                                                        16.sp,
                                                                  ),
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          15,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      width: 0,
                                                                      // style: BorderStyle.none,
                                                                    ),
                                                                  ),
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .regularFont,
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                                value:
                                                                    selectedTradeType,
                                                                onChanged: _enabled
                                                                        .value
                                                                    ? (String?
                                                                        newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedTradeType =
                                                                              newValue!;
                                                                        });
                                                                      }
                                                                    : null,
                                                                items: tradeType.map<
                                                                        DropdownMenuItem<
                                                                            String>>(
                                                                    (value) {
                                                                  return DropdownMenuItem(
                                                                    child: Text(
                                                                        value
                                                                            .toString()),
                                                                    value:
                                                                        value,
                                                                  );
                                                                }).toList(),
                                                                disabledHint:
                                                                    selectedTradeType !=
                                                                            null
                                                                        ? Text(selectedTradeType
                                                                            .toString())
                                                                        : null,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Material(
                                                              child: Text(
                                                                "Feedback Status",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .regularFont,
                                                                  // fontWeight: FontWeight.w700,
                                                                  fontSize:
                                                                      16.sp,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Material(
                                                              child:
                                                                  DropdownButtonFormField(
                                                                isExpanded:
                                                                    true,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Choose feedback status",
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .regularFont,
                                                                    fontSize:
                                                                        16.sp,
                                                                  ),
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          15,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      width: 0,
                                                                      // style: BorderStyle.none,
                                                                    ),
                                                                  ),
                                                                ),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .regularFont,
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .black87,
                                                                ),
                                                                value:
                                                                    selectedPostStatus,
                                                                onChanged: _enabled
                                                                        .value
                                                                    ? (String?
                                                                        newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedPostStatus =
                                                                              newValue!;
                                                                        });
                                                                      }
                                                                    : null,
                                                                items: postStatus.map<
                                                                        DropdownMenuItem<
                                                                            String>>(
                                                                    (value) {
                                                                  return DropdownMenuItem(
                                                                    child: Text(
                                                                        value
                                                                            .toString()),
                                                                    value:
                                                                        value,
                                                                  );
                                                                }).toList(),
                                                                disabledHint:
                                                                    selectedPostStatus !=
                                                                            null
                                                                        ? Text(selectedPostStatus
                                                                            .toString())
                                                                        : null,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                MaterialButton(
                                                                  // minWidth: MediaQuery.of(context).size.width,
                                                                  height: 47.h,
                                                                  onPressed:
                                                                      () {
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                    setState(
                                                                        () {
                                                                      selectedGenreOfFeedback =
                                                                          null;
                                                                      selectedTypeOfFeedback =
                                                                          null;
                                                                      selectedCompanyType =
                                                                          null;
                                                                      selectedTradeType =
                                                                          null;
                                                                      selectedPostStatus =
                                                                          null;
                                                                      _enabled.value =
                                                                          true;
                                                                    });
                                                                  },
                                                                  color: const Color(
                                                                      0xff108ab3),
                                                                  child: Text(
                                                                    "Clear",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .regularFont,
                                                                      fontSize:
                                                                          16.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: const Color(
                                                                          0xffffffff),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 15.h,
                                                                ),
                                                                MaterialButton(
                                                                  // minWidth: MediaQuery.of(context).size.width,
                                                                  height: 47.h,
                                                                  onPressed:
                                                                      () {
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                    setState(
                                                                        () {
                                                                      _enabled.value =
                                                                          false;
                                                                    });
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    DialogHelper.showInfoToast(
                                                                        description:
                                                                            'Filter Applied');
                                                                  },
                                                                  color: const Color(
                                                                      0xff108ab3),
                                                                  child: Text(
                                                                    "Apply",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .regularFont,
                                                                      fontSize:
                                                                          16.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: const Color(
                                                                          0xffffffff),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          margin: const EdgeInsets.only(
                                              bottom: 0, left: 3, right: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                        ),
                                      );
                                    },
                                    transitionBuilder:
                                        (context, anim1, anim2, child) {
                                      return SlideTransition(
                                        position: Tween(
                                                begin: const Offset(0, 1),
                                                end: const Offset(0, 0))
                                            .animate(anim1),
                                        child: child,
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: 30.0,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff24aaff),
                                  ),
                                  child: Center(
                                    // child: Icon(
                                    //   Icons.filter_alt_rounded,
                                    //   color: Colors.white,
                                    // ),
                                    child: Obx(
                                      () => _enabled.value
                                          ? SvgPicture.asset(
                                              'assets/icons/filter-icon.svg',
                                              height: 25.h,
                                              width: 25.w,
                                              color: Colors.white,
                                            )
                                          : Stack(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/filter-icon.svg',
                                                  height: 25.h,
                                                  width: 25.w,
                                                  color: Colors.black,
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: 0,
                                                  child: CircleAvatar(
                                                    radius: 60.w,
                                                    // child: Text(
                                                    //   BaseController.unreadNotification.value.toString(),
                                                    //   style: TextStyle(fontSize: 12.sp),
                                                    // ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(0),
                              child: searching
                                  ? InkWell(
                                      onTap: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        setState(() {
                                          searching = !searching;
                                        });
                                        feedbackController.txtSearch.text = '';
                                        feedbackController.search(index);
                                      },
                                      child: Container(
                                        width: 30.0,
                                        decoration: const BoxDecoration(
                                          color: Color(0xff24aaff),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.clear_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        setState(() {
                                          searching = !searching;
                                        });
                                        feedbackController.search(index);
                                        // FilterDialog.openFilterDialog(context);
                                      },
                                      child: Container(
                                        width: 30.0,
                                        decoration: const BoxDecoration(
                                          color: Color(0xff24aaff),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          controller: feedbackController.txtSearch,
                          onChanged: (text) {
                            setState(() {
                              searching = false;
                            });
                          },
                        ),
                      ),
                      margin:
                          const EdgeInsets.only(top: 120, left: 0, right: 0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                transitionBuilder: (context, anim1, anim2, child) {
                  return SlideTransition(
                    position: Tween(
                            begin: const Offset(0, -0.3),
                            end: const Offset(0, 0))
                        .animate(anim1),
                    child: child,
                  );
                },
              );
            },
            icon: SvgPicture.asset(
              'assets/icons/Search.svg',
              height: 29.h,
              width: 29.w,
            ),
          ),
        ),
        DescribedFeatureOverlay(
          featureId: 'notification',
          backgroundColor: Colors.purple.shade100,
          barrierDismissible: false,
          onComplete: () async {
            isAppTourDone.write('app_tour', 'done');
            return true;
          },
          onBackgroundTap: () async {
            isAppTourDone.write('app_tour', 'done');
            FeatureDiscovery.completeCurrentStep(context);
            return true;
          },
          description: Column(
            children: [
              const Text(
                "Displays in-app notifications.",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      FeatureDiscovery.dismissAll(context);
                      isAppTourDone.write('app_tour', 'done');
                    },
                    child: Text(
                      "Skip All",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      FeatureDiscovery.completeCurrentStep(context);
                      isAppTourDone.write("app_tour", "done");
                    },
                    child: const Text("Done"),
                  ),
                ],
              ),
            ],
          ),
          title: const Text(
            "Notification Tab",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          tapTarget: SvgPicture.asset(
            'assets/icons/Notification.svg',
            height: 29.h,
            width: 29.w,
          ),
          child: const CustomNotificationIcon(),
        ),
      ],
    );
  }
}
