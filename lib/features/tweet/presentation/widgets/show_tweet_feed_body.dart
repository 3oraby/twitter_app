import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_scroll_bar.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/home/presentation/screens/create_or_update_tweet_screen.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/delete_tweet_cubit/delete_tweet_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/make_new_tweet_cubits/make_new_tweet_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/update_tweet_cubit/update_tweet_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_tweet_info_card.dart';
import 'package:twitter_app/features/comments/presentation/screens/show_tweet_comments_screen.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/show_tweets_feed_empty_body.dart';

class ShowTweetFeedBody extends StatefulWidget {
  const ShowTweetFeedBody({
    super.key,
    required this.tweets,
    required this.mainLabelEmptyBody,
    required this.subLabelEmptyBody,
    required this.onRefreshPage,
  });

  final List<TweetDetailsEntity> tweets;
  final String mainLabelEmptyBody;
  final String subLabelEmptyBody;
  final VoidCallback onRefreshPage;

  @override
  State<ShowTweetFeedBody> createState() => _ShowTweetFeedBodyState();
}

class _ShowTweetFeedBodyState extends State<ShowTweetFeedBody> {
  late UserEntity currentUser;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int? removedTweetIndex;
  int? updatedTweetIndex;
  TweetDetailsEntity? removedTweet;
  late List<TweetDetailsEntity> tweets;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    tweets = List.from(widget.tweets);
    currentUser = getCurrentUserEntity();
  }

  void _removeTweet(int index) {
    log("delete the tweet at index $index");
    removedTweetIndex = index;
    removedTweet = tweets[index];

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: CustomTweetInfoCard(
          tweetDetailsEntity: removedTweet!,
          currentUser: currentUser,
        ),
      ),
      duration: const Duration(milliseconds: 400),
    );
    BlocProvider.of<DeleteTweetCubit>(context).deleteTweet(
      tweetId: removedTweet!.tweetId,
      mediaFiles: removedTweet!.tweet.mediaUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MakeNewTweetCubit, MakeNewTweetState>(
          listener: (context, state) {
            if (state is MakeNewTweetLoadedState) {
              log("make new tweet");
              setState(() {
                _listKey.currentState?.insertItem(0);
                tweets.insert(0, state.tweetDetailsEntity);
              });
            }
          },
        ),
        BlocListener<DeleteTweetCubit, DeleteTweetState>(
          listener: (context, state) {
            if (state is DeleteTweetFailureState) {
              showCustomSnackBar(context, context.tr(state.message));
              if (removedTweetIndex != null && removedTweetIndex != null) {
                _listKey.currentState?.insertItem(
                  removedTweetIndex!,
                  duration: const Duration(milliseconds: 400),
                );
              }
            } else if (state is DeleteTweetLoadedState) {
              if (removedTweetIndex != null) {
                setState(() {
                  tweets.removeAt(removedTweetIndex!);
                });
              } else {
                log("can not delete the tweet");
              }
            }
          },
        ),
        BlocListener<UpdateTweetCubit, UpdateTweetState>(
          listener: (context, state) {
            if (state is UpdateTweetLoadedState) {
              log("edit the tweet");
              setState(() {
                tweets[updatedTweetIndex!] = state.updatedTweetDetailsEntity;
              });
            }
          },
        ),
      ],
      child: widget.tweets.isEmpty
          ? ShowTweetsFeedEmptyBody(
              mainLabelEmptyBody: widget.mainLabelEmptyBody,
              subLabelEmptyBody: widget.subLabelEmptyBody,
              onRefreshPage: widget.onRefreshPage,
            )
          : CustomScrollBar(
              controller: _scrollController,
              child: RefreshIndicator(
                onRefresh: () async {
                  widget.onRefreshPage();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalPadding,
                  ),
                  child: AnimatedList(
                    key: _listKey,
                    controller: _scrollController,
                    initialItemCount: tweets.length,
                    itemBuilder: (context, index, animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        child: Column(
                          key: ValueKey(tweets[index].tweetId),
                          children: [
                            if (index == 0) const VerticalGap(16),
                            CustomTweetInfoCard(
                              tweetDetailsEntity: tweets[index],
                              currentUser: currentUser,
                              onDeleteTweetTap: () {
                                _removeTweet(index);
                              },
                              onEditTweetTap: () {
                                log('User selected: update tweet');
                                Navigator.pushNamed(
                                  context,
                                  CreateOrUpdateTweetScreen.routeId,
                                  arguments: tweets[index],
                                );
                                updatedTweetIndex = index;
                              },
                              onTweetTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ShowTweetCommentsScreen.routeId,
                                  arguments: tweets[index],
                                ).then((value) {
                                  widget.onRefreshPage.call();
                                });
                              },
                            ),
                            if (index != tweets.length - 1)
                              const Divider(
                                color: AppColors.dividerColor,
                                height: 36,
                              ),
                            if (index == tweets.length - 1)
                              const VerticalGap(24)
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
