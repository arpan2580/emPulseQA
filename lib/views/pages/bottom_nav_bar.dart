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
  bool isFilterClicked = false;

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
              getData();
              setState(() {
                isSearch = !isSearch;
                _enabled.value = true;
              });
              showGeneralDialog(
                  barrierDismissible: false,
                  barrierColor: Colors.transparent.withOpacity(0.1),
                  context: context,
                  pageBuilder: (context, a1, a2) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return Wrap(
                            children: [
                              Container(
                                height: isFilterClicked ? 480 : 140,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                margin: const EdgeInsets.only(top: 40),
                                // SEARCH BOX
                                child: Column(
                                  children: [
                                    Material(
                                      child: Padding(
                                        // PROVIDES PADDING TO THE SEARCH BOX
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          20,
                                          16.0,
                                          0.0,
                                        ),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: "Search feedback",
                                            contentPadding:
                                                const EdgeInsets.all(5),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              borderSide: const BorderSide(
                                                width: 1,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    isFilterClicked
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              10,
                                              20,
                                              10.0,
                                              0.0,
                                            ),
                                            child: SizedBox(
                                              height:
                                                  320, // THIS WILL AFFECT THE FILTER AND SEARCH BUTTON TOP GAP
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Material(
                                                        child:
                                                            DropdownButtonFormField(
                                                          isExpanded: true,
                                                          decoration:
                                                              InputDecoration(
                                                            enabled: true,
                                                            hintText:
                                                                "Choose genre of feedback",
                                                            hintStyle:
                                                                TextStyle(
                                                              fontFamily: AppFonts
                                                                  .regularFont,
                                                              fontSize: 16.sp,
                                                            ),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    0,
                                                                    10,
                                                                    0),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                width: 0,
                                                              ),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .regularFont,
                                                            fontSize: 16.sp,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                          value:
                                                              selectedGenreOfFeedback,
                                                          onChanged: (String?
                                                              newValue) {
                                                            setState(() {
                                                              selectedGenreOfFeedback =
                                                                  newValue!;
                                                            });
                                                          },
                                                          items: genreOfFeedback.map<
                                                              DropdownMenuItem<
                                                                  String>>((Genre
                                                              value) {
                                                            return DropdownMenuItem(
                                                              child: Text(value
                                                                  .genre
                                                                  .toString()),
                                                              value:
                                                                  value.genre,
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
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Material(
                                                        child:
                                                            DropdownButtonFormField(
                                                          isExpanded: true,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Choose type of feedback",
                                                            hintStyle:
                                                                TextStyle(
                                                              fontFamily: AppFonts
                                                                  .regularFont,
                                                              fontSize: 16.sp,
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
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                width: 0,
                                                                // style: BorderStyle.none,
                                                              ),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .regularFont,
                                                            fontSize: 16.sp,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                          value:
                                                              selectedTypeOfFeedback,
                                                          onChanged: _enabled
                                                                  .value
                                                              ? (String?
                                                                  newValue) {
                                                                  setState(() {
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
                                                              child: Text(value
                                                                  .toString()),
                                                              value: value,
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
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Material(
                                                        child:
                                                            DropdownButtonFormField(
                                                          isExpanded: true,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Choose Company",
                                                            hintStyle:
                                                                TextStyle(
                                                              fontFamily: AppFonts
                                                                  .regularFont,
                                                              fontSize: 16.sp,
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
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                width: 0,
                                                                // style: BorderStyle.none,
                                                              ),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .regularFont,
                                                            fontSize: 16.sp,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                          value:
                                                              selectedCompanyType,
                                                          onChanged: _enabled
                                                                  .value
                                                              ? (String?
                                                                  newValue) {
                                                                  setState(() {
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
                                                              child: Text(value
                                                                  .toString()),
                                                              value: value,
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
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Material(
                                                        child:
                                                            DropdownButtonFormField(
                                                          isExpanded: true,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Choose trade type",
                                                            hintStyle:
                                                                TextStyle(
                                                              fontFamily: AppFonts
                                                                  .regularFont,
                                                              fontSize: 16.sp,
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
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                width: 0,
                                                                // style: BorderStyle.none,
                                                              ),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .regularFont,
                                                            fontSize: 16.sp,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                          value:
                                                              selectedTradeType,
                                                          onChanged: _enabled
                                                                  .value
                                                              ? (String?
                                                                  newValue) {
                                                                  setState(() {
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
                                                              child: Text(value
                                                                  .toString()),
                                                              value: value,
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
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Material(
                                                        child:
                                                            DropdownButtonFormField(
                                                          isExpanded: true,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Choose feedback status",
                                                            hintStyle:
                                                                TextStyle(
                                                              fontFamily: AppFonts
                                                                  .regularFont,
                                                              fontSize: 16.sp,
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
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              borderSide:
                                                                  const BorderSide(
                                                                width: 0,
                                                                // style: BorderStyle.none,
                                                              ),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .regularFont,
                                                            fontSize: 16.sp,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                          value:
                                                              selectedPostStatus,
                                                          onChanged: _enabled
                                                                  .value
                                                              ? (String?
                                                                  newValue) {
                                                                  setState(() {
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
                                                              child: Text(value
                                                                  .toString()),
                                                              value: value,
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
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 8.0, 16.0, 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            isFilterClicked
                                                ? SearchFilterButton(
                                                    text: "Cancel Filter",
                                                    icon: Icons.filter_alt_off,
                                                    onPressed: () {
                                                      print("Fliter clicked");
                                                      setState(() {
                                                        isFilterClicked = false;
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        setState(() {
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
                                                          _enabled.value = true;
                                                        });
                                                      });
                                                    },
                                                  )
                                                : SearchFilterButton(
                                                    text: "Apply Filter",
                                                    icon: Icons.filter_alt,
                                                    onPressed: () {
                                                      print("Fliter clicked");
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
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                setState(() {
                                                  // isFilterClicked = false;
                                                  searching = !searching;
                                                });
                                                feedbackController
                                                    .txtSearch.text = '';
                                                feedbackController
                                                    .search(index);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  });
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
    return Material(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3 + 10,
        child: MaterialButton(
          color: const Color(0xff24aaff),
          onPressed: onPressed,
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
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
      ),
    );
  }
}
