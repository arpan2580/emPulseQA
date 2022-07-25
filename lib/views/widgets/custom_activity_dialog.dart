import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/activity_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

class CustomActivityDialog extends StatefulWidget {
  final int feedbackId;
  const CustomActivityDialog({
    Key? key,
    required this.feedbackId,
  }) : super(key: key);

  @override
  State<CustomActivityDialog> createState() => _CustomActivityDialogState();
}

class _CustomActivityDialogState extends State<CustomActivityDialog> {
  var activityController = Get.put(ActivityController());
  final scrollController = ScrollController();
  final scrollController1 = ScrollController();

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    activityController.fetchActivityData(widget.feedbackId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => activityController.isLoading.value
        ? const Center(
            child: CircularProgressIndicator.adaptive(),
          )
        : activityController.activityList.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () async {
                  await activityController.fetchActivityData(widget.feedbackId);
                },
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 17.0),
                    itemCount: (activityController.activityList[0].created !=
                                '' &&
                            activityController
                                .activityList[0].assigned!.isNotEmpty &&
                            activityController.activityList[0].resolved != null)
                        ? 3
                        : (activityController.activityList[0].created != '' &&
                                activityController
                                    .activityList[0].assigned!.isNotEmpty)
                            ? 2
                            : 1,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                        child: Row(
                          crossAxisAlignment: (index == 0)
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                (index == 0)
                                    ? Container()
                                    : Container(
                                        width: 2.0,
                                        height: 75.0,
                                        color: (index == 0)
                                            ? Theme.of(context)
                                                .scaffoldBackgroundColor
                                            : Colors.black,
                                      ),
                                Container(
                                  // margin:
                                  //     const EdgeInsets.only(left: 5.0, right: 5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: (index == 0)
                                        ? const Color(0xff1f9aff)
                                        : (index == 1)
                                            ? const Color(0xffffa200)
                                            : const Color(0xff00ab06),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: SvgPicture.asset(
                                    (index == 0)
                                        ? 'assets/icons/PixleIcon.svg'
                                        : (index == 1)
                                            ? 'assets/icons/MaterialIcon.svg'
                                            : 'assets/icons/Icon.svg',
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Container(
                                  width: 2.0,
                                  height: 75.0,
                                  color: (index == 2)
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
                                      : (activityController.activityList[0]
                                                      .resolved ==
                                                  null &&
                                              index == 1)
                                          ? Theme.of(context)
                                              .scaffoldBackgroundColor
                                          : (index == 0 &&
                                                  activityController
                                                      .activityList[0]
                                                      .assigned!
                                                      .isEmpty)
                                              ? Theme.of(context)
                                                  .scaffoldBackgroundColor
                                              : Colors.black,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Material(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: Container(
                                  height: (index == 1) ? 180 : null,
                                  margin: const EdgeInsets.only(left: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: (index == 0)
                                        ? Text(
                                            activityController
                                                .activityList[0].created,
                                            style: const TextStyle(
                                              fontFamily: AppFonts.regularFont,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : (index == 1)
                                            ? Scrollbar(
                                                thumbVisibility: true,
                                                controller: scrollController,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 7.0),
                                                  itemCount: activityController
                                                      .activityList[0]
                                                      .assigned!
                                                      .length,
                                                  controller: scrollController,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: Text(
                                                        activityController
                                                            .activityList[0]
                                                            .assigned![index],
                                                        style: const TextStyle(
                                                          fontFamily: AppFonts
                                                              .regularFont,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            : Text(
                                                activityController
                                                        .activityList[0]
                                                        .resolved ??
                                                    '',
                                                style: const TextStyle(
                                                  fontFamily:
                                                      AppFonts.regularFont,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            : Center(
                child: Material(
                  child: Text(
                    'No activity found for this feedback',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ));
  }
}
