
import 'package:empulse/consts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final GlobalKey<FormState>? _formKey;
  final String btnText;
  final void Function() action;
  const CustomButton({
    Key? key,
    formKey,
    required this.btnText,
    required this.action,
  })  : _formKey = formKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        if (_formKey!.currentState!.validate()) {
          _formKey!.currentState!.save();
          action();
        }
      },
      child: Text(
        btnText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppFonts.regularFont,
          fontSize: 14.sp,
          color: const Color(0xffffffff),
          fontWeight: FontWeight.bold,
        ),
      ),
      color: const Color(0xff347cff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
