import 'package:empulse/controllers/feedback_controller.dart';
import 'package:empulse/views/widgets/custom_feedback.dart';
import 'package:empulse/views/widgets/refresh_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

class MyFeedbackPage extends StatefulWidget {
  final bool isSearch;
  const MyFeedbackPage({Key? key, required this.isSearch}) : super(key: key);

  @override
  State<MyFeedbackPage> createState() => _MyFeedbackPageState();
}

class _MyFeedbackPageState extends State<MyFeedbackPage> {
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
    feedbackController.fetchMyFeedback();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (feedbackController.nextPageUrl != null) {
          feedbackController.fetchMore(feedbackController.nextPageUrl, true);
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
          : feedbackController.myFeedbackList.isNotEmpty
              ? SizedBox(
                  height: Get.height,
                  child: RefreshWidget(
                    onRefresh: () async {
                      await feedbackController.fetchMyFeedback();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: feedbackController.myFeedbackList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < feedbackController.myFeedbackList.length) {
                          if (feedbackController.myFeedbackList[index].images !=
                                  null &&
                              feedbackController.myFeedbackList[index].file1 !=
                                  '') {
                            imgList = feedbackController.getImgList(
                                feedbackController
                                    .myFeedbackList[index].images);
                          } else {
                            imgList = [];
                          }
                          return CustomFeedback(
                            index: index,
                            feedback: feedbackController.myFeedbackList,
                            imgList: imgList,
                            assignedPost: false,
                          );
                        } else {
                          if (noItem ||
                              feedbackController.nextPageUrl == null) {
                            return Container();
                          } else {
                            return const Padding(
                              padding: EdgeInsets.only(top: 25, bottom: 45.0),
                              child: Center(
                                  child: CircularProgressIndicator.adaptive()),
                            );
                          }
                        }
                      },
                    ),
                  ),
                )
              : const Center(
                  child: Text('Add feedback first'),
                ),
    );
  }
}
