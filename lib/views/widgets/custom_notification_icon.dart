import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/views/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:vector_math/vector_math.dart' as math;

class CustomNotificationIcon extends StatelessWidget {
  const CustomNotificationIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.rotate(
          angle: math.radians(45),
          child: IconButton(
            onPressed: () {
              Get.to(
                () => const NotificationPage(),
              );
            },
            icon: SvgPicture.asset(
              'assets/icons/Notification.svg',
              height: 29.h,
              width: 29.w,
            ),
          ),
        ),
        Positioned(
          top: 10,
          bottom: 0,
          left: 20,
          child: InkWell(
            onTap: () {
              Get.to(
                () => const NotificationPage(),
              );
            },
            child: Obx(
              () => (BaseController.unreadNotification.value != 0)
                  ? CircleAvatar(
                      radius: 10.w,
                      child: Text(
                        BaseController.unreadNotification.value.toString(),
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      backgroundColor: Colors.red,
                    )
                  : Container(),
            ),
          ),
        ),
      ],
    );
  }
}
