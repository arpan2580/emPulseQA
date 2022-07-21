import 'dart:async';

import 'package:empulse/consts/app_fonts.dart';
import 'package:empulse/controllers/base_controller.dart';
import 'package:empulse/services/notification_service.dart';
import 'package:empulse/views/pages/bottom_nav_bar.dart';
import 'package:empulse/views/pages/feedback_comments.dart';
import 'package:empulse/views/pages/login_page.dart';
import 'package:empulse/views/pages/notification_page.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uni_links/uni_links.dart';

import '../../controllers/notification_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Widget _defaultHome = const LoginPage();
  final isLoggedIn = GetStorage();

  StreamSubscription? _sub;
  bool openFromLink = false;

  @override
  void initState() {
    super.initState();

    // This method will be called when App is in terminated state
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          if (message.notification != null) {
            if (message.data['feedback_id'] != '' ||
                message.data['notification_id'] != '') {
              var id = message.data['feedback_id'];
              var notificationId = message.data['notification_id'];
              message.data['feedback_id'] = '';
              message.data['notification_id'] = '';
              NotificationController().readNotification(notificationId);
              Get.to(() => FeedbackComment(
                    feedbackId: id.toString(),
                    isClose: false,
                  ));
            } else {
              Get.to(
                () => const NotificationPage(),
              );
            }
          }
        }
      },
    );

    // This method method will be called when App is in open state
    FirebaseMessaging.onMessage.listen(
      (message) {
        final storageCount = GetStorage();
        var notCount = storageCount.read('unreadNotification');
        if (notCount != null) {
          storageCount.write("unreadNotification", notCount + 1);
          BaseController.unreadNotification.value =
              storageCount.read('unreadNotification');
        }
        if (message.notification != null) {
          NotificationService.showNotification(message);
          BaseController.commentReload.value = true;
        }
      },
    );

    // This method method will be called when App is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        final storageCount = GetStorage();
        var notCount = storageCount.read('unreadNotification');
        if (notCount != null) {
          storageCount.write("unreadNotification", notCount + 1);
          BaseController.unreadNotification.value =
              storageCount.read('unreadNotification');
        }
        if (message.notification != null) {
          if (message.data['feedback_id'] != '' ||
              message.data['notification_id'] != '') {
            var id = message.data['feedback_id'];
            var notificationId = message.data['notification_id'];
            message.data['feedback_id'] = '';
            message.data['notification_id'] = '';
            NotificationController().readNotification(notificationId);
            Get.to(() => FeedbackComment(
                  feedbackId: id.toString(),
                  isClose: false,
                ));
          } else {
            Get.to(
              () => const NotificationPage(),
            );
          }
        }
      },
    );

    if (isLoggedIn.read("refreshToken") != null) {
      BaseController().fetchGlobalData().then((value) {
        initUniLinks();
        if (mounted) {
          setState(() {
            _defaultHome = const BottomNavBar(index: 0);
          });
          Get.offAll(
            () => FeatureDiscovery(
              recordStepsInSharedPreferences: false,
              child: _defaultHome,
            ),
          );
        }
      });
    } else {
      Get.offAll(
        () => FeatureDiscovery(
          recordStepsInSharedPreferences: false,
          child: _defaultHome,
        ),
      );
    }
  }

  Future<void> initUniLinks() async {
    dynamic uri;
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        uri = Uri.parse(initialLink);
      }
      // else {
      _sub = linkStream.listen((String? link) {
        if (link != null) {
          uri = Uri.parse(link);
        }
      }, onError: (err) {});
      // }
      setState(() {
        openFromLink = true;
      });
      if (uri != null) {
        print(uri.pathSegments.last.toString());
        Get.to(() => FeedbackComment(
              feedbackId: uri.pathSegments.last.toString(),
              isClose: false,
            ));
      }
    } on PlatformException catch (e) {
      print("platform exception: $e");
    } on MissingPluginException catch (e) {
      print("plugin exception: $e");
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_background.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmpulseLogo extends StatelessWidget {
  final double width;
  const EmpulseLogo({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image(
            image: const AssetImage("assets/images/Logo_empulse.png"),
            width: width,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 60.0),
            child: Text(
              "Employee Feedback Application",
              style: TextStyle(
                fontFamily: AppFonts.lightFont,
                fontStyle: FontStyle.italic,
                fontSize: 12,
                color: Color(0xff000000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
