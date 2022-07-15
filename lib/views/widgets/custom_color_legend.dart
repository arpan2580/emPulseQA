import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/views/widgets/my_like_list.dart';
import 'package:flutter/material.dart';

class ColorLegendDialog extends StatelessWidget {
  const ColorLegendDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      contentPadding:
          const EdgeInsets.only(top: 18, bottom: 0, left: 20, right: 8),
      // title: const Text("Feedback Status"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Actionable Post Status",
              style: TextStyle(
                fontFamily: AppFonts.regularFont,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Row(
          //   children: const [
          //     CustomStatus(
          //       color: Color(0xff1f9aff),
          //       svgIcon: "PixleIcon.svg",
          //       isObservation: false,
          //     ),
          //     SizedBox(width: 10),
          //     Text(
          //       "Assignment in progress",
          //       style: TextStyle(
          //         fontFamily: AppFonts.regularFont,
          //         fontSize: 16,
          //         fontStyle: FontStyle.italic,
          //       ),
          //     )
          //   ],
          // ),
          // const SizedBox(height: 10),
          Row(
            children: const [
              CustomStatus(
                color: Color(0xffffa200),
                svgIcon: "MaterialIcon.svg",
                isObservation: false,
              ),
              SizedBox(width: 10),
              Text(
                "Action in progress",
                style: TextStyle(
                  fontFamily: AppFonts.regularFont,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              CustomStatus(
                color: Color(0xff00ab06),
                svgIcon: "Icon.svg",
                isObservation: false,
              ),
              SizedBox(width: 10),
              Text(
                "Closed",
                style: TextStyle(
                  fontFamily: AppFonts.regularFont,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            thickness: 1.5,
            // color: Colors.black,
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Observation Post Status",
              style: TextStyle(
                fontFamily: AppFonts.regularFont,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              CustomStatus(
                color: Color(0xffa300a3),
                svgIcon: "observation.svg",
                isObservation: true,
              ),
              SizedBox(width: 10),
              Text(
                "Observation post",
                style: TextStyle(
                  fontFamily: AppFonts.regularFont,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Got It"),
        ),
      ],
    );
  }
}
