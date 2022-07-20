import 'dart:async';

import 'package:empulse/controllers/dark_theme_controller.dart';
import 'package:empulse/services/notification_service.dart';
import 'package:empulse/views/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'controllers/base_controller.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  // print(message.data.toString());
  // print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  NotificationService().initialize();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (_) => runApp(const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    NotificationService.requestPermission();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final storageCount = GetStorage();
    super.didChangeAppLifecycleState(state);
    final isBackground = state == AppLifecycleState.paused;
    final isResumed = state == AppLifecycleState.resumed;
    final isClosed = state == AppLifecycleState.detached;
    if (isBackground || isClosed) {
      print("resumed");
    }
    if (isResumed) {
      print("resumed");
      // if (mounted) {
      setState(() {
        BaseController.unreadNotification.value =
            storageCount.read('unreadNotification');
      });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (child, context) => GetMaterialApp(
        title: 'empulse',
        debugShowCheckedModeBanner: false,
        theme: DarkThemeController().isDarkThemeEnabled.value
            ? ThemeData.dark()
            : ThemeData.light(),
        home: const SplashPage(),
      ),
      designSize: const Size(418, 881),
    );
  }
}
