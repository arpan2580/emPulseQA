import 'package:empulse/controllers/assigned_feedback_controller.dart';
import 'package:empulse/controllers/feedback_controller.dart';
import 'package:empulse/views/widgets/custom_feedback.dart';
import 'package:empulse/views/widgets/refresh_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

class MyAssignedPage extends StatefulWidget {
  final bool isSearch;
  const MyAssignedPage({Key? key, required this.isSearch}) : super(key: key);

  @override
  State<MyAssignedPage> createState() => _MyAssignedPageState();
}

class _MyAssignedPageState extends State<MyAssignedPage> {
  bool isLiked = false;
  late int likeCount;
  var feedbackController = Get.put(AssignedFeedbackController());
  List imgList = [];
  final scrollController = ScrollController();
  bool noItem = false;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    feedbackController.fetchAssignedFeedback();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (feedbackController.nextPageUrl != null) {
          feedbackController.fetchMore(feedbackController.nextPageUrl);
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
          : feedbackController.myAssignedList.isNotEmpty
              ? SizedBox(
                  height: Get.height,
                  child: RefreshWidget(
                    onRefresh: () async {
                      await feedbackController.fetchAssignedFeedback();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: feedbackController.myAssignedList.length + 1,
                      itemBuilder: (context, index) {
                        if (index < feedbackController.myAssignedList.length) {
                          if (feedbackController.myAssignedList[index].images !=
                                  null &&
                              feedbackController.myAssignedList[index].file1 !=
                                  '') {
                            imgList = FeedbackController().getImgList(
                                feedbackController
                                    .myAssignedList[index].images);
                          } else {
                            imgList = [];
                          }
                          return CustomFeedback(
                            index: index,
                            feedback: feedbackController.myAssignedList,
                            imgList: imgList,
                            assignedPost: (feedbackController
                                        .myAssignedList[index].status !=
                                    "300")
                                ? true
                                : false,
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
                  child: Text('You have no assigned feedback'),
                ),
    );
  }
}
