import 'package:flutter/material.dart';
import 'package:wallverse/utils/helper.dart';
import 'package:wallverse/viewModels/notification_view_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() {
    return _NotificationScreen();
  }
}

class _NotificationScreen extends State<NotificationScreen> {
  final notificationViewModel = NotificationViewModel();
  final helper = Helper();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    notificationViewModel.addListener(notificationListener);
    getNotifications();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.7) {
        notificationViewModel.loadMoreNotifications();
      }
    });
  }

  void getNotifications() async {
    await notificationViewModel.getNotifications();
  }

  void notificationListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    notificationViewModel.removeListener(notificationListener);
    notificationViewModel.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF080808),
        elevation: 0,
      ),

      body: notificationViewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFA855F7)),
            )
          : ListView.builder(
              controller: scrollController,
              itemCount: notificationViewModel.notificationList.length,
              itemBuilder: (context, index) {
                final notification =
                    notificationViewModel.notificationList[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFF27272A),
                        child: Text(
                          notification.userName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: notification.userName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: " liked your wallpaper",
                                    style: TextStyle(color: Color(0xFFD4D4D8)),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              helper.getTimeAgo(notification.created_at),
                              style: const TextStyle(
                                color: Color(0xFF71717A),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          notification.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
