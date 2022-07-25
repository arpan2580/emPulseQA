import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/controllers/feedback_react_list_controller.dart';
import 'package:empulse/services/base_client.dart';
import 'package:empulse/views/pages/feedback_comments.dart';
import 'package:empulse/views/pages/photo_view.dart';
import 'package:empulse/views/pages/user_feedback.dart';
import 'package:empulse/views/widgets/custom_color_legend.dart';
import 'package:empulse/views/widgets/custom_like_list.dart';
import 'package:empulse/views/widgets/custom_popup_menu.dart';
import 'package:empulse/views/widgets/my_like_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class CustomFeedback extends StatefulWidget {
  final int index;
  final dynamic feedback;
  final dynamic imgList;
  final bool assignedPost;
  const CustomFeedback({
    Key? key,
    required this.index,
    required this.feedback,
    required this.imgList,
    required this.assignedPost,
  }) : super(key: key);

  @override
  State<CustomFeedback> createState() => _CustomFeedbackState();
}

class _CustomFeedbackState extends State<CustomFeedback> {
  int activeImg = 0;
  double size = 20;
  var reactListController = Get.put(FeedbackReactListController());

  RxInt commentCount = 0.obs;
  RxInt likeCount = 0.obs;
  int currentId = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 1,
                // color: Colors.black12,
                color: Theme.of(context).primaryColor.withOpacity(0.2)),
          ),
          // color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 13.w),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => UserFeedback(
                      userId: widget.feedback[widget.index].userId,
                      name: widget.feedback[widget.index].name));
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: widget.feedback[widget.index].profileImage == null
                      ? CircleAvatar(
                          // backgroundColor: AppThemes.primaryColor,
                          radius: 20.w,
                          child: Text(
                            BaseController.getinitials(
                                widget.feedback[widget.index].name),
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
                              BaseController.baseImgUrl +
                                  widget.feedback[widget.index].profileImage),
                        ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.feedback[widget.index].name,
                        style: TextStyle(
                          fontFamily: AppFonts.regularFont,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        widget.feedback[widget.index].email,
                        style: TextStyle(
                          fontFamily: AppFonts.regularFont,
                          fontSize: 12.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  trailing: CustomPopupMenu(
                    feedbackId: widget.feedback[widget.index].id,
                    feedbackStatus: widget.feedback[widget.index].status,
                    isAssignedPost: widget.assignedPost,
                    lat: double.parse(widget.feedback[widget.index].latitude),
                    long: double.parse(widget.feedback[widget.index].longitude),
                    context: context,
                  ),
                ),
              ),
            ),
            (widget.feedback[widget.index].images != null)
                ? Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 1.0,
                          onPageChanged: (position, reason) {
                            setState(() {
                              activeImg = position;
                            });
                          },
                          enableInfiniteScroll: false,
                        ),
                        items: widget.imgList.map<Widget>((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => PhotoView(
                                      imgList: widget.imgList,
                                      index: activeImg,
                                      isProfile: false,
                                    ),
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl: BaseController.baseImgUrl + i,
                                  fit: BoxFit.cover,
                                  width: 1000,
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
                              );
                            },
                          );
                        }).toList(),
                      ),
                      widget.imgList.length >= 1
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 15.0),
                              child: Row(
                                children: [
                                  widget.imgList.length > 1
                                      ? Expanded(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: indicators(
                                                  widget.imgList.length,
                                                  activeImg)),
                                        )
                                      : Expanded(child: Container()),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 11.0),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => PhotoView(
                                            imgList: widget.imgList,
                                            index: activeImg,
                                            isProfile: false,
                                          ),
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/RetinaIcon.svg',
                                        height: 25.h,
                                        width: 25.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      widget.imgList.length >= 1
                          ? Positioned(
                              top: 15,
                              right: 11,
                              child: Container(
                                width: 65,
                                height: 32,
                                child: Center(
                                  child: Text(
                                    (activeImg + 1).toString() +
                                        "/${widget.imgList.length}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: AppFonts.regularFont,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )
                : Container(),
            (widget.feedback[widget.index].images != null)
                ? Padding(
                    padding: EdgeInsets.only(
                      left: 13.w,
                      top: 5.h,
                      right: 13.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                LikeButton(
                                  size: size,
                                  isLiked: (BaseController
                                              .likedFeedbackId.isNotEmpty &&
                                          BaseController.likedFeedbackId
                                              .contains(widget
                                                  .feedback[widget.index].id))
                                      ? BaseController.isLikedPost[
                                          BaseController.likedFeedbackId
                                              .indexOf(widget
                                                  .feedback[widget.index].id)]
                                      : widget.feedback[widget.index].isLiked,
                                  likeCount: (BaseController
                                              .likedFeedbackId.isNotEmpty &&
                                          BaseController.likedFeedbackId
                                              .contains(widget
                                                  .feedback[widget.index].id))
                                      ? BaseController.postLikedCount[
                                          BaseController
                                              .likedFeedbackId
                                              .indexOf(widget
                                                  .feedback[widget.index].id)]
                                      : int.parse(
                                          widget.feedback[widget.index].liked),
                                  // isLiked:
                                  //     widget.feedback[widget.index].isLiked,
                                  // likeCount: int.parse(
                                  //     widget.feedback[widget.index].liked),
                                  likeCountPadding:
                                      const EdgeInsets.only(left: 15.0),
                                  likeBuilder: (isLiked) {
                                    return isLiked
                                        ? const Icon(
                                            Icons.favorite_rounded,
                                            color: Colors.red,
                                            size: 25.0,
                                          )
                                        : Icon(
                                            Icons.favorite_border_rounded,
                                            size: 25.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          );
                                  },
                                  countBuilder: (count, isLiked, text) {
                                    // final color =
                                    //     isLiked ? Colors.black : Colors.grey;
                                    var color = Theme.of(context).primaryColor;
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          reactListController.fetchReactList(
                                              widget.feedback[widget.index].id);
                                          var totLike = (BaseController
                                                      .likedFeedbackId
                                                      .isNotEmpty &&
                                                  BaseController.likedFeedbackId
                                                      .contains(widget
                                                          .feedback[
                                                              widget.index]
                                                          .id))
                                              ? BaseController.postLikedCount[
                                                  BaseController.likedFeedbackId
                                                      .indexOf(widget
                                                          .feedback[widget.index]
                                                          .id)]
                                              : int.parse(widget.feedback[widget.index].liked);
                                          if (totLike > 0) {
                                            showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (builder) {
                                                  return const CustomLikeList();
                                                });
                                          }
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: color,
                                              fontSize: 14.sp,
                                              fontFamily: AppFonts.regularFont,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: text,
                                              ),
                                              const TextSpan(
                                                text: " Like(s)",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  onTap: (isLiked) async {
                                    var currentLikeCount = int.parse(
                                        widget.feedback[widget.index].liked);
                                    var currentFeedback =
                                        widget.feedback[widget.index].id;

                                    if (isLiked == false) {
                                      if (BaseController.likedFeedbackId
                                          .contains(currentFeedback)) {
                                        int index = BaseController
                                            .likedFeedbackId
                                            .indexOf(currentFeedback);
                                        BaseController.postLikedCount[index] =
                                            BaseController
                                                    .postLikedCount[index] +
                                                1;
                                        BaseController.isLikedPost[index] =
                                            true;
                                      } else {
                                        BaseController.likedFeedbackId
                                            .add(currentFeedback);
                                        BaseController.postLikedCount
                                            .add(currentLikeCount + 1);
                                        BaseController.isLikedPost.add(true);
                                      }
                                    } else {
                                      if (BaseController.likedFeedbackId
                                          .contains(currentFeedback)) {
                                        int index = BaseController
                                            .likedFeedbackId
                                            .indexOf(currentFeedback);
                                        BaseController.postLikedCount[index] =
                                            ((BaseController.postLikedCount[
                                                            index] -
                                                        1) ==
                                                    0)
                                                ? 0
                                                : (BaseController
                                                        .postLikedCount[index] -
                                                    1);
                                        BaseController.isLikedPost[index] =
                                            false;
                                      } else {
                                        BaseController.likedFeedbackId
                                            .add(currentFeedback);
                                        BaseController.postLikedCount.add(
                                            ((currentLikeCount - 1) == 0)
                                                ? 0
                                                : (currentLikeCount - 1));
                                        BaseController.isLikedPost.add(false);
                                      }
                                    }

                                    onLikeButtonTapped(isLiked);
                                    return !isLiked;
                                  },
                                ),
                                SizedBox(width: 9.w),
                                IconButton(
                                  onPressed: () {
                                    currentId =
                                        widget.feedback[widget.index].id;
                                    Get.to(() => FeedbackComment(
                                              feedbackId: widget
                                                  .feedback[widget.index].id,
                                              isClose: (widget.assignedPost &&
                                                      widget
                                                              .feedback[
                                                                  widget.index]
                                                              .status !=
                                                          '300')
                                                  ? true
                                                  : false,
                                            ))!
                                        .then((value) {
                                      commentCount.value =
                                          int.parse(value.toString());
                                      setState(() {});
                                    });
                                  },
                                  padding: const EdgeInsets.only(top: 2.0),
                                  icon: SvgPicture.asset(
                                    'assets/icons/Comments.svg',
                                    height: 31.h,
                                    width: 31.w,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      currentId =
                                          widget.feedback[widget.index].id;
                                      Get.to(() => FeedbackComment(
                                                feedbackId: widget
                                                    .feedback[widget.index].id
                                                    .toString(),
                                                isClose: (widget.assignedPost &&
                                                        widget
                                                                .feedback[widget
                                                                    .index]
                                                                .status !=
                                                            '300')
                                                    ? true
                                                    : false,
                                              ))!
                                          .then((value) {
                                        commentCount.value =
                                            int.parse(value.toString());
                                        setState(() {});
                                      });
                                    },
                                    child: Obx(
                                      () => RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 14.sp,
                                            fontFamily: AppFonts.regularFont,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    // (widget.feedback[widget.index].id ==
                                                    //         currentId)
                                                    //     ?
                                                    ((commentCount.value -
                                                                int.parse(widget
                                                                    .feedback[
                                                                        widget
                                                                            .index]
                                                                    .commented)) <=
                                                            0)
                                                        ? widget
                                                            .feedback[
                                                                widget.index]
                                                            .commented
                                                        : ((commentCount.value -
                                                                    int.parse(widget
                                                                        .feedback[widget
                                                                            .index]
                                                                        .commented)) +
                                                                int.parse(widget
                                                                    .feedback[
                                                                        widget
                                                                            .index]
                                                                    .commented))
                                                            .toString()
                                                // : widget
                                                //     .feedback[widget.index]
                                                //     .commented,
                                                ),
                                            const TextSpan(
                                              text: " Comment(s)",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Wrap(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.w),
                                      child: Text(
                                        widget.feedback[widget.index].created,
                                        style: TextStyle(
                                          // color: Colors.black54,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14.sp,
                                          fontFamily: AppFonts.regularFont,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 25.w),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (builder) {
                                        return const ColorLegendDialog();
                                      },
                                    );
                                  },
                                  child: CustomStatus(
                                    color: BaseController
                                                .feedbackStatusId.isNotEmpty &&
                                            BaseController.feedbackStatusId
                                                .contains(widget
                                                    .feedback[widget.index].id)
                                        ? const Color(0xff00ab06)
                                        : widget.feedback[widget.index]
                                                    .status ==
                                                "300"
                                            ? const Color(0xff00ab06)
                                            : widget.feedback[widget.index]
                                                        .status ==
                                                    "200"
                                                ? const Color(0xffffa200)
                                                : widget.feedback[widget.index]
                                                            .status ==
                                                        "100"
                                                    ? const Color(0xff1f9aff)
                                                    : const Color(0xffa300a3),
                                    svgIcon: BaseController
                                                .feedbackStatusId.isNotEmpty &&
                                            BaseController.feedbackStatusId
                                                .contains(widget
                                                    .feedback[widget.index].id)
                                        ? "Icon.svg"
                                        : widget.feedback[widget.index]
                                                    .status ==
                                                "300"
                                            ? "Icon.svg"
                                            : widget.feedback[widget.index]
                                                        .status ==
                                                    "200"
                                                ? "MaterialIcon.svg"
                                                : widget.feedback[widget.index]
                                                            .status ==
                                                        "100"
                                                    ? "PixleIcon.svg"
                                                    : "observation.svg",
                                    isObservation:
                                        widget.feedback[widget.index].status ==
                                                "50"
                                            ? true
                                            : false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(left: 13.w, right: 13.w),
              child: ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                contentPadding: const EdgeInsets.all(0),
                title: Wrap(
                  spacing: 5,
                  children: [
                    // COMP - PRODUCT
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: AppFonts.regularFont,
                          fontSize: 14.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: "Company: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // fontFamily: AppFonts.regularFont,
                              // fontSize: 14.sp,
                            ),
                          ),
                          TextSpan(
                            text: widget.feedback[widget.index].company,
                            style: const TextStyle(
                                // fontSize: 14.sp,
                                // fontFamily: AppFonts.regularFont,
                                ),
                          ),
                          (widget.feedback[widget.index].productName != null)
                              ? const TextSpan(
                                  text: "   Product: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const TextSpan(),
                          (widget.feedback[widget.index].productName != null)
                              ? TextSpan(
                                  text:
                                      widget.feedback[widget.index].productName,
                                )
                              : const TextSpan(),
                        ],
                      ),
                    ),
                    // SizedBox(height: 20.h),
                    Container(
                      height: 3.h,
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: AppFonts.regularFont,
                          fontSize: 14.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                        children: <TextSpan>[
                          (widget.feedback[widget.index].outletName != null)
                              ? const TextSpan(
                                  text: "Outlet: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const TextSpan(),
                          (widget.feedback[widget.index].outletName != null)
                              ? TextSpan(
                                  text:
                                      widget.feedback[widget.index].outletName,
                                  style: const TextStyle(
                                      // fontSize: 14.sp,
                                      // fontFamily: AppFonts.regularFont,
                                      ),
                                )
                              : const TextSpan(),
                          (widget.feedback[widget.index].marketName != null)
                              ? const TextSpan(
                                  text: "   Market: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const TextSpan(),
                          (widget.feedback[widget.index].marketName != null)
                              ? TextSpan(
                                  text:
                                      widget.feedback[widget.index].marketName,
                                )
                              : const TextSpan(),
                        ],
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: AppFonts.regularFont,
                        fontSize: 14.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                      children: <TextSpan>[
                        (widget.feedback[widget.index].genre != null)
                            ? TextSpan(
                                text:
                                    "On ${widget.feedback[widget.index].genre}: ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.black,
                                ),
                              )
                            : const TextSpan(),
                        TextSpan(
                          text: widget.feedback[widget.index].feedback,
                          style: const TextStyle(
                              // color: Colors.black54,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            (widget.feedback[widget.index].images == null)
                ? Padding(
                    padding: EdgeInsets.only(
                      left: 13.w,
                      right: 13.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                LikeButton(
                                  size: size,
                                  isLiked: (BaseController
                                              .likedFeedbackId.isNotEmpty &&
                                          BaseController.likedFeedbackId
                                              .contains(widget
                                                  .feedback[widget.index].id))
                                      ? BaseController.isLikedPost[
                                          BaseController.likedFeedbackId
                                              .indexOf(widget
                                                  .feedback[widget.index].id)]
                                      : widget.feedback[widget.index].isLiked,
                                  likeCount: (BaseController
                                              .likedFeedbackId.isNotEmpty &&
                                          BaseController.likedFeedbackId
                                              .contains(widget
                                                  .feedback[widget.index].id))
                                      ? BaseController.postLikedCount[
                                          BaseController
                                              .likedFeedbackId
                                              .indexOf(widget
                                                  .feedback[widget.index].id)]
                                      : int.parse(
                                          widget.feedback[widget.index].liked),
                                  // isLiked:
                                  //     widget.feedback[widget.index].isLiked,
                                  // likeCount: int.parse(
                                  //     widget.feedback[widget.index].liked),
                                  likeCountPadding:
                                      const EdgeInsets.only(left: 15.0),
                                  likeBuilder: (isLiked) {
                                    return isLiked
                                        ? const Icon(
                                            Icons.favorite_rounded,
                                            color: Colors.red,
                                            size: 25.0,
                                          )
                                        : Icon(
                                            Icons.favorite_border_rounded,
                                            size: 25.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          );
                                  },
                                  countBuilder: (count, isLiked, text) {
                                    // final color =
                                    //     isLiked ? Colors.black : Colors.grey;
                                    var color = Theme.of(context).primaryColor;
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          reactListController.fetchReactList(
                                              widget.feedback[widget.index].id);
                                          var totLike = (BaseController
                                                      .likedFeedbackId
                                                      .isNotEmpty &&
                                                  BaseController.likedFeedbackId
                                                      .contains(widget
                                                          .feedback[
                                                              widget.index]
                                                          .id))
                                              ? BaseController.postLikedCount[
                                                  BaseController.likedFeedbackId
                                                      .indexOf(widget
                                                          .feedback[widget.index]
                                                          .id)]
                                              : int.parse(widget.feedback[widget.index].liked);
                                          if (totLike > 0) {
                                            showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (builder) {
                                                  return const CustomLikeList();
                                                });
                                          }
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: color,
                                              fontSize: 14.sp,
                                              fontFamily: AppFonts.regularFont,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: text,
                                              ),
                                              const TextSpan(
                                                text: " Like(s)",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  onTap: (isLiked) async {
                                    var currentLikeCount = int.parse(
                                        widget.feedback[widget.index].liked);
                                    var currentFeedback =
                                        widget.feedback[widget.index].id;

                                    if (isLiked == false) {
                                      if (BaseController.likedFeedbackId
                                          .contains(currentFeedback)) {
                                        int index = BaseController
                                            .likedFeedbackId
                                            .indexOf(currentFeedback);
                                        BaseController.postLikedCount[index] =
                                            BaseController
                                                    .postLikedCount[index] +
                                                1;
                                        BaseController.isLikedPost[index] =
                                            true;
                                      } else {
                                        BaseController.likedFeedbackId
                                            .add(currentFeedback);
                                        BaseController.postLikedCount
                                            .add(currentLikeCount + 1);
                                        BaseController.isLikedPost.add(true);
                                      }
                                    } else {
                                      if (BaseController.likedFeedbackId
                                          .contains(currentFeedback)) {
                                        int index = BaseController
                                            .likedFeedbackId
                                            .indexOf(currentFeedback);
                                        BaseController.postLikedCount[index] =
                                            ((BaseController.postLikedCount[
                                                            index] -
                                                        1) ==
                                                    0)
                                                ? 0
                                                : (BaseController
                                                        .postLikedCount[index] -
                                                    1);
                                        BaseController.isLikedPost[index] =
                                            false;
                                      } else {
                                        BaseController.likedFeedbackId
                                            .add(currentFeedback);
                                        BaseController.postLikedCount.add(
                                            ((currentLikeCount - 1) == 0)
                                                ? 0
                                                : (currentLikeCount - 1));
                                        BaseController.isLikedPost.add(false);
                                      }
                                    }

                                    onLikeButtonTapped(isLiked);
                                    return !isLiked;
                                  },
                                ),
                                SizedBox(width: 9.w),
                                IconButton(
                                  onPressed: () {
                                    currentId =
                                        widget.feedback[widget.index].id;
                                    Get.to(() => FeedbackComment(
                                              feedbackId: widget
                                                  .feedback[widget.index].id,
                                              isClose: (widget.assignedPost &&
                                                      widget
                                                              .feedback[
                                                                  widget.index]
                                                              .status !=
                                                          '300')
                                                  ? true
                                                  : false,
                                            ))!
                                        .then((value) {
                                      commentCount.value =
                                          int.parse(value.toString());
                                      setState(() {});
                                    });
                                  },
                                  padding: const EdgeInsets.only(top: 2.0),
                                  icon: SvgPicture.asset(
                                    'assets/icons/Comments.svg',
                                    height: 31.h,
                                    width: 31.w,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      currentId =
                                          widget.feedback[widget.index].id;
                                      Get.to(() => FeedbackComment(
                                                feedbackId: widget
                                                    .feedback[widget.index].id,
                                                isClose: (widget.assignedPost &&
                                                        widget
                                                                .feedback[widget
                                                                    .index]
                                                                .status !=
                                                            '300')
                                                    ? true
                                                    : false,
                                              ))!
                                          .then((value) {
                                        commentCount.value =
                                            int.parse(value.toString());
                                        setState(() {});
                                      });
                                    },
                                    child: Obx(
                                      () => RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 14.sp,
                                            fontFamily: AppFonts.regularFont,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ((commentCount.value -
                                                          int.parse(widget
                                                              .feedback[
                                                                  widget.index]
                                                              .commented)) <=
                                                      0)
                                                  ? widget
                                                      .feedback[widget.index]
                                                      .commented
                                                  : ((commentCount.value -
                                                              int.parse(widget
                                                                  .feedback[
                                                                      widget
                                                                          .index]
                                                                  .commented)) +
                                                          int.parse(widget
                                                              .feedback[
                                                                  widget.index]
                                                              .commented))
                                                      .toString(),
                                            ),
                                            const TextSpan(
                                              text: " Comment(s)",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Wrap(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.w),
                                      child: Text(
                                        widget.feedback[widget.index].created,
                                        style: TextStyle(
                                          // color: Colors.black54,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14.sp,
                                          fontFamily: AppFonts.regularFont,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 25.w),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (builder) {
                                        return const ColorLegendDialog();
                                      },
                                    );
                                  },
                                  child: CustomStatus(
                                    color: BaseController
                                                .feedbackStatusId.isNotEmpty &&
                                            BaseController.feedbackStatusId
                                                .contains(widget
                                                    .feedback[widget.index].id)
                                        ? const Color(0xff00ab06)
                                        : widget.feedback[widget.index]
                                                    .status ==
                                                "300"
                                            ? const Color(0xff00ab06)
                                            : widget.feedback[widget.index]
                                                        .status ==
                                                    "200"
                                                ? const Color(0xffffa200)
                                                : widget.feedback[widget.index]
                                                            .status ==
                                                        "100"
                                                    ? const Color(0xff1f9aff)
                                                    : const Color(0xffa300a3),
                                    svgIcon: BaseController
                                                .feedbackStatusId.isNotEmpty &&
                                            BaseController.feedbackStatusId
                                                .contains(widget
                                                    .feedback[widget.index].id)
                                        ? "Icon.svg"
                                        : widget.feedback[widget.index]
                                                    .status ==
                                                "300"
                                            ? "Icon.svg"
                                            : widget.feedback[widget.index]
                                                        .status ==
                                                    "200"
                                                ? "MaterialIcon.svg"
                                                : widget.feedback[widget.index]
                                                            .status ==
                                                        "100"
                                                    ? "PixleIcon.svg"
                                                    : "observation.svg",
                                    isObservation:
                                        widget.feedback[widget.index].status ==
                                                "50"
                                            ? true
                                            : false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: 15.h,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 9,
        height: 9,
        decoration: BoxDecoration(
            color:
                currentIndex == index ? const Color(0xffff9d00) : Colors.white,
            shape: BoxShape.circle),
      );
    });
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    var response = await BaseClient().dioPost(
        '/feedback/${widget.feedback[widget.index].id}/liketoggle', null);
    if (response != null && response['success']) {
      return !isLiked;
    } else {
      return isLiked;
    }
  }
}
