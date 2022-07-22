import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/feedback_controller.dart';
import 'package:empulse/views/widgets/custom_feedback.dart';
import 'package:empulse/views/widgets/custom_topuser.dart';
import 'package:empulse/views/widgets/refresh_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

class AllFeedbackPage extends StatefulWidget {
  final bool isSearch;
  final Function callback;
  const AllFeedbackPage(
      {Key? key, required this.isSearch, required this.callback})
      : super(key: key);

  @override
  State<AllFeedbackPage> createState() => _AllFeedbackPageState();
}

class _AllFeedbackPageState extends State<AllFeedbackPage> {
  bool isLiked = false;
  late int likeCount;
  var feedbackController = Get.put(FeedbackController());
  List imgList = [];
  final scrollController = ScrollController();
  bool noItem = false;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    feedbackController.fetchMasterData().then((value) {
      if (value) {
        feedbackController.fetchFeedback();
      }
    });

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (feedbackController.nextPageUrl != null) {
          feedbackController.fetchMore(feedbackController.nextPageUrl, false);
        } else {
          setState(() {
            noItem = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => feedbackController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : feedbackController.feedbackList.isNotEmpty
              ? SizedBox(
                  height: Get.height,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await feedbackController.fetchFeedback();
                    },
                    child: ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        (feedbackController.topUsersList.isNotEmpty)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 13.0, top: 13.0, bottom: 5.0),
                                    child: Text(
                                      "TOP USERS",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppFonts.regularFont,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7.0),
                                    child: Container(
                                      height: 120.h,
                                      width: Get.width,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        color:
                                            Color.fromARGB(245, 245, 245, 245),
                                      ),
                                      // color: Colors.grey,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 1.0),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: feedbackController
                                                  .topUsersList.length +
                                              1,
                                          itemBuilder: (context, index) {
                                            if (index <
                                                feedbackController
                                                    .topUsersList.length) {
                                              return CustomTopuser(
                                                topUsers: feedbackController
                                                    .topUsersList,
                                                index: index,
                                                isViewAll: false,
                                              );
                                            } else {
                                              return GestureDetector(
                                                onTap: () {
                                                  widget.callback(2);
                                                },
                                                child: CustomTopuser(
                                                  topUsers: const [],
                                                  index: index,
                                                  isViewAll: true,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        ListView.builder(
                          // controller: scrollController,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: feedbackController.feedbackList.length + 1,
                          itemBuilder: (context, index) {
                            if (index <
                                feedbackController.feedbackList.length) {
                              if (feedbackController
                                          .feedbackList[index].images !=
                                      null &&
                                  feedbackController
                                          .feedbackList[index].file1 !=
                                      '') {
                                imgList = feedbackController.getImgList(
                                    feedbackController
                                        .feedbackList[index].images);
                              } else {
                                imgList = [];
                              }
                              return CustomFeedback(
                                index: index,
                                feedback: feedbackController.feedbackList,
                                imgList: imgList,
                                assignedPost: false,
                              );
                            } else {
                              if (noItem ||
                                  feedbackController.nextPageUrl == null) {
                                return Container();
                              } else {
                                return const Padding(
                                  padding:
                                      EdgeInsets.only(top: 25, bottom: 45.0),
                                  child: Center(
                                      child:
                                          CircularProgressIndicator.adaptive()),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text('No Feedback found'),
                ),
    );
  }
}
