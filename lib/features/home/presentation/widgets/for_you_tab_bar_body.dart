import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_empty_body_widget.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/home/presentation/screens/create_or_update_tweet_screen.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/delete_tweet_cubit/delete_tweet_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/get_tweets_cubit/get_tweets_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/update_tweet_cubit/update_tweet_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_tweet_info_card.dart';
import 'package:twitter_app/features/comments/presentation/screens/show_tweet_comments_screen.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class ForYouTabBarBody extends StatefulWidget {
  const ForYouTabBarBody({
    super.key,
    required this.tweets,
    required this.currentUser,
  });

  final List<TweetDetailsEntity> tweets;
  final UserEntity currentUser;

  @override
  State<ForYouTabBarBody> createState() => _ForYouTabBarBodyState();
}

class _ForYouTabBarBodyState extends State<ForYouTabBarBody> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int? removedTweetIndex;
  int? updatedTweetIndex;
  TweetDetailsEntity? removedTweet;
  void _refreshPage() {
    BlocProvider.of<GetTweetsCubit>(context).getTweets();
  }

  void _removeTweet(int index) {
    removedTweet = widget.tweets[index];

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: CustomTweetInfoCard(
          tweetDetailsEntity: removedTweet!,
          currentUser: widget.currentUser,
        ),
      ),
      duration: const Duration(milliseconds: 400),
    );
    BlocProvider.of<DeleteTweetCubit>(context).deleteTweet(
      tweetId: removedTweet!.tweetId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteTweetCubit, DeleteTweetState>(
          listener: (context, state) {
            if (state is DeleteTweetFailureState) {
              showCustomSnackBar(context, context.tr(state.message));
            } else if (state is DeleteTweetLoadedState) {
              if (removedTweetIndex != null) {
                setState(() {
                  widget.tweets.removeAt(removedTweetIndex!);
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
                widget.tweets[updatedTweetIndex!] =
                    state.updatedTweetDetailsEntity;
              });
            }
          },
        ),
      ],
      child: widget.tweets.isEmpty
          ? Center(
              child: CustomEmptyBodyWidget(
                mainLabel: context.tr("No tweets available"),
                subLabel: context.tr("Follow more users to see tweets here"),
              ),
            )
          : AnimatedList(
              key: _listKey,
              initialItemCount: widget.tweets.length,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: Column(
                    key: ValueKey(widget.tweets[index].tweetId),
                    children: [
                      if (index == 0) const VerticalGap(16),
                      CustomTweetInfoCard(
                        tweetDetailsEntity: widget.tweets[index],
                        currentUser: widget.currentUser,
                        onDeleteTweetTap: () {
                          log("delete the tweet at index $index");
                          removedTweetIndex = index;
                          _removeTweet(index);
                        },
                        onEditTweetTap: () {
                          log('User selected: update tweet');
                          Navigator.pushNamed(
                            context,
                            CreateOrUpdateTweetScreen.routeId,
                            arguments: widget.tweets[index],
                          );
                          updatedTweetIndex = index;
                        },
                        onTweetTap: () {
                          Navigator.pushNamed(
                            context,
                            ShowTweetCommentsScreen.routeId,
                            arguments: widget.tweets[index],
                          ).then((value) {
                            _refreshPage();
                          });
                        },
                      ),
                      if (index != widget.tweets.length - 1)
                        const Divider(
                          color: AppColors.dividerColor,
                          height: 36,
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
