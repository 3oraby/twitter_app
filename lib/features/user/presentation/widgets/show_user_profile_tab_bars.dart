import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/widgets/custom_tab_bar.dart';

class ShowUserProfileTabBars extends StatelessWidget {
  const ShowUserProfileTabBars({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelPadding: const EdgeInsets.symmetric(horizontal: 30),
      tabs: [
        Tab(text: context.tr("Posts")),
        Tab(text: context.tr("Media")),
        Tab(text: context.tr("Likes")),
        Tab(text: context.tr("Retweets")),
      ],
    );
  }
}
