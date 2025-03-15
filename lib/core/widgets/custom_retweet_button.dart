import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/tweet/data/models/retweet_model.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/tweet/domain/repos/retweet_repo.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/toggle_retweet_cubit/toggle_retweet_cubit.dart';

class CustomRetweetButton extends StatelessWidget {
  const CustomRetweetButton({
    super.key,
    required this.currentUser,
    required this.tweetDetailsEntity,
    this.isActive = false,
  });

  final TweetDetailsEntity tweetDetailsEntity;
  final UserEntity currentUser;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleRetweetCubit(
        retweetRepo: getIt<RetweetRepo>(),
      ),
      child: RetweetButtonBlocConsumerBody(
        tweetDetailsEntity: tweetDetailsEntity,
        currentUser: currentUser,
        isActive: isActive,
      ),
    );
  }
}

class RetweetButtonBlocConsumerBody extends StatefulWidget {
  const RetweetButtonBlocConsumerBody({
    super.key,
    required this.currentUser,
    required this.tweetDetailsEntity,
    this.isActive = false,
  });
  final bool isActive;
  final TweetDetailsEntity tweetDetailsEntity;
  final UserEntity currentUser;

  @override
  State<RetweetButtonBlocConsumerBody> createState() =>
      _RetweetButtonBlocConsumerBodyState();
}

class _RetweetButtonBlocConsumerBodyState
    extends State<RetweetButtonBlocConsumerBody> {
  late bool isActive;
  late int retweetsCount;
  late int amount;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
    retweetsCount = widget.tweetDetailsEntity.tweet.retweetsCount;
    if (isActive) {
      amount = -1;
    } else {
      amount = 1;
    }
  }

  void updateTweetDetailsEntity() {
    if (isActive) {
      widget.tweetDetailsEntity.makeRetweet();
    } else {
      widget.tweetDetailsEntity.removeRetweet();
    }
  }

  Future<bool?> _onToggleRetweetButtonPressed(bool isRetweeted) async {
    BlocProvider.of<ToggleRetweetCubit>(context).toggleRetweet(
      data: RetweetModel(
        tweetId: widget.tweetDetailsEntity.tweetId,
        userId: widget.currentUser.userId,
        originalAuthorId: widget.tweetDetailsEntity.tweet.userId,
        retweetedAt: Timestamp.now(),
      ).toJson(),
    );
    setState(() {
      isActive = !isRetweeted;
      retweetsCount += amount;
      amount *= -1;
    });
    updateTweetDetailsEntity();
    return !isRetweeted;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToggleRetweetCubit, ToggleRetweetState>(
        listener: (context, state) {
      if (state is ToggleRetweetFailureState) {
        showCustomSnackBar(context, context.tr(state.message));
        setState(() {
          isActive = !isActive;
          retweetsCount += amount;
          amount *= -1;
        });
        updateTweetDetailsEntity();
      }
    }, builder: (context, state) {
      return LikeButton(
        isLiked: isActive,
        onTap: _onToggleRetweetButtonPressed,
        likeCount: retweetsCount,
        bubblesColor: BubblesColor(
          dotPrimaryColor: Colors.green,
          dotSecondaryColor: Colors.lightGreen,
        ),
        countBuilder: (likeCount, isLiked, text) => Text(
          likeCount.toString(),
          style: AppTextStyles.uberMoveMedium(context,18).copyWith(
            color: isLiked ? Colors.green : AppColors.thirdColor,
          ),
        ),
        likeBuilder: (isLiked) {
          return Icon(
            FontAwesomeIcons.repeat,
            color: isLiked ? Colors.green : AppColors.thirdColor,
          );
        },
      );
    });
  }
}
