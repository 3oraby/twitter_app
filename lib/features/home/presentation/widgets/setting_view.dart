import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';

class SettingView extends StatelessWidget {
  const SettingView({
    super.key,
  });
  AppBar buildSettingsAppBar({
    required BuildContext context,
  }) {
    return buildCustomAppBar(
      context,
      title: const Text("Settings"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSettingsAppBar(context: context),
        Expanded(
          child: Container(
              color: Colors.blue, child: const Center(child: Text('Page 4'))),
        ),
      ],
    );
  }
}
