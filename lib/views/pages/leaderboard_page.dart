import 'package:dotted_border/dotted_border.dart';
import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/controllers/leaderboard_controller.dart';
import 'package:empulse/views/pages/photo_view.dart';
import 'package:empulse/views/pages/user_feedback.dart';
import 'package:empulse/views/widgets/refresh_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  var leaderboardController = Get.put(LeaderboardController());

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    leaderboardController.fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => leaderboardController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : leaderboardController.topUsersList.isNotEmpty
              ? RefreshWidget(
                  onRefresh: () async {
                    await leaderboardController.fetchLeaderboard();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: leaderboardController.topUsersList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Get.to(() => UserFeedback(
                            userId: leaderboardController.topUsersList[index].id
                                .toString(),
                            name: leaderboardController
                                .topUsersList[index].name)),
                        child: LeaderboardUser(
                            userDetails:
                                leaderboardController.topUsersList[index],
                            index: index),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text('Add feedback first'),
                ),
    );
  }
}

class LeaderboardUser extends StatelessWidget {
  final dynamic userDetails;
  final int index;
  const LeaderboardUser({
    Key? key,
    required this.userDetails,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (index == 0)
          ? const EdgeInsets.only(top: 10.0, bottom: 10.0)
          : const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 0.7, color: Colors.grey.withOpacity(0.7)))),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 3.0,
            leading: DottedBorder(
              borderType: BorderType.Circle,
              strokeWidth: 2.5,
              color: const Color(0xff108ab3),
              dashPattern: const [7, 5, 7, 5, 7, 5],
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: userDetails.profileImage == null
                    ? CircleAvatar(
                        radius: 40.w,
                        child: Text(
                          BaseController.getinitials(userDetails.name),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontFamily: AppFonts.regularFont,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Get.to(
                            () => PhotoView(
                              imgList: userDetails.profileImage,
                              index: 0,
                              isProfile: true,
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 40.w,
                          backgroundImage: NetworkImage(
                              BaseController.baseImgUrl +
                                  userDetails.profileImage),
                        ),
                      ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userDetails.name,
                  style: TextStyle(
                    fontFamily: AppFonts.regularFont,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff000000),
                  ),
                ),
                Text(
                  userDetails.email,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color.fromARGB(255, 72, 72, 72),
                  ),
                  // textAlign: TextAlign.justify,
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: Row(
                children: [
                  dataCard(
                    userDetails.totalFeedbacks.toString(),
                    "Feedback",
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  dataCard(
                    userDetails.totalComments.toString(),
                    "Comments",
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  dataCard(
                    userDetails.totalLikes.toString(),
                    "Like",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dataCard(value, label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: AppFonts.regularFont,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontFamily: AppFonts.lightFont,
            fontWeight: FontWeight.normal,
            color: const Color(0xff424242),
            // color: Colors.black,
          ),
        ),
      ],
    );
  }
}
