import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/pick_image_from_gallery.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/home/presentation/widgets/preview_chosen_media.dart';
import 'package:twitter_app/features/home/presentation/widgets/make_new_tweet_text_field.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_details_model.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_model.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/make_new_tweet_cubits/make_new_tweet_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/update_tweet_cubit/update_tweet_cubit.dart';
import 'package:twitter_app/features/home/presentation/widgets/custom_floating_action_button.dart';

class CreateOrUpdateTweetBlocConsumerBody extends StatefulWidget {
  const CreateOrUpdateTweetBlocConsumerBody({super.key, this.tweetDetails});

  final TweetDetailsEntity? tweetDetails;

  @override
  State<CreateOrUpdateTweetBlocConsumerBody> createState() =>
      _CreateOrUpdateTweetBlocConsumerBodyState();
}

class _CreateOrUpdateTweetBlocConsumerBodyState
    extends State<CreateOrUpdateTweetBlocConsumerBody> {
  final TextEditingController textTweetController = TextEditingController();
  late UserEntity userEntity;
  List<File> mediaFiles = [];
  List<String> removedMediaUrls = [];
  List<File> constantMediaUrl = [];
  List<String>? networkMediaUrls;
  bool _isPostButtonEnabled = false;
  bool isImageLoading = false;

  @override
  void initState() {
    super.initState();
    userEntity = getCurrentUserEntity();

    if (widget.tweetDetails != null) {
      textTweetController.text = widget.tweetDetails!.tweet.content ?? '';
      networkMediaUrls =
          List.from(widget.tweetDetails!.tweet.mediaUrl as Iterable<dynamic>);
    }

    textTweetController.addListener(() {
      setState(() {
        _isPostButtonEnabled =
            textTweetController.text.trim().isNotEmpty || mediaFiles.isNotEmpty;
      });
    });
  }

  Future<void> _onAddImagePressed() async {
    try {
      setState(() {
        isImageLoading = true;
      });
      XFile? image = await pickImageFromGallery();
      if (image != null) {
        setState(() {
          mediaFiles.add(File(image.path));
          _isPostButtonEnabled = true;
        });
      }
    } catch (e) {
      log("Image picking error: $e");
    } finally {
      setState(() {
        isImageLoading = false;
      });
    }
  }

  void _onRemoveImageButtonPressed(int index) {
    setState(() {
      mediaFiles.removeAt(index);
      _isPostButtonEnabled =
          textTweetController.text.trim().isNotEmpty || mediaFiles.isNotEmpty;
    });
  }

  void _onRemoveNetworkImageUrlPressed(int index) {
    setState(() {
      removedMediaUrls.add(networkMediaUrls![index]);
      networkMediaUrls!.removeAt(index);
      _isPostButtonEnabled = textTweetController.text.trim().isNotEmpty ||
          networkMediaUrls!.isNotEmpty;
    });
  }

  void _onPostButtonPressed(BuildContext context) async {
    setState(() {
      _isPostButtonEnabled = false;
    });
    final content = textTweetController.text.trim();

    if (widget.tweetDetails == null) {
      TweetModel tweetModel = TweetModel(
        userId: userEntity.userId,
        content: content,
        createdAt: Timestamp.now(),
      );
      BlocProvider.of<MakeNewTweetCubit>(context).makeNewTweet(
        data: tweetModel.toJson(),
        mediaFiles: mediaFiles,
      );
    } else {
      TweetModel newTweetModel = TweetModel(
        userId: userEntity.userId,
        content: content,
        createdAt: widget.tweetDetails!.tweet.createdAt,
        updatedAt: Timestamp.now(),
      );

      TweetDetailsModel newTweetDetails = TweetDetailsModel(
        tweetId: widget.tweetDetails!.tweetId,
        tweet: newTweetModel.toEntity(),
        user: widget.tweetDetails!.user,
        isLiked: widget.tweetDetails!.isLiked,
        isBookmarked: widget.tweetDetails!.isBookmarked,
        isRetweeted: widget.tweetDetails!.isRetweeted,
      );
      BlocProvider.of<UpdateTweetCubit>(context).updateTweet(
        tweetId: widget.tweetDetails!.tweetId,
        data: newTweetDetails.toJson(),
        mediaFiles: mediaFiles,
        constantMediaUrls: networkMediaUrls,
        removedMediaUrls: removedMediaUrls,
      );
    }
  }

  @override
  void dispose() {
    textTweetController.dispose();
    super.dispose();
  }

  AppBar _buildAppBar(BuildContext context) {
    return buildCustomAppBar(
      context,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Row(
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              context.tr("Cancel"),
              style: AppTextStyles.uberMoveMedium20,
            ),
          ),
        ],
      ),
      actions: [
        CustomContainerButton(
          internalVerticalPadding: 4,
          backgroundColor: _isPostButtonEnabled
              ? AppColors.twitterAccentColor
              : AppColors.lightTwitterAccentColor,
          onPressed:
              _isPostButtonEnabled ? () => _onPostButtonPressed(context) : null,
          child: Text(
            widget.tweetDetails == null
                ? context.tr("post_verb")
                : context.tr("Update"),
            style: AppTextStyles.uberMoveMedium18.copyWith(color: Colors.white),
          ),
        ),
        const HorizontalGap(AppConstants.horizontalPadding),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateTweetCubit, UpdateTweetState>(
      listener: (context, updateTweetState) {
        if (updateTweetState is UpdateTweetLoadedState ||
            updateTweetState is UpdateTweetFailureState) {
          Navigator.pop(context);
        }
      },
      builder: (context, updateTweetState) {
        return BlocConsumer<MakeNewTweetCubit, MakeNewTweetState>(
          listener: (context, makeTweetState) {
            if (makeTweetState is MakeNewTweetLoadedState ||
                makeTweetState is MakeNewTweetFailureState) {
              Navigator.pop(context);
            }
          },
          builder: (context, makeTweetState) {
            return AbsorbPointer(
              absorbing: makeTweetState is MakeNewTweetLoadingState,
              child: Scaffold(
                appBar: _buildAppBar(context),
                floatingActionButton: CustomFloatingActionButton(
                  iconData: Icons.add_a_photo,
                  onPressed: _onAddImagePressed,
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalPadding),
                  child: ListView(
                    children: [
                      Visibility(
                        visible: makeTweetState is MakeNewTweetLoadingState ||
                            updateTweetState is UpdateTweetLoadingState,
                        child: LinearProgressIndicator(
                          color: AppColors.twitterAccentColor,
                        ),
                      ),
                      const VerticalGap(6),
                      MakeNewTweetTextField(
                        userEntity: userEntity,
                        textTweetController: textTweetController,
                        hintText: context.tr("What`s happening?"),
                      ),
                      const VerticalGap(28),
                      PreviewChosenMedia(
                        mediaFiles: mediaFiles,
                        onRemoveImageButtonPressed: _onRemoveImageButtonPressed,
                        onRemoveNetworkImageUrlPressed:
                            _onRemoveNetworkImageUrlPressed,
                        isLoading: isImageLoading,
                        networkMediaUrls: networkMediaUrls,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
