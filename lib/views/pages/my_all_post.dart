import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/views/pages/my_assigned_page.dart';
import 'package:empulse/views/pages/my_feedback_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

class MyAllPost extends StatefulWidget {
  final bool isSearch;
  const MyAllPost({Key? key, required this.isSearch}) : super(key: key);

  @override
  State<MyAllPost> createState() => _MyAllPostState();
}

class _MyAllPostState extends State<MyAllPost> {
  var baseController = Get.put(BaseController());
  bool isSearch = false;
  int index = 0;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    baseController.fetchGlobalData();
  }

  @override
  Widget build(BuildContext context) {
    final _children = [
      MyFeedbackPage(
        isSearch: isSearch,
      ),
      MyAssignedPage(
        isSearch: isSearch,
      ),
    ];
    return Obx(
      () => BaseController.assignedPosts.value > 0
          ? Column(
              children: [
                Row(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: InkWell(
                        onTap: () => setState(() {
                          index = 0;
                        }),
                        splashColor: Colors.grey.withOpacity(0.5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: (index == 0)
                                ? const Border(
                                    bottom: BorderSide(
                                        width: 2.0, color: Color(0xff6200ee)),
                                  )
                                : Border(
                                    bottom: BorderSide(
                                        width: 2.0,
                                        color: Colors.grey.withOpacity(0.1)),
                                  ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 13.0),
                            child: Center(
                              child: Text(
                                "My Posts",
                                style: TextStyle(
                                  fontWeight: (index == 0)
                                      ? FontWeight.bold
                                      : FontWeight.w400,
                                  color: const Color(0xff6200ee),
                                  fontFamily: AppFonts.regularFont,
                                  // fontSize: (index == 0) ? 16.sp : 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: InkWell(
                        onTap: () => setState(() {
                          index = 1;
                        }),
                        splashColor: Colors.grey.withOpacity(0.5),
                        child: Container(
                          decoration: BoxDecoration(
                            border: (index == 1)
                                ? const Border(
                                    bottom: BorderSide(
                                        width: 2.0, color: Color(0xff6200ee)),
                                  )
                                : Border(
                                    bottom: BorderSide(
                                        width: 2.0,
                                        color: Colors.grey.withOpacity(0.1)),
                                  ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 13.0),
                            child: Center(
                              child: Text(
                                "Assigned Posts",
                                style: TextStyle(
                                  fontWeight: (index == 1)
                                      ? FontWeight.bold
                                      : FontWeight.w400,
                                  color: const Color(0xff6200ee),
                                  fontFamily: AppFonts.regularFont,
                                  // fontSize: (index == 1) ? 16.sp : 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: _children[index]),
              ],
            )
          : _children[index],
    );
  }
}
