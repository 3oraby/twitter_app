import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/widgets/custom_empty_body_widget.dart';

class ShowTweetsFeedEmptyBody extends StatelessWidget {
  const ShowTweetsFeedEmptyBody({
    super.key,
    required this.mainLabelEmptyBody,
    required this.subLabelEmptyBody,
    required this.onRefreshPage,
  });

  final String mainLabelEmptyBody;
  final String subLabelEmptyBody;
  final VoidCallback onRefreshPage;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefreshPage();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          CustomEmptyBodyWidget(
            mainLabel: context.tr(mainLabelEmptyBody),
            subLabel: context.tr(subLabelEmptyBody),
          ),
        ],
      ),
    );
  }
}
