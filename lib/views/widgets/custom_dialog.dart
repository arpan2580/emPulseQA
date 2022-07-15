import 'package:empulse/consts/app_fonts.dart';
import 'package:flutter/material.dart';

PersistentBottomSheetController customDialog(
    BuildContext context, Function() onDelete) {
  return showBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width - 30,
          child: Column(
            children: [
              TextButton(onPressed: onDelete, child: const Text("DELETE")),
              const Divider(),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("CANCEL")),
            ],
          ),
        );
      });
}

Widget myCustomDialog(BuildContext context, Function() onDelete) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(30, 8.0, 30, 8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width - 30,
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: onDelete,
                child: const Text(
                  "DELETE",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: AppFonts.fontSize,
                    fontFamily: AppFonts.appFont,
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            indent: 50,
            endIndent: 50,
          ),
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "CANCEL",
                  style: TextStyle(
                    fontSize: AppFonts.fontSize,
                    fontFamily: AppFonts.appFont,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
