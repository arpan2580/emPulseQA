import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/controllers/comment_controller.dart';
import 'package:empulse/controllers/dark_theme_controller.dart';
import 'package:empulse/controllers/feedback_controller.dart';
import 'package:empulse/controllers/image_controller.dart';
import 'package:empulse/views/dialogs/dialog_helper.dart';
import 'package:empulse/views/widgets/custom_comment_card.dart';
import 'package:empulse/views/widgets/custom_comment_image.dart';
import 'package:empulse/views/widgets/custom_feedback.dart';
import 'package:empulse/views/widgets/jumping_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../consts/regex.dart';

class FeedbackComment extends StatefulWidget {
  final String feedbackId;
  final bool isClose;
  final dynamic checked;
  const FeedbackComment({
    Key? key,
    required this.feedbackId,
    required this.isClose,
    this.checked,
  }) : super(key: key);

  @override
  State<FeedbackComment> createState() => _FeedbackCommentState();
}

class _FeedbackCommentState extends State<FeedbackComment> {
  TextEditingController comment = TextEditingController();
  var commentController = Get.put(CommentController());
  int commentId = 0, repliedId = 0;
  String userName = '';
  int activeImg = 0;
  var focusNode = FocusNode();
  List imgList = [];
  final ScrollController _controller = ScrollController();
  bool isExpanded = false, isFocus = false, value = false;
  dynamic imgArray;

  final _cameraController = ImageController(quality: 30);
  final _cameraController1 = ImageController(quality: 30);
  final _cameraController2 = ImageController(quality: 30);

  RxBool commentDelay = true.obs;

  @override
  void initState() {
    super.initState();
    // commentController.fetchFeedbackDetails(widget.feedbackId);
    commentController.showComment(widget.feedbackId.toString(), true);
    if (widget.checked != null && widget.checked) {
      value = true;
    }

    Future.delayed(const Duration(milliseconds: 4000), () {
      if (mounted) {
        setState(() {
          commentDelay.value = false;
        });
      }
    });
  }

  @override
  void dispose() {
    comment.clear();
    // widget.feedbackId = 0;
    _controller.dispose();
    _cameraController.dispose();
    _cameraController1.dispose();
    _cameraController2.dispose();
    super.dispose();
  }

  void _scrollDown() {
    // _controller.animateTo(
    //   _controller.position.maxScrollExtent,
    //   duration: const Duration(seconds: 1),
    //   curve: Curves.fastOutSlowIn,
    // );
    // if (_controller.hasClients) {
    Future.delayed(const Duration(milliseconds: 2000), () {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
    // }
  }

  Future refresh() async {
    comment.clear();
    // commentController.fetchFeedbackDetails(widget.feedbackId);
    commentController.showComment(widget.feedbackId.toString(), true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          "Comments",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: const [
          // MyNotificationBtn(),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          _cameraController.selectedImagePath.value = '';
          _cameraController.isImageSelected.value = false;
          _cameraController1.selectedImagePath.value = '';
          _cameraController1.isImageSelected.value = false;
          _cameraController2.selectedImagePath.value = '';
          _cameraController2.isImageSelected.value = false;
          Get.back(
              result: commentController.feedbackDetails.isNotEmpty
                  ? commentController.feedbackDetails[0].commented.toString()
                  : 0);
          return true;
        },
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: refresh,
            child: Obx(
              () => commentController.isLoading.value
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          commentId = 0;
                          repliedId = 0;
                          userName = '';
                        });
                      },
                      child: ListView(
                        controller: _controller,
                        shrinkWrap: true,
                        children: [
                          commentController.feedbackDetails.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      commentController.feedbackDetails.length,
                                  itemBuilder: (context, index) {
                                    if (commentController.feedbackDetails[index]
                                                .images !=
                                            null &&
                                        commentController
                                                .feedbackDetails[index].file1 !=
                                            '') {
                                      imgList = FeedbackController().getImgList(
                                          commentController
                                              .feedbackDetails[index].images);
                                    } else {
                                      imgList = [];
                                    }
                                    return CustomFeedback(
                                      index: index,
                                      feedback:
                                          commentController.feedbackDetails,
                                      imgList: imgList,
                                      assignedPost: false,
                                    );
                                  },
                                )
                              : Container(),
                          Padding(
                            padding: (isExpanded && widget.isClose)
                                ? const EdgeInsets.only(
                                    top: 0.0,
                                    left: 0.0,
                                    right: 5.0,
                                    bottom: 255.0)
                                : (isExpanded)
                                    ? const EdgeInsets.only(
                                        top: 0.0,
                                        left: 0.0,
                                        right: 5.0,
                                        bottom: 210.0)
                                    : (widget.isClose)
                                        ? const EdgeInsets.only(
                                            top: 0.0,
                                            left: 0.0,
                                            right: 5.0,
                                            bottom: 137.0)
                                        : const EdgeInsets.only(
                                            top: 0.0,
                                            left: 0.0,
                                            right: 5.0,
                                            bottom: 91.0),
                            child: Obx(() {
                              if (BaseController.commentReload.isTrue) {
                                commentController
                                    .showComment(
                                        widget.feedbackId.toString(), false)
                                    .then((value) {
                                  WidgetsBinding.instance.addPostFrameCallback(
                                      (_) => _scrollDown());
                                  if (commentController
                                          .feedbackDetails.isNotEmpty &&
                                      commentController
                                              .feedbackDetails[0].status ==
                                          '300') {
                                    if (BaseController.feedbackStatusId
                                        .contains(commentController
                                            .feedbackDetails[0].id!)) {
                                    } else {
                                      BaseController.feedbackStatusId.add(
                                          commentController
                                              .feedbackDetails[0].id!);
                                    }
                                  }
                                });

                                BaseController.commentReload.value = false;
                              }
                              return commentController
                                      .feedbackComments.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: commentController
                                          .feedbackComments.length,
                                      itemBuilder: (context, index) {
                                        if (commentController
                                                    .feedbackComments[index]
                                                    .images !=
                                                null &&
                                            commentController
                                                    .feedbackComments[index]
                                                    .file1 !=
                                                '') {
                                          imgList = commentController
                                              .getImgList(commentController
                                                  .feedbackComments[index]
                                                  .images);
                                        } else {
                                          imgList = [];
                                        }
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            CustomCommentCard(
                                                userprofile: commentController
                                                    .feedbackComments[index]
                                                    .profileImage,
                                                username:
                                                    "${commentController.feedbackComments[index].name}",
                                                comment:
                                                    "${commentController.feedbackComments[index].usercomment}",
                                                commentType: commentController
                                                    .feedbackComments[index]
                                                    .type,
                                                isSubComment: false,
                                                imgList: imgList,
                                                time: commentController
                                                    .feedbackComments[index]
                                                    .created,
                                                replyFunc: () {
                                                  commentId = commentController
                                                      .feedbackComments[index]
                                                      .commentId;
                                                  repliedId = commentController
                                                      .feedbackComments[index]
                                                      .commentId;
                                                  userName = commentController
                                                      .feedbackComments[index]
                                                      .name;
                                                  setState(() {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            focusNode);
                                                  });
                                                }),
                                            if (commentController
                                                    .feedbackComments[index]
                                                    .children
                                                    .length >
                                                0)
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 57.w),
                                                child: replyComment(
                                                    commentController
                                                        .feedbackComments[index]
                                                        .children,
                                                    commentController
                                                        .feedbackComments[index]
                                                        .commentId),
                                              )
                                            // for (var item in commentController
                                            //     .feedbackComments[index]
                                            //     .children)
                                          ],
                                        );
                                      },
                                    )
                                  : Obx(() {
                                      return (commentDelay.value)
                                          ? const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 25.0),
                                              child: JumpingDots(),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 25.0),
                                              child: Center(
                                                child: Text(
                                                  "No Comments",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            );
                                    });
                            }),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
      bottomSheet: Obx(
        () => commentController.ownImage.isNotEmpty ||
                commentController.ownName.isNotEmpty ||
                _cameraController.isImageSelected.value ||
                _cameraController1.isImageSelected.value
            ? Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: customCommentTypeField(),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(),
                ],
              ),
      ),
    );
  }

  Widget customCommentTypeField() {
    return isExpanded
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                thickness: 1.h,
                color: Theme.of(context).primaryColor.withOpacity(0.6),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  commentController.feedbackDetails.isNotEmpty &&
                          commentController.feedbackDetails[0].status !=
                              '300' &&
                          widget.isClose
                      ? Text(
                          "Click on this to mark the post as closed",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: AppFonts.regularFont,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : Container(),
                  commentController.feedbackDetails.isNotEmpty &&
                          commentController.feedbackDetails[0].status !=
                              '300' &&
                          widget.isClose
                      ? Theme(
                          data: ThemeData(
                            unselectedWidgetColor:
                                Theme.of(context).primaryColor,
                          ),
                          child: Checkbox(
                            value: value,
                            onChanged: (value) {
                              setState(() {
                                this.value = value!;
                              });
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
              userName != ''
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: replyDecoration(),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(left: 55.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    EmptyImageContainer(
                      controller: _cameraController,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    // EmptyImageContainer(
                    //   controller: _cameraController1,
                    // ),
                    ((_cameraController.selectedImagePath.value != '' ||
                                _cameraController1.selectedImagePath.value !=
                                    '') &&
                            _cameraController2.selectedImagePath.value == '')
                        ? EmptyImageContainer(
                            controller: _cameraController1,
                          )
                        : (_cameraController2.selectedImagePath.value != '' &&
                                _cameraController1.selectedImagePath.value !=
                                    '')
                            ? EmptyImageContainer(
                                controller: _cameraController1,
                              )
                            : (_cameraController.selectedImagePath.value !=
                                        '' &&
                                    _cameraController2
                                            .selectedImagePath.value !=
                                        '')
                                ? EmptyImageContainer(
                                    controller: _cameraController1,
                                  )
                                : Container(),

                    SizedBox(
                      width: 10.w,
                    ),
                    // EmptyImageContainer(
                    //   controller: _cameraController2,
                    // ),
                    ((_cameraController1.selectedImagePath.value != '' ||
                                _cameraController2.selectedImagePath.value !=
                                    '') &&
                            (_cameraController.selectedImagePath.value != '' ||
                                _cameraController1.selectedImagePath.value !=
                                    ''))
                        ? (_cameraController.selectedImagePath.value != '' ||
                                _cameraController2.selectedImagePath.value !=
                                    '')
                            ? EmptyImageContainer(
                                controller: _cameraController2,
                              )
                            : Container()
                        : (_cameraController2.selectedImagePath.value != '')
                            ? EmptyImageContainer(
                                controller: _cameraController2,
                              )
                            : Container(),
                  ],
                ),
              ),
              const SizedBox(
                height: 7.0,
              ),
              typeField(isFocus),
              const SizedBox(
                height: 5.0,
              ),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                thickness: 1.h,
                color: Theme.of(context).primaryColor.withOpacity(0.6),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  commentController.feedbackDetails.isNotEmpty &&
                          commentController.feedbackDetails[0].status !=
                              '300' &&
                          widget.isClose
                      ? Text(
                          "Click on this to mark the post as closed",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: AppFonts.regularFont,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : Container(),
                  commentController.feedbackDetails.isNotEmpty &&
                          commentController.feedbackDetails[0].status !=
                              '300' &&
                          widget.isClose
                      ? Theme(
                          data: ThemeData(
                            unselectedWidgetColor:
                                Theme.of(context).primaryColor,
                          ),
                          child: Checkbox(
                            value: value,
                            onChanged: (value) {
                              setState(() {
                                this.value = value!;
                              });
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
              userName != '' ? replyDecoration() : Container(),
              const SizedBox(
                height: 7.0,
              ),
              typeField(isFocus),
              const SizedBox(
                height: 5.0,
              ),
            ],
          );
  }

  Widget typeField(isFocus) {
    if (isFocus) {
      FocusScope.of(context).requestFocus(focusNode);
    }

    return SizedBox(
      height: 63.h,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              width: 37.w,
              // height: 37.h,
              child: Obx(
                () => commentController.ownImage.value.toString() == 'null' &&
                        commentController.ownName.value.isNotEmpty
                    ? CircleAvatar(
                        radius: 20.w,
                        child: Text(
                          BaseController.getinitials(
                              commentController.ownName.value.toString()),
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
                                commentController.ownImage.value.toString()),
                      ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 259.w,
            child: TextFormField(
              controller: comment,
              textAlign: TextAlign.start,
              inputFormatters: [
                LengthLimitingTextInputFormatter(500),
                FilteringTextInputFormatter.deny(
                    RegExp(Regex.regexToRemoveEmoji)),
              ],
              maxLines: 8,
              minLines: 1,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                hintText: "Type comments",
                hintStyle: TextStyle(
                  fontFamily: AppFonts.lightFont,
                  fontSize: 16.sp,
                  color: const Color(0xffbababa),
                ),
                border: const OutlineInputBorder(),
              ),
              style: TextStyle(
                fontFamily: AppFonts.regularFont,
                fontSize: 14.sp,
                color: Theme.of(context).primaryColor,
              ),
              focusNode: focusNode,
            ),
          ),
          SizedBox(
            height: 40.h,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              icon: SvgPicture.asset(
                'assets/icons/camera_icon.svg',
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
          GestureDetector(
            onTap: () {
              comment.text = comment.text.trim();
              if (comment.text != '') {
                FocusManager.instance.primaryFocus?.unfocus();
                commentController.usercomment = comment;
                String type;
                if (value) {
                  type = "2";
                } else {
                  type = "1";
                }
                if (_cameraController.selectedImagePath.value != '') {
                  commentController.file1 =
                      File(_cameraController.selectedImagePath.value);
                }
                if (_cameraController1.selectedImagePath.value != '') {
                  commentController.file2 =
                      File(_cameraController1.selectedImagePath.value);
                }
                if (_cameraController2.selectedImagePath.value != '') {
                  commentController.file3 =
                      File(_cameraController2.selectedImagePath.value);
                }
                if (_cameraController.selectedImagePath.value != '' ||
                    _cameraController1.selectedImagePath.value != '' ||
                    _cameraController2.selectedImagePath.value != '') {
                  commentController
                      .addCommentWithImage(
                          widget.feedbackId, type, commentId, repliedId)
                      .then((value) {
                    Future.wait([
                      commentController
                          .showComment(widget.feedbackId, true)
                          .then((value) => WidgetsBinding.instance
                              .addPostFrameCallback((_) => _scrollDown()))
                    ]);
                  });
                } else {
                  commentController
                      .addComment(widget.feedbackId, type, commentId, repliedId)
                      .then((value) => WidgetsBinding.instance
                          .addPostFrameCallback((_) => _scrollDown()));
                }
                setState(() {
                  commentId = 0;
                  repliedId = 0;
                  userName = '';
                  isExpanded = false;
                });
                commentDelay = true.obs;
                _cameraController.selectedImagePath.value = '';
                _cameraController.isImageSelected.value = false;
                _cameraController1.selectedImagePath.value = '';
                _cameraController1.isImageSelected.value = false;
                _cameraController2.selectedImagePath.value = '';
                _cameraController2.isImageSelected.value = false;
                comment.clear();
              } else {
                DialogHelper.showErrorToast(
                    description: 'Please type some comment before save.');
              }
            },
            child: Text(
              "POST",
              style: TextStyle(
                fontFamily: AppFonts.regularFont,
                fontSize: 16.sp,
                color: DarkThemeController.isDarkThemeEnabled.value
                    ? Colors.cyan
                    : const Color(0xff0056f5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget replyDecoration() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                "Replying to ",
                style: TextStyle(
                  fontFamily: AppFonts.regularFont,
                  fontSize: 12.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                userName,
                style: TextStyle(
                  fontFamily: AppFonts.regularFont,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                width: 7.w,
              ),
              GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    commentId = 0;
                    repliedId = 0;
                    userName = '';
                  });
                },
                child: Text(
                  "~ Cancel",
                  style: TextStyle(
                    fontFamily: AppFonts.regularFont,
                    fontSize: 12.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget replyComment(commentList, parentCommentId) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: commentList.length,
      itemBuilder: (context, cmntIndex) {
        return CustomCommentCard(
            userprofile: commentList[cmntIndex]["profile_image"],
            username: commentList[cmntIndex]["name"],
            comment: commentList[cmntIndex]["comment"],
            commentType: commentList[cmntIndex]["type"],
            isSubComment: true,
            imgList: const [],
            itemImages: commentList[cmntIndex]["images"],
            time: commentList[cmntIndex]["created"],
            replyFunc: () {
              commentId = parentCommentId;
              repliedId = commentList[cmntIndex]['comment_id'];
              userName = commentList[cmntIndex]["name"];
              setState(() {
                FocusScope.of(context).requestFocus(focusNode);
              });
            });
      },
    );
  }
}
