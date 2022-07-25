import 'package:empulse/controllers/feedback_controller.dart';
import 'package:empulse/controllers/genre_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controllers/base_controller.dart';
import 'custom_search_dialog.dart';

class CustomSearchIcon extends StatelessWidget {
  final FeedbackController feedbackController;
  final GenreController genreController;
  final dynamic getData;
  final dynamic index;
  const CustomSearchIcon({
    Key? key,
    required this.feedbackController,
    required this.genreController,
    required this.getData,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (index == 0 || index == 1)
          ? Stack(
              children: [
                IconButton(
                  onPressed: () {
                    if (feedbackController.isFilterApplied == false) getData();
                    showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: "",
                      barrierColor: Colors.transparent.withOpacity(0.1),
                      context: context,
                      transitionDuration: const Duration(milliseconds: 350),
                      pageBuilder: (context, a1, a2) {
                        return CustomSearchDialog(
                          isMyFeedback: (index == 1) ? true : false,
                          isFilterApplied:
                              feedbackController.isFilterApplied ? true : false,
                          genreController: genreController,
                          feedbackController: feedbackController,
                          dialogContext: context,
                        );
                      },
                      transitionBuilder: (context, anim1, anim2, child) {
                        return SlideTransition(
                          position: Tween(
                                  begin: const Offset(0, -1),
                                  end: const Offset(0, 0))
                              .animate(anim1),
                          child: child,
                        );
                      },
                    );
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 3.5),
                    child: SvgPicture.asset(
                      'assets/icons/Search.svg',
                      height: 29.h,
                      width: 29.w,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 23,
                  left: 27,
                  child: InkWell(
                    onTap: () {
                      if (feedbackController.isFilterApplied == false) {
                        getData();
                      }

                      showGeneralDialog(
                        barrierDismissible: true,
                        barrierLabel: "",
                        barrierColor: Colors.transparent.withOpacity(0.1),
                        context: context,
                        transitionDuration: const Duration(milliseconds: 350),
                        pageBuilder: (context, a1, a2) {
                          return CustomSearchDialog(
                            isMyFeedback: (index == 1) ? true : false,
                            isFilterApplied: feedbackController.isFilterApplied
                                ? true
                                : false,
                            genreController: genreController,
                            feedbackController: feedbackController,
                            dialogContext: context,
                          );
                        },
                        transitionBuilder: (context, anim1, anim2, child) {
                          return SlideTransition(
                            position: Tween(
                                    begin: const Offset(0, -1),
                                    end: const Offset(0, 0))
                                .animate(anim1),
                            child: child,
                          );
                        },
                      );
                    },
                    child: (BaseController.isSearchApplied.value)
                        ? CircleAvatar(
                            radius: 5.w,
                            backgroundColor: Colors.red,
                          )
                        : Container(),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
