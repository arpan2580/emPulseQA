import 'package:cached_network_image/cached_network_image.dart';
import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/controllers/comment_controller.dart';
import 'package:empulse/controllers/dark_theme_controller.dart';
import 'package:empulse/models/feedback_model.dart';
import 'package:empulse/views/pages/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

class CustomCommentCard extends StatelessWidget {
  final String username;
  final dynamic userprofile;
  final String comment;
  final dynamic commentType;
  final dynamic imgList;
  // final List? images;
  final bool isSubComment;
  final dynamic itemImages;
  final String time;
  final void Function() replyFunc;
  const CustomCommentCard({
    Key? key,
    required this.username,
    required this.userprofile,
    this.imgList,
    required this.comment,
    required this.commentType,
    required this.isSubComment,
    required this.replyFunc,
    this.itemImages,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic localImgList;
    if (itemImages != null && itemImages.length > 0) {
      if (itemImages["file_1"] != null) {
        localImgList =
            CommentController().getImgList(Images.fromJson(itemImages));
      } else {
        localImgList = [];
      }
    } else {
      localImgList = imgList;
    }
    return ListTile(
      leading: userprofile == null
          ? CircleAvatar(
              radius: 20.w,
              child: Text(
                BaseController.getinitials(username),
                style: const TextStyle(
                  fontSize: 16,
                  // color: Colors.white,
                  fontFamily: AppFonts.regularFont,
                ),
              ),
            )
          : CircleAvatar(
              radius: 20.w,
              backgroundImage: CachedNetworkImageProvider(
                  BaseController.baseImgUrl + userprofile),
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                username.isEmpty ? "UserName" : username,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: DarkThemeController.isDarkThemeEnabled.value
                      ? Theme.of(context).primaryColor.withOpacity(0.9)
                      : Colors.black87,
                  fontFamily: AppFonts.regularFont,
                ),
              ),
              commentType == "2"
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 3.0),
                          child: Text(
                            "Closed",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppFonts.regularFont,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          const SizedBox(
            height: 3.0,
          ),
          SizedBox(
            width: (isSubComment)
                ? MediaQuery.of(context).size.width.w - 120.w
                : MediaQuery.of(context).size.width.w - 80.w,
            child: Text(
              comment,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontFamily: AppFonts.regularFont,
                fontSize: 14.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          localImgList.length >= 1
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (var i in localImgList)
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, top: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => PhotoView(
                                    imgList: localImgList,
                                    index: localImgList.indexOf(i),
                                    isProfile: false,
                                  ),
                                );
                              },
                              child: Container(
                                // width: 83.w,
                                height: 100.h,
                                color: Colors.grey,
                                child: CachedNetworkImage(
                                  imageUrl: BaseController.baseImgUrl + i,
                                  fit: BoxFit.fill,
                                  width: 83.w,
                                  // height: 100.h,
                                  // color: Colors.grey,
                                  placeholder: (context, url) => Container(
                                    color: Colors.black12,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.black12,
                                    child: const Icon(
                                      Icons.error_rounded,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              : Container(),
          Row(
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontFamily: AppFonts.regularFont,
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
              TextButton(
                style: const ButtonStyle(
                  alignment: Alignment.centerLeft,
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () {
                  replyFunc();
                },
                child: const Text(
                  "Reply",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontFamily: AppFonts.regularFont,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
