import 'dart:io';

import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/profile_controller.dart';
import 'package:empulse/models/profile_model.dart';
import 'package:empulse/views/pages/feedback_comments.dart';
import 'package:empulse/views/pages/maps.dart';
import 'package:empulse/views/widgets/custom_activity_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/dark_theme_controller.dart';

class CustomPopupMenu extends StatefulWidget {
  final int feedbackId;
  final String feedbackStatus;
  final bool isAssignedPost;
  final double lat, long;
  final dynamic context;
  const CustomPopupMenu({
    Key? key,
    required this.feedbackId,
    required this.feedbackStatus,
    required this.isAssignedPost,
    required this.lat,
    required this.long,
    required this.context,
  }) : super(key: key);

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _suggestionsBoxController = SuggestionsBoxController();
  TextEditingController txtFeedbackId = TextEditingController();
  TextEditingController userId = TextEditingController();
  String? selectedUserId;

  @override
  Widget build(BuildContext context) {
    return (widget.isAssignedPost && widget.feedbackStatus != '300')
        ? PopupMenuButton(
            color: Theme.of(context).scaffoldBackgroundColor,
            icon: Icon(
              Icons.more_vert_rounded,
              color: Theme.of(context).primaryColor,
            ),
            itemBuilder: (context) {
              return [
                popupMenuItem(
                  value: 'close',
                  label: 'Close',
                  icon: Icons.mark_chat_read_outlined,
                ),
                popupMenuItem(
                  value: 'assign_to',
                  label: 'Assign To',
                  icon: Icons.ios_share,
                ),
                popupMenuItem(
                  value: 'share',
                  label: 'Share',
                  icon: Icons.share,
                ),
                popupMenuItem(
                  value: 'open_map',
                  label: 'Open in map',
                  icon: Icons.location_on_rounded,
                ),
                popupMenuItem(
                  value: 'activity_log',
                  label: 'Activity Log',
                  icon: Icons.local_activity_rounded,
                ),
              ];
            },
            onSelected: (String value) {
              popUpItemAction(value, widget.lat, widget.long);
            },
          )
        : PopupMenuButton(
            color: Theme.of(context).scaffoldBackgroundColor,
            icon: Icon(
              Icons.more_vert_rounded,
              color: Theme.of(context).primaryColor,
            ),
            itemBuilder: (context) {
              return [
                popupMenuItem(
                  value: 'share',
                  label: 'Share',
                  icon: Icons.share,
                ),
                popupMenuItem(
                  value: 'open_map',
                  label: 'Open in map',
                  icon: Icons.location_on_rounded,
                ),
                popupMenuItem(
                  value: 'activity_log',
                  label: 'Activity Log',
                  icon: Icons.local_activity_rounded,
                ),
              ];
            },
            onSelected: (String value) {
              popUpItemAction(value, widget.lat, widget.long);
            },
          );
  }

  PopupMenuItem<String> popupMenuItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 19.0,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          const SizedBox(
            width: 7.0,
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void popUpItemAction(String value, double lat, double lon) async {
    if (value == 'close') {
      Get.to(() => FeedbackComment(
            feedbackId: widget.feedbackId.toString(),
            isClose: true,
            checked: true,
          ));
    }
    if (value == 'open_map') {
      if (Platform.isIOS) {
        final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          throw 'Could not launch $url';
        }
      } else {
        Get.to(
          () => Maps(
            target: LatLng(lat, lon),
          ),
        );
      }
    }
    if (value == 'share') {
      // searchUserDialog("Choose user to Share this Post",
      //     "Please select user to share this post", "Share", true);
      onShare(
          "Check out this post on emPulse https://premierclub.itc.in/EmPulseQA/public/feedback/${widget.feedbackId}",
          "Check out this post from emPulse");
    }
    if (value == 'assign_to') {
      searchUserDialog("Choose user to Assign this Post",
          "Please select user to assign this post", "Assign", false);
    }
    if (value == 'activity_log') {
      showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black54,
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation,
              Animation secondaryAnimation) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                width: MediaQuery.of(context).size.width - 20,
                height: MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.all(2),
                child: Column(
                  children: [
                    Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          "Activity Log",
                          style: TextStyle(
                            fontFamily: AppFonts.regularFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: CustomActivityDialog(
                            feedbackId: widget.feedbackId)),
                  ],
                ),
              ),
            );
          });
    }
  }

  void searchUserDialog(
      String title, String validatorTxt, String btnTxt, bool isShare) {
    showDialog(
      context: widget.context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 16,
          child: SizedBox(
            height: Get.height / 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TypeAheadFormField<ProfileModel>(
                          hideSuggestionsOnKeyboardHide: true,
                          suggestionsBoxController: _suggestionsBoxController,
                          debounceDuration: const Duration(milliseconds: 200),
                          suggestionsCallback: ProfileController().getUserList,
                          itemBuilder: (context, suggestions) {
                            final user = suggestions;
                            return ListTile(
                              title: Text(
                                user.name!.trim(),
                                style: TextStyle(
                                  fontFamily: "RobotoCondensed",
                                  fontSize: 16.sp,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              subtitle: (user.mobile != null)
                                  ? Text(
                                      user.email.trim() +
                                          ",  " +
                                          user.mobile.toString(),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )
                                  : Text(
                                      user.email.trim(),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                            );
                          },
                          onSuggestionSelected: (user) {
                            userId.text = user.name!;
                            selectedUserId = user.id.toString();
                            txtFeedbackId.text = widget.feedbackId.toString();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return validatorTxt;
                            }
                            return null;
                          },
                          noItemsFoundBuilder: (context) {
                            return SizedBox(
                              height: 100.h,
                              child: const Center(
                                child: Text("User not found"),
                              ),
                            );
                          },
                          suggestionsBoxDecoration: SuggestionsBoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(7),
                            constraints: const BoxConstraints(maxHeight: 300),
                          ),
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: userId,
                            decoration: InputDecoration(
                              hintText: "Search user",
                              hintStyle: TextStyle(
                                fontFamily: AppFonts.regularFont,
                                fontSize: 16.sp,
                                color:
                                    DarkThemeController.isDarkThemeEnabled.value
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5)
                                        : Colors.black12.withOpacity(0.5),
                              ),
                            ),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        MaterialButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            var validate = _formKey.currentState!.validate();
                            if (validate) {
                              Get.back();
                              if (isShare) {
                                ProfileController().shareFeedback(
                                    txtFeedbackId.text.trim(), selectedUserId);
                              } else {
                                ProfileController().assignFeedback(
                                    txtFeedbackId.text.trim(), selectedUserId);
                              }

                              setState(() {
                                userId.clear();
                                txtFeedbackId.clear();
                              });
                            }
                          },
                          color: const Color(0xff108ab3),
                          child: Text(
                            btnTxt,
                            style: TextStyle(
                              fontFamily: AppFonts.regularFont,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              // letterSpacing: 0.8,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onShare(String url, String subject) async {
    final box = widget.context.findRenderObject() as RenderBox?;

    await Share.share(
      url,
      subject: subject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
