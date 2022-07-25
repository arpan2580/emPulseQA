import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../controllers/dark_theme_controller.dart';

class PhotoView extends StatefulWidget {
  final dynamic imgList;
  final int index;
  final bool isProfile;

  const PhotoView({
    Key? key,
    required this.imgList,
    required this.index,
    required this.isProfile,
  }) : super(key: key);

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  RxInt activeImg = 0.obs;

  @override
  void initState() {
    super.initState();
    activeImg.value = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    PageController _pageController =
        PageController(initialPage: activeImg.value);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Image(
          image: AssetImage(DarkThemeController.isDarkThemeEnabled.value
              ? 'assets/images/Logo-light.png'
              : 'assets/images/Logo_empulse.png'),
          height: 50.h,
        ),
        // leadingWidth: 40.w,
        actions: const [
          // CustomNotificationIcon(),
        ],
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              itemCount: (widget.isProfile) ? 1 : widget.imgList.length,
              pageController: _pageController,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(
                    (widget.isProfile)
                        ? BaseController.baseImgUrl + widget.imgList
                        : BaseController.baseImgUrl + widget.imgList[index],
                  ),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              onPageChanged: (currentImg) {
                activeImg.value = currentImg;
              },
              backgroundDecoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              // enableRotation: true,
              loadingBuilder: (context, event) => const Center(
                child: SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
            widget.imgList.length >= 1 && widget.isProfile
                ? Container()
                : Positioned(
                    top: 15,
                    right: 11,
                    child: Container(
                      width: 65,
                      height: 32,
                      child: Center(
                        child: Obx(
                          () => Text(
                            (activeImg.value + 1).toString() +
                                "/${widget.imgList.length}",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppFonts.regularFont,
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
