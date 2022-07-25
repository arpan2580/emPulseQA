import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/controllers/dark_theme_controller.dart';
import 'package:empulse/controllers/profile_controller.dart';
import 'package:empulse/views/pages/photo_view.dart';
import 'package:empulse/views/pages/splash_page.dart';
import 'package:empulse/views/widgets/custom_about_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../consts/regex.dart';
import '../dialogs/dialog_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    profileController.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => profileController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CustomProfile(
              userDetails: profileController.userDetails[0],
              isNotMe: false,
              controller: profileController,
            ),
    );
  }
}

class CustomProfile extends StatefulWidget {
  final dynamic userDetails;
  final bool isNotMe;
  final dynamic controller;
  const CustomProfile({
    Key? key,
    required this.userDetails,
    required this.isNotMe,
    this.controller,
  }) : super(key: key);

  @override
  State<CustomProfile> createState() => _CustomProfileState();
}

class _CustomProfileState extends State<CustomProfile> {
  var focusNode = FocusNode();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool isBioEdit = false;
  final storedToken = GetStorage();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    if (Platform.isIOS) WebView.platform = CupertinoWebView();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isNotMe
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userDetails.name,
                  style: TextStyle(
                    fontFamily: AppFonts.regularFont,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    // color: const Color(0xff000000),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  // widget.userDetails.mobile == null
                  //     ?
                  widget.userDetails.email,
                  // : "${widget.userDetails.email}, ${widget.userDetails.mobile}",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: DarkThemeController.isDarkThemeEnabled.value
                        ? Theme.of(context).primaryColor.withOpacity(0.6)
                        : const Color.fromARGB(255, 72, 72, 72),
                  ),
                  // textAlign: TextAlign.justify,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DottedBorder(
                          borderType: BorderType.Circle,
                          strokeWidth: 2.5,
                          color: const Color(0xff108ab3),
                          dashPattern: const [7, 5, 7, 5, 7, 5],
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: widget.userDetails.profileImage == null
                                ? CircleAvatar(
                                    radius: 40.w,
                                    child: Text(
                                      BaseController.getinitials(
                                          widget.userDetails.name),
                                      style: const TextStyle(
                                        fontSize: 27,
                                        // color: Colors.white,
                                        fontFamily: AppFonts.regularFont,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      // Get.to(
                                      //   () => PhotoView(
                                      //     imgList:
                                      //         widget.userDetails.profileImage,
                                      //     index: 0,
                                      //     isProfile: true,
                                      //   ),
                                      // );
                                    },
                                    child: CircleAvatar(
                                      radius: 40.w,
                                      backgroundImage: NetworkImage(
                                          BaseController.baseImgUrl +
                                              widget.userDetails.profileImage),
                                    ),
                                  ),
                          ),
                        ),
                        dataCard(
                          widget.userDetails.totalFeedbacks.toString(),
                          "Feedback",
                        ),
                        dataCard(
                          widget.userDetails.totalComments.toString(),
                          "Comments",
                        ),
                        dataCard(
                          widget.userDetails.totalLikes.toString(),
                          "Like",
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                  child: Text(
                    (widget.userDetails.bio) ??
                        storedToken.read("defaultBio").toString(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: AppFonts.regularFont,
                      color: DarkThemeController.isDarkThemeEnabled.value
                          ? Theme.of(context).primaryColor.withOpacity(0.6)
                          : const Color.fromARGB(255, 72, 72, 72),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Divider(
                  thickness: 1.0,
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                )
              ],
            ),
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                isBioEdit = false;
                focusNode.unfocus();
              });
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          DottedBorder(
                            borderType: BorderType.Circle,
                            strokeWidth: 2.5,
                            color: const Color(0xff108ab3),
                            dashPattern: const [5, 5],
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: _imageFile == null ||
                                      _imageFile.toString() == ''
                                  ? widget.userDetails.profileImage == null
                                      ? CircleAvatar(
                                          radius: 80.w,
                                          child: Text(
                                            BaseController.getinitials(
                                                widget.userDetails.name),
                                            style: const TextStyle(
                                              fontSize: 27,
                                              // color: Colors.white,
                                              fontFamily: AppFonts.regularFont,
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => PhotoView(
                                                imgList: widget
                                                    .userDetails.profileImage,
                                                index: 0,
                                                isProfile: true,
                                              ),
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 80.w,
                                            backgroundImage: NetworkImage(
                                                BaseController.baseImgUrl +
                                                    widget.userDetails
                                                        .profileImage),
                                          ),
                                        )
                                  : CircleAvatar(
                                      radius: 80.w,
                                      backgroundImage: FileImage(_imageFile!),
                                    ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  context: context,
                                  builder: ((builder) => openImage()));
                            },
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xff002770),
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        widget.userDetails.name,
                        style: TextStyle(
                          fontFamily: AppFonts.regularFont,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${widget.userDetails.email}${(widget.userDetails.mobile != null) ? ',${widget.userDetails.mobile}' : ''}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: DarkThemeController.isDarkThemeEnabled.value
                              ? Theme.of(context).primaryColor.withOpacity(0.6)
                              : const Color.fromARGB(255, 72, 72, 72),
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15.h),
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "About/Status",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color:
                                  DarkThemeController.isDarkThemeEnabled.value
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.9)
                                      : const Color.fromARGB(255, 27, 27, 27),
                              // fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      // CODE FOR DISPLAYING THE STATUS STARTS HERE :).
                      (isBioEdit)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13.0,
                                vertical: 13.0,
                              ),
                              child: TextFormField(
                                focusNode: focusNode,
                                controller: widget.controller.txtBio,
                                textAlign: TextAlign.justify,
                                maxLines: 4,
                                maxLength: 200,
                                // initialValue: widget.userDetails.bio,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(Regex.regexToRemoveEmoji)),
                                ],
                                style: TextStyle(
                                  fontFamily: AppFonts.regularFont,
                                  fontSize: 15.sp,
                                  color: Theme.of(context).primaryColor,
                                ),
                                decoration: InputDecoration(
                                  suffixIconConstraints: const BoxConstraints(
                                      minWidth: 23, maxHeight: 20),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 13.0),
                                    child: InkWell(
                                      onTap: () {
                                        if (widget
                                            .controller.txtBio.text.isEmpty) {
                                          DialogHelper.showInfoToast(
                                              description:
                                                  'Please enter your status before upload.');
                                        } else if (widget
                                                .controller.txtBio.text ==
                                            ' ') {
                                          DialogHelper.showInfoToast(
                                              description:
                                                  'Please enter your status before upload.');
                                        } else {
                                          widget.controller.updateProfileBio();
                                          setState(() {
                                            isBioEdit = false;
                                            focusNode.unfocus();
                                          });
                                        }
                                      },
                                      child: const Icon(Icons.send_rounded),
                                    ),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 13.h, horizontal: 13.0),
                              // Below INK WELL is used to make the container editable on click.
                              child: InkWell(
                                onTap: () {
                                  focusNode.requestFocus();
                                  if (widget.userDetails.bio != null) {
                                    widget.controller.txtBio.text =
                                        widget.userDetails.bio;
                                  }
                                  if (widget.userDetails.bio == null) {
                                    widget.controller.txtBio.text =
                                        "Hi There I am using empulse..";
                                  }
                                  setState(() {
                                    isBioEdit = true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: DarkThemeController
                                                .isDarkThemeEnabled.value
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.4)
                                            : Colors.grey.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 13.0,
                                            right: 10.0,
                                            bottom: 13.0,
                                            left: 15.0,
                                          ),
                                          child: Text(
                                            (widget.userDetails.bio) ??
                                                storedToken
                                                    .read("defaultBio")
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontFamily: AppFonts.regularFont,
                                              color: DarkThemeController
                                                      .isDarkThemeEnabled.value
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.8)
                                                  : const Color.fromARGB(
                                                      255, 72, 72, 72),
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            focusNode.requestFocus();
                                            if (widget.userDetails.bio !=
                                                null) {
                                              widget.controller.txtBio.text =
                                                  widget.userDetails.bio;
                                            }
                                            if (widget.userDetails.bio ==
                                                null) {
                                              widget.controller.txtBio.text =
                                                  "Hi There I am using empulse..";
                                            }
                                            setState(() {
                                              isBioEdit = true;
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            'assets/icons/edit-bio.svg',
                                            height: 30,
                                            width: 30,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          dataCard(
                            widget.userDetails.totalFeedbacks.toString(),
                            "Feedback",
                          ),

                          // // SizedBox(width: 14.w),
                          dataCard(
                            widget.userDetails.totalLikes.toString(),
                            "Like",
                          ),

                          dataCard(
                            widget.userDetails.totalComments.toString(),
                            "Comments",
                          ),

                          // // SizedBox(width: 14.w),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: Theme.of(context).primaryColor,
                        // thickness: 4,
                        indent: 20.w,
                        endIndent: 20.w,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          dataCard(
                            widget.userDetails.assignedFeedbacks.toString(),
                            "Assigned Posts",
                          ),
                          // // SizedBox(width: 14.w),
                          dataCard(
                            widget.userDetails.closedFeedbacks.toString(),
                            "Closed Posts",
                          ),

                          // // SizedBox(width: 14.w),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      // SizedBox(height: 71.h),

                      customBtn(
                        context,
                        () {},
                        Icon(
                          Icons.dark_mode_rounded,
                          color: DarkThemeController.isDarkThemeEnabled.value
                              ? Theme.of(context).primaryColor.withOpacity(0.5)
                              : Colors.black54,
                        ),
                        "DARK MODE",
                        CupertinoSwitch(
                          value: DarkThemeController.isDarkThemeEnabled.value,
                          onChanged: (value) {
                            DarkThemeController.toggleTheme(value);
                          },
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                      customBtn(
                        context,
                        () {
                          var appTour = GetStorage();

                          appTour.write("app_tour", null);

                          Get.off(() => const SplashPage());
                        },
                        Icon(
                          Icons.replay,
                          color: DarkThemeController.isDarkThemeEnabled.value
                              ? Theme.of(context).primaryColor.withOpacity(0.5)
                              : Colors.black54,
                        ),
                        "APP TOUR",
                        null,
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                      customBtn(
                        context,
                        () {
                          showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: MaterialLocalizations.of(context)
                                  .modalBarrierDismissLabel,
                              barrierColor: Colors.black54,
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder: (BuildContext buildContext,
                                  Animation animation,
                                  Animation secondaryAnimation) {
                                return Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9.0),
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    height: MediaQuery.of(context).size.height -
                                        230,
                                    padding: const EdgeInsets.all(2),
                                    child: const CustomAboutDialog(),
                                  ),
                                );
                              });
                        },
                        Padding(
                          padding: const EdgeInsets.only(left: 3.5),
                          child: Image.asset(
                            'assets/images/aboutAppIcon.png',
                            height: 20,
                            width: 20,
                          ),
                        ),
                        "ABOUT APP",
                        null,
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                      customBtn(
                        context,
                        () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (builder) {
                                return AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  title: Text(
                                    "Confirm Logout",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  content: Text(
                                    "Please click on Confirm, if you want to logout",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        widget.controller.logout();
                                        setState(() {});
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                      ),
                                      child: const Text("Confirm"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "No",
                                        style: TextStyle(
                                          color: Colors.cyan,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        SvgPicture.asset(
                          'assets/icons/logout.svg',
                          height: 30,
                          width: 30,
                        ),
                        "LOGOUT",
                        null,
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  MaterialButton customBtn(
      BuildContext context, action, icon, text, suffixicon) {
    return MaterialButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () {
        action();
      },
      child: Row(
        children: [
          icon,
          SizedBox(
            width: (text == "LOGOUT") ? 9.w : 15.w,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 19.sp,
                fontFamily: AppFonts.lightFont,
                fontWeight: FontWeight.normal,
                color: DarkThemeController.isDarkThemeEnabled.value
                    ? Theme.of(context).primaryColor.withOpacity(0.9)
                    : const Color(0xff424242),
              ),
            ),
          ),
          (suffixicon != null)
              ? Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: suffixicon,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget dataCard(value, label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: (widget.isNotMe) ? 20.sp : 18.sp,
            fontFamily: AppFonts.regularFont,
            // color: Colors.black,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: (widget.isNotMe) ? 16.sp : 14.sp,
            fontFamily: AppFonts.lightFont,
            fontWeight: FontWeight.normal,
            color: DarkThemeController.isDarkThemeEnabled.value
                ? Theme.of(context).primaryColor.withOpacity(0.6)
                : const Color(0xff424242),
            // color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget profileBtn(text, function) {
    return OutlinedButton(
      onPressed: function,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontFamily: AppFonts.regularFont,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget openImage() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose Image Source",
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                      takePhoto(ImageSource.camera);
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    "Camera",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                      takePhoto(ImageSource.gallery);
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    "Gallery",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );

    if (pickedFile != null) {
      CroppedFile? _croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50,
        cropStyle: CropStyle.circle,
        // maxWidth: 250,
        // maxHeight: 250,
        uiSettings: [
          AndroidUiSettings(
            hideBottomControls: true,
            lockAspectRatio: false,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
          ),
          IOSUiSettings(
            hidesNavigationBar: true,
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (_croppedImage != null) {
        final path = _croppedImage.path;
        setState(() {
          _imageFile = File(path);
        });
        // print("Cropped File =========> ${_imageFile!.path}");

        widget.controller.updateProfileImage(_imageFile);
      }
      // widget.controller.updateProfileImage(File(pickedFile.path));
    }
  }
}
