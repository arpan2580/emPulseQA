import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/controllers/notification_controller.dart';
import 'package:empulse/views/pages/feedback_comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';

class CustomNotification extends StatefulWidget {
  final int index;
  final dynamic notification;
  const CustomNotification(
      {Key? key, required this.index, required this.notification})
      : super(key: key);

  @override
  State<CustomNotification> createState() => _CustomNotificationState();
}

class _CustomNotificationState extends State<CustomNotification> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.notification[widget.index].status == "0") {
          NotificationController().readNotification(
              widget.notification[widget.index].notificationId);
        }
        Get.off(() => FeedbackComment(
              feedbackId:
                  int.parse(widget.notification[widget.index].feedbackId),
              isClose: false,
            ));
      },
      child: Container(
        decoration: (widget.notification[widget.index].status == "0")
            ? const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topLeft,
                  colors: [
                    Color.fromARGB(255, 209, 209, 209),
                    // Colors.white,
                    Color(0xfff2f2f2)
                  ],
                ),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  widget.notification[widget.index].profileImage == null
                      ? CircleAvatar(
                          radius: 35.w,
                          child: Text(
                            BaseController.getinitials(
                                widget.notification[widget.index].name),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        )
                      : CircleAvatar(
                          radius: 35.w,
                          backgroundImage: NetworkImage(BaseController
                                  .baseImgUrl +
                              widget.notification[widget.index].profileImage),
                        ),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: (widget.notification[widget.index].type ==
                            "1")
                        ? const Color(0xff08c9ff)
                        : (widget.notification[widget.index].type == "2")
                            ? const Color(0xff009400)
                            : (widget.notification[widget.index].type == "3")
                                ? const Color(0xffff0808)
                                : const Color(0xffa300a3),
                    child: Center(
                      child: Padding(
                        padding: (widget.notification[widget.index].type == "1")
                            ? const EdgeInsets.only(top: 2.0)
                            : const EdgeInsets.all(0.0),
                        child: SvgPicture.asset(
                          (widget.notification[widget.index].type == "1")
                              ? 'assets/icons/not-comment.svg'
                              : (widget.notification[widget.index].type ==
                                          "2" ||
                                      widget.notification[widget.index].type ==
                                          "4")
                                  ? 'assets/icons/like.svg'
                                  : 'assets/icons/pin.svg',
                          height:
                              (widget.notification[widget.index].type == "2")
                                  ? 17
                                  : 12,
                          width: (widget.notification[widget.index].type == "2")
                              ? 17
                              : 12,
                          allowDrawingOutsideViewBox: true,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                widget.notification[widget.index].name,
                style: const TextStyle(
                  fontFamily: AppFonts.regularFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.notification[widget.index].message}",
                    // maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppFonts.regularFont,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "${widget.notification[widget.index].created}",
                    style: const TextStyle(
                      fontFamily: AppFonts.regularFont,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
