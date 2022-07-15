import 'package:app_settings/app_settings.dart';
import 'package:empulse/consts/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationMadatoryNeeded extends StatefulWidget {
  const LocationMadatoryNeeded({Key? key}) : super(key: key);

  @override
  State<LocationMadatoryNeeded> createState() => _LocationMadatoryNeededState();
}

class _LocationMadatoryNeededState extends State<LocationMadatoryNeeded>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Image(
                image: AssetImage("assets/images/location_not_given.jpg"),
              ),
              Text(
                "Location Permission is required to Add Feedback.\n Click on \"Allow\" to provide location access",
                style: TextStyle(
                  fontFamily: AppFonts.regularFont,
                  fontSize: 18.sp,
                  // fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                "Click on Allow Button > Permissions > Allow",
                style: TextStyle(
                  fontFamily: AppFonts.regularFont,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  onPressed: () async {
                    AppSettings.openAppSettings();
                    // print("Working");
                  },
                  child: Text(
                    "Allow Location Permission",
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 20.sp,
                    ),
                  ),
                  color: Colors.black,
                  minWidth: MediaQuery.of(context).size.width,
                  height: 60.h,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
