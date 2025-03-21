import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/widgets/custom_like_button_body.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_likes_model.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_likes_repo.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/toggle_tweet_like_cubit/toggle_tweet_like_cubit.dart';

class CustomTweetLikeButton extends StatelessWidget {
  const CustomTweetLikeButton({
    super.key,
    required this.currentUser,
    required this.tweetDetailsEntity,
    this.isActive = false,
  });

  final bool isActive;
  final UserEntity currentUser;
  final TweetDetailsEntity tweetDetailsEntity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleTweetLikeCubit(
        tweetLikesRepo: getIt<TweetLikesRepo>(),
      ),
      child: TweetLikeButtonBlocConsumerBody(
        tweetDetailsEntity: tweetDetailsEntity,
        currentUser: currentUser,
        isActive: isActive,
      ),
    );
  }
}

class TweetLikeButtonBlocConsumerBody extends StatefulWidget {
  const TweetLikeButtonBlocConsumerBody({
    super.key,
    required this.currentUser,
    required this.tweetDetailsEntity,
    this.isActive = false,
  });
  final bool isActive;
  final UserEntity currentUser;
  final TweetDetailsEntity tweetDetailsEntity;
  @override
  State<TweetLikeButtonBlocConsumerBody> createState() =>
      _TweetLikeButtonBlocConsumerBodyState();
}

class _TweetLikeButtonBlocConsumerBodyState
    extends State<TweetLikeButtonBlocConsumerBody> {
  late bool isActive;
  late int likesCount;
  late int amount;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
    likesCount = widget.tweetDetailsEntity.tweet.likesCount;
    if (isActive) {
      amount = -1;
    } else {
      amount = 1;
    }
  }

  void updateTweetDetailsEntity() {
    if (isActive) {
      widget.tweetDetailsEntity.addLike();
    } else {
      widget.tweetDetailsEntity.removeLike();
    }
  }

  Future<bool?> _onToggleLikeButtonPressed(bool isLiked) async {
    BlocProvider.of<ToggleTweetLikeCubit>(context).toggleTweetLike(
      data: TweetLikesModel(
        tweetId: widget.tweetDetailsEntity.tweetId,
        userId: widget.currentUser.userId,
        originalAuthorId: widget.tweetDetailsEntity.tweet.userId,
        likedAt: Timestamp.now(),
      ).toJson(),
    );
    setState(() {
      isActive = !isLiked;
      likesCount += amount;
      amount *= -1;
    });
    updateTweetDetailsEntity();
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToggleTweetLikeCubit, ToggleTweetLikeState>(
      listener: (context, state) {
        if (state is ToggleTweetLikeFailureState) {
          showCustomSnackBar(context, context.tr(state.message));
          setState(() {
            isActive = !isActive;
            likesCount += amount;
            amount *= -1;
          });
          updateTweetDetailsEntity();
        }
      },
      builder: (context, state) {
        return CustomLikeButtonBody(
          isActive: isActive,
          likesCount: likesCount,
          onToggleLikeButtonPressed: _onToggleLikeButtonPressed,
        );
      },
    );
  }
}
