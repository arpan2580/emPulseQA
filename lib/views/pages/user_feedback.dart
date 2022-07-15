import 'package:empulse/controllers/feedback_controller.dart';
import 'package:empulse/controllers/user_feedback_controller.dart';
import 'package:empulse/views/pages/profile_page.dart';
import 'package:empulse/views/widgets/custom_feedback.dart';
import 'package:empulse/views/widgets/refresh_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

class UserFeedback extends StatefulWidget {
  final String userId;
  final String name;
  const UserFeedback({Key? key, required this.userId, required this.name})
      : super(key: key);

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  var userFeedbackController = Get.put(UserFeedbackController());
  List imgList = [];
  final scrollController = ScrollController();
  bool noItem = false;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    userFeedbackController.fetchUserFeedback(widget.userId);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (userFeedbackController.nextPageUrl != null) {
          userFeedbackController.fetchMore(
              userFeedbackController.nextPageUrl, widget.userId);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          widget.name.trim().split(' ').first + "'s posts",
          style: const TextStyle(color: Colors.black),
        ),
        actions: const [
          // MyNotificationBtn(),
        ],
      ),
      body: Obx(
        () => userFeedbackController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : RefreshWidget(
                onRefresh: () async {
                  await userFeedbackController.fetchUserFeedback(widget.userId);
                },
                child: SizedBox(
                  height: Get.height - 1,
                  child: ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      userFeedbackController.userDetails.isNotEmpty
                          ? CustomProfile(
                              userDetails:
                                  userFeedbackController.userDetails[0],
                              isNotMe: true)
                          : Container(),
                      userFeedbackController.userFeedbackList.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: userFeedbackController
                                      .userFeedbackList.length +
                                  1,
                              itemBuilder: (context, index) {
                                if (index <
                                    userFeedbackController
                                        .userFeedbackList.length) {
                                  if (userFeedbackController
                                              .userFeedbackList[index].images !=
                                          null &&
                                      userFeedbackController
                                              .userFeedbackList[index].file1 !=
                                          '') {
                                    imgList = FeedbackController().getImgList(
                                        userFeedbackController
                                            .userFeedbackList[index].images);
                                  } else {
                                    imgList = [];
                                  }
                                  return CustomFeedback(
                                    index: index,
                                    feedback:
                                        userFeedbackController.userFeedbackList,
                                    imgList: imgList,
                                    assignedPost: false,
                                  );
                                } else {
                                  if (noItem ||
                                      userFeedbackController.nextPageUrl ==
                                          null) {
                                    return Container();
                                  } else {
                                    return const Padding(
                                      padding: EdgeInsets.only(
                                          top: 25, bottom: 45.0),
                                      child: Center(
                                          child: CircularProgressIndicator
                                              .adaptive()),
                                    );
                                  }
                                }
                              },
                            )
                          : const Center(
                              child: Text('No posts yet.'),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
