import 'package:empulse/controllers/notification_controller.dart';
import 'package:empulse/custom_icons_icons.dart';
import 'package:empulse/views/widgets/custom_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

import '../../controllers/dark_theme_controller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var notificationController = Get.put(NotificationController());
  final scrollController = ScrollController();
  bool noItem = false;

  @override
  void initState() {
    super.initState();
    notificationController.fetchNotification();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (notificationController.nextPageUrl != null) {
          notificationController.fetchMore(notificationController.nextPageUrl);
        } else {
          setState(() {
            noItem = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final storedToken = GetStorage();
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          // MyNotificationBtn(),
          PopupMenuButton(
              color: Theme.of(context).scaffoldBackgroundColor,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: TextButton.icon(
                      onPressed: () {
                        notificationController.readAllNotifications();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.done_all_rounded,
                        color: DarkThemeController.isDarkThemeEnabled.value
                            ? Theme.of(context).primaryColor.withOpacity(0.7)
                            : Colors.deepPurple,
                      ),
                      label: Text(
                        'Mark all as read',
                        style: TextStyle(
                          color: DarkThemeController.isDarkThemeEnabled.value
                              ? Theme.of(context).primaryColor.withOpacity(0.7)
                              : Colors.deepPurple,
                        ),
                      ),
                    ),
                    onTap: () {
                      notificationController.readAllNotifications();
                      setState(() {});
                    },
                  ),
                  PopupMenuItem(
                    child: TextButton.icon(
                      onPressed: () {
                        notificationController.deleteAllNotifications();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Delete all',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    onTap: () {
                      notificationController.deleteAllNotifications();
                      setState(() {});
                    },
                  ),
                ];
              }),
        ],
      ),
      body: Obx(
        () => notificationController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : notificationController.notificationList.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: Get.height,
                          child: ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount:
                                notificationController.notificationList.length +
                                    1,
                            itemBuilder: (context, index) {
                              if (index <
                                  notificationController
                                      .notificationList.length) {
                                return Slidable(
                                  startActionPane: (notificationController
                                              .notificationList[index].status ==
                                          "0")
                                      ? ActionPane(
                                          motion: const DrawerMotion(),
                                          extentRatio: 0.2,
                                          children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  notificationController
                                                      .readNotification(
                                                          notificationController
                                                              .notificationList[
                                                                  index]
                                                              .notificationId);
                                                  setState(() {});
                                                },
                                                backgroundColor:
                                                    const Color(0xFF0080ff),
                                                icon: Icons
                                                    .mark_chat_read_rounded,
                                              ),
                                            ])
                                      : null,
                                  endActionPane: ActionPane(
                                      extentRatio: 0.2,
                                      motion: const DrawerMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            notificationController
                                                .deleteNotification(
                                                    notificationController
                                                        .notificationList[index]
                                                        .notificationId,
                                                    notificationController
                                                        .notificationList[index]
                                                        .status);
                                            setState(() {});
                                          },
                                          backgroundColor:
                                              const Color(0xFFff0062),
                                          icon: CustomIcons.delete_icon,
                                        ),
                                      ]),
                                  child: CustomNotification(
                                    index: index,
                                    notification:
                                        notificationController.notificationList,
                                  ),
                                );
                              } else {
                                if (noItem ||
                                    notificationController.nextPageUrl ==
                                        null) {
                                  return Container();
                                } else {
                                  return const Padding(
                                    padding:
                                        EdgeInsets.only(top: 25, bottom: 45.0),
                                    child: Center(
                                        child: CircularProgressIndicator
                                            .adaptive()),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      'No Notification found',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
      ),
    );
  }
}
