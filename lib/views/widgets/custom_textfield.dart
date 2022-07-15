import 'package:empulse/consts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../consts/regex.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool obsecureTxt;
  final int? maxLength;
  final bool suffixIcon;
  final int? maxLine;
  final bool fullBorder;
  final bool centerText;
  final String? counterText;
  final dynamic Function() validation;
  const CustomTextfield({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    this.labelText,
    this.counterText,
    this.keyboardType,
    required this.obsecureTxt,
    this.maxLength,
    required this.suffixIcon,
    this.maxLine,
    required this.fullBorder,
    required this.centerText,
    required this.validation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: AppFonts.regularFont,
          color: Colors.black12.withOpacity(0.5),
        ),
        counterText: counterText,
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: "RobotoCondensed",
          fontSize: 18.sp,
          color: const Color(0xff0039a3),
          fontWeight: FontWeight.bold,
        ),
        contentPadding: (suffixIcon && labelText != null)
            ? EdgeInsets.only(bottom: 15.h)
            : null,
        border: (fullBorder) ? const OutlineInputBorder() : null,
        suffixIcon: (suffixIcon)
            ? InkWell(
                onTap: () {
                  var str = textEditingController.text;
                  if (str.isNotEmpty) {
                    str = str.substring(0, str.length - 1);
                    textEditingController.text = str;
                    textEditingController.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: textEditingController.text.length));
                  }
                },
                child: SvgPicture.asset(
                  'assets/icons/delete.svg',
                ),
              )
            : null,
        suffixIconColor: Colors.black,
        suffixIconConstraints:
            const BoxConstraints(minHeight: 25, minWidth: 25),
      ),
      style: TextStyle(
        fontFamily: "RobotoCondensed",
        fontSize: 16.sp,
      ),
      controller: textEditingController,
      keyboardType: keyboardType,
      maxLines: maxLine,
      obscureText: obsecureTxt,
      maxLength: maxLength,
      textAlign: (centerText) ? TextAlign.center : TextAlign.left,
      onChanged: (val) {
        if (val.length == maxLength) {
          FocusScope.of(context).unfocus();
        }
      },
      validator: (val) {
        var data = validation();
        return data;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(Regex.regexToRemoveEmoji)),
      ],
    );
  }
}
