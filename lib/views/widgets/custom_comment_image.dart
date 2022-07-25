import 'dart:io';

import 'package:empulse/controllers/image_controller.dart';
import 'package:empulse/views/widgets/custom_dialog.dart';
import 'package:empulse/views/widgets/custom_open_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

class EmptyImageContainer extends StatelessWidget {
  final ImageController controller;
  const EmptyImageContainer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        controller.isImageSelected.isFalse
            ? showModalBottomSheet(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                context: context,
                builder: ((builder) => CustomOpenImage(
                      context: context,
                      controller: controller,
                    )))
            : null;
      },
      child: imagePicker(
        Obx(() {
          return controller.selectedImagePath.value == ''
              ? SvgPicture.asset(
                  'assets/icons/Add.svg',
                  color: Colors.black,
                  width: 22.w,
                  height: 22.h,
                )
              : Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 83.w,
                      height: 133.h,
                      color: const Color(0xffdadada),
                      child: Image.file(
                        File(controller.selectedImagePath.value),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        height: 40.h,
                        width: 40.w,
                        child: FloatingActionButton(
                          backgroundColor: const Color(0xff108ab3),
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                              context: context,
                              builder: ((builder) => myCustomDialog(
                                    context,
                                    () {
                                      controller.selectedImagePath.value = '';
                                      controller.isImageSelected.value = false;
                                      Get.back();
                                    },
                                  )),
                            );
                          },
                          child: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ],
                );
        }),
      ),
    );
  }

  Widget imagePicker(Widget imageWidget) {
    return Container(
      width: 83.w,
      height: 133.h,
      color: const Color(0xffdadada),
      child: Center(
        child: imageWidget,
      ),
    );
  }
}
