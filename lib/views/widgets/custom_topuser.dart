import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/views/pages/user_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

class CustomTopuser extends StatelessWidget {
  final dynamic topUsers;
  final int index;
  final bool isViewAll;

  const CustomTopuser({
    Key? key,
    required this.topUsers,
    required this.index,
    required this.isViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (index == 0)
          ? EdgeInsets.only(top: 5.0, left: 5.0, right: 15.h)
          : EdgeInsets.only(top: 5.0, right: 15.h),
      child: (isViewAll)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xff108ab3),
                      width: 2.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      radius: 25.w,
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 30,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "View All",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: () {
                Get.to(() => UserFeedback(
                    userId: topUsers[index]['user_id'].toString(),
                    name: topUsers[index]['name']));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (index != 0)
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xff108ab3),
                              width: 2.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: topUsers[index]['profile_image'] == null
                                ? CircleAvatar(
                                    radius: 25.w,
                                    child: Text(
                                      BaseController.getinitials(
                                          topUsers[index]['name']),
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontFamily: AppFonts.regularFont,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 25.w,
                                    backgroundImage: CachedNetworkImageProvider(
                                        BaseController.baseImgUrl +
                                            topUsers[index]['profile_image']!),
                                  ),
                          ),
                        )
                      : DottedBorder(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: topUsers[index]['profile_image'] == null
                                ? CircleAvatar(
                                    radius: 25.w,
                                    child: Text(
                                      BaseController.getinitials(
                                          topUsers[index]['name']),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: AppFonts.regularFont,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 25.w,
                                    backgroundImage: CachedNetworkImageProvider(
                                        BaseController.baseImgUrl +
                                            topUsers[index]['profile_image']!),
                                  ),
                          ),
                          borderType: BorderType.Circle,
                          strokeWidth: 2.5,
                          color: const Color(0xff108ab3),
                          dashPattern: const [7, 5, 7, 5, 7, 5],
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      splitString(
                        topUsers[index]['name'],
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String splitString(String name) {
    String fname;
    List<String> n;
    n = name.split(' ');

    fname = n[0];

    return fname;
  }
}
