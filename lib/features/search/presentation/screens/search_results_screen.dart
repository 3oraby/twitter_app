import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/widgets/custom_tab_bar.dart';
import 'package:twitter_app/core/widgets/keep_alive_tab.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/search/presentation/widgets/custom_search_text_field.dart';
import 'package:twitter_app/features/search/presentation/widgets/show_users_search_result_view.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_show_tweet_feed.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({
    super.key,
    required this.query,
  });

  static const String routeId = 'kSearchResultsScreen';
  final String query;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late UserEntity currentUser;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
    textController.text = widget.query;
    textController.addListener(
      () {
        log("change in text field text: ${textController.text}");
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
            vertical: AppConstants.topPadding,
          ),
          child: Column(
            spacing: 4,
            children: [
              buildCustomAppBar(
                context,
                title: CustomSearchTextField(
                  textController: textController,
                  hintText: widget.query,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const CustomTabBar(
                tabs: [
                  Tab(text: "People"),
                  Tab(text: "Tweets"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    KeepAliveTab(
                        child: ShowUsersSearchResultView(query: widget.query)),
                    KeepAliveTab(
                      child: CustomShowTweetFeed(
                        query: widget.query,
                        mainLabelEmptyBody: "No Results Found",
                        subLabelEmptyBody: "Try searching for something else!",
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
