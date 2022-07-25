import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget feedbackInfo(context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Field Info",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const Divider(
          indent: 20,
          endIndent: 20,
        ),
        Table(
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: fieldValue("Outlet Name"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: fieldDesc("Enter the Name of the Outlet"),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: fieldValue("Market Name"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: fieldDesc("Enter the Name of the Outlet"),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: fieldValue("Trade Type"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: fieldDesc("Enter the Name of the Outlet"),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: fieldValue("Feedback Type"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: fieldDesc("Enter the Name of the Outlet"),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: fieldValue("Company Type"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: fieldDesc("Enter the Name of the Outlet"),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: fieldValue("Search Product"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: fieldDesc("Enter the Name of the Outlet"),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: fieldValue("Genre of Feedback"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: fieldDesc("Enter the Name of the Outlet"),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: fieldValue("Feedback"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child:
                      fieldDesc("Enter the feedback for the product selected"),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget fieldValue(String? value) {
  return Text(
    value!,
    style: TextStyle(
      color: Colors.grey,
      fontSize: 16.sp,
    ),
  );
}

Widget fieldDesc(String? value) {
  return Text(
    value!,
    style: TextStyle(
      color: Colors.grey,
      fontSize: 16.sp,
    ),
  );
}
