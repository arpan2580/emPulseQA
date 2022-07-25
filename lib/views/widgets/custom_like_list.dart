import 'package:cached_network_image/cached_network_image.dart';
import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/controllers/feedback_react_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

class CustomLikeList extends StatefulWidget {
  const CustomLikeList({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomLikeList> createState() => _CustomLikeListState();
}

class _CustomLikeListState extends State<CustomLikeList> {
  var reactListController = Get.put(FeedbackReactListController());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width - 50,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 15.0),
              child: Text(
                // "Liked By ${reactListController.reactList.length} people",
                "People who liked",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: AppFonts.regularFont,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                ),
              ),
            ),
            Divider(
              thickness: 1.0,
              indent: 10,
              endIndent: 10,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: reactListController.reactList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            reactListController.reactList[index].profileImage ==
                                    null
                                ? CircleAvatar(
                                    radius: 20.w,
                                    child: Text(
                                      BaseController.getinitials(
                                          reactListController
                                              .reactList[index].name
                                              .toString()),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        // color: Colors.white,
                                        fontFamily: AppFonts.regularFont,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      // Get.to(
                                      //   () => PhotoView(
                                      //     imgList: reactListController
                                      //         .reactList[index].profileImage,
                                      //     index: 0,
                                      //     isProfile: true,
                                      //   ),
                                      // );
                                    },
                                    child: CircleAvatar(
                                      radius: 20.w,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              BaseController.baseImgUrl +
                                                  reactListController
                                                      .reactList[index]
                                                      .profileImage
                                                      .toString()),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                reactListController.reactList[index].name
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontFamily: AppFonts.regularFont,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Wrap(
                        //   children: [
                        //     Padding(
                        //       padding: EdgeInsets.only(left: 5.w),
                        //       child: const Text(
                        //         "Time ago",
                        //         style: TextStyle(
                        //           color: Colors.black54,
                        //           fontSize: 13,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
