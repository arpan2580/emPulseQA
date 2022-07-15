import 'dart:io' as Io;
import 'package:empulse/views/dialogs/toast_msg.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  var selectedImagePath = ''.obs;
  var toBase64String = ''.obs;
  RxBool isImageSelected = false.obs;
  RxBool isConverted = false.obs;
  int quality;
  ImageController({required this.quality});

  void getImage(ImageSource imgSrc) async {
    // ignore: deprecated_member_use
    final pickedFile = await ImagePicker().getImage(
      source: imgSrc,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (pickedFile != null) {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(pickedFile.path);
      if (properties.width! > properties.height!) {
        Io.File compressedImage = await FlutterNativeImage.compressImage(
            pickedFile.path.toString(),
            targetWidth: 1000,
            targetHeight:
                (properties.height! * 1000 / properties.width!).round());

        selectedImagePath.value = compressedImage.path;
        isImageSelected = RxBool(true);
      } else {
        Io.File compressedImage = await FlutterNativeImage.compressImage(
          pickedFile.path.toString(),
          targetWidth: (properties.width! * 1600 / properties.height!).round(),
          targetHeight: 1600,
        );

        selectedImagePath.value = compressedImage.path;
        isImageSelected = RxBool(true);
      }
    } else {
      ToastMsg().warningToast("No Image is selected");
    }
  }
}