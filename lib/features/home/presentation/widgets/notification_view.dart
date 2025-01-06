import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({
    super.key,
  });
  AppBar buildNotificationsAppBar({
    required BuildContext context,
  }) {
    return buildCustomAppBar(
      context,
      title: const Text("Notifications"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildNotificationsAppBar(context: context),
        Container(
            color: Colors.blue, child: const Center(child: Text('Page 3'))),
      ],
    );
  }
}
