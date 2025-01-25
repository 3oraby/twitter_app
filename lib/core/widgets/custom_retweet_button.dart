import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/tweet/data/models/retweet_model.dart';
import 'package:twitter_app/features/tweet/domain/repos/retweet_repo.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/toggle_retweet_cubit/toggle_retweet_cubit.dart';

class CustomRetweetButton extends StatelessWidget {
  const CustomRetweetButton({
    super.key,
    required this.tweetId,
    required this.originalAuthorId,
    required this.retweetsCount,
    this.isActive = false,
  });

  final String tweetId;
  final String originalAuthorId;
  final int retweetsCount;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleRetweetCubit(
        retweetRepo: getIt<RetweetRepo>(),
      ),
      child: RetweetButtonBlocConsumerBody(
        tweetId: tweetId,
        originalAuthorId: originalAuthorId,
        retweetsCount: retweetsCount,
        isActive: isActive,
      ),
    );
  }
}

class RetweetButtonBlocConsumerBody extends StatefulWidget {
  const RetweetButtonBlocConsumerBody({
    super.key,
    required this.tweetId,
    required this.originalAuthorId,
    required this.retweetsCount,
    this.isActive = false,
  });
  final String tweetId;
  final String originalAuthorId;
  final int retweetsCount;
  final bool isActive;

  @override
  State<RetweetButtonBlocConsumerBody> createState() =>
      _RetweetButtonBlocConsumerBodyState();
}

class _RetweetButtonBlocConsumerBodyState
    extends State<RetweetButtonBlocConsumerBody> {
  late bool isActive;
  late int retweetsCount;
  late int amount;
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
    isActive = widget.isActive;
    retweetsCount = widget.retweetsCount;
    if (isActive) {
      amount = -1;
    } else {
      amount = 1;
    }
  }

  Future<bool?> _onToggleRetweetButtonPressed(bool isRetweeted) async {
    BlocProvider.of<ToggleRetweetCubit>(context).toggleRetweet(
      data: RetweetModel(
        tweetId: widget.tweetId,
        userId: currentUser.userId,
        originalAuthorId: widget.originalAuthorId,
        retweetedAt: Timestamp.now(),
      ).toJson(),
    );
    setState(() {
      isActive = !isRetweeted;
      retweetsCount += amount;
      amount *= -1;
    });
    return !isRetweeted;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToggleRetweetCubit, ToggleRetweetState>(
        listener: (context, state) {
      if (state is ToggleRetweetFailureState) {
        showCustomSnackBar(context, state.message);
        setState(() {
          isActive = !isActive;
        });
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
          style: AppTextStyles.uberMoveMedium18.copyWith(
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
