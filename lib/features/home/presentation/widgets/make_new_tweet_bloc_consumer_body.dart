import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/pick_image_from_gallery.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/home/presentation/widgets/preview_chosen_media.dart';
import 'package:twitter_app/features/home/presentation/widgets/make_new_tweet_text_field.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_model.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/make_new_tweet_cubits/make_new_tweet_cubit.dart';
import 'package:twitter_app/features/home/presentation/widgets/custom_floating_action_button.dart';

class MakeNewTweetBlocConsumerBody extends StatefulWidget {
  const MakeNewTweetBlocConsumerBody({super.key});

  @override
  State<MakeNewTweetBlocConsumerBody> createState() =>
      _MakeNewTweetBlocConsumerBodyState();
}

class _MakeNewTweetBlocConsumerBodyState
    extends State<MakeNewTweetBlocConsumerBody> {
  final TextEditingController textTweetController = TextEditingController();
  late UserEntity userEntity;
  List<File> mediaFiles = [];
  bool _isPostButtonEnabled = false;
  bool isImageLoading = false;

  @override
  void initState() {
    super.initState();
    userEntity = getCurrentUserEntity();

    textTweetController.addListener(() {
      setState(() {
        if (textTweetController.text.trim().isNotEmpty ||
            mediaFiles.isNotEmpty) {
          _isPostButtonEnabled = true;
        } else {
          _isPostButtonEnabled = false;
        }
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
      if (mediaFiles.isEmpty && textTweetController.text.trim().isEmpty) {
        _isPostButtonEnabled = false;
      }
    });
  }

  void _onPostButtonPressed(BuildContext context) async {
    setState(() {
      _isPostButtonEnabled = false;
    });
    final content = textTweetController.text.trim();

    TweetModel tweetModel = TweetModel(
      userId: userEntity.userId,
      content: content,
      createdAt: Timestamp.now(),
    );
    BlocProvider.of<MakeNewTweetCubit>(context).makeNewTweet(
      data: tweetModel.toJson(),
      mediaFiles: mediaFiles,
    );
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
              "Cancel",
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
            "Post",
            style: AppTextStyles.uberMoveMedium18.copyWith(color: Colors.white),
          ),
        ),
        const HorizontalGap(AppConstants.horizontalPadding),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MakeNewTweetCubit, MakeNewTweetState>(
      listener: (context, state) {
        if (state is MakeNewTweetLoadedState) {
          Navigator.pop(context);
        } else if (state is MakeNewTweetFailureState) {
          showCustomSnackBar(context, state.message);
          setState(() {
            _isPostButtonEnabled = true;
          });
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state is MakeNewTweetLoadingState,
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
                    visible: state is MakeNewTweetLoadingState,
                    child: LinearProgressIndicator(
                      color: AppColors.twitterAccentColor,
                    ),
                  ),
                  const VerticalGap(6),
                  MakeNewTweetTextField(
                    userEntity: userEntity,
                    textTweetController: textTweetController,
                    hintText: "What`s happening?",
                  ),
                  const VerticalGap(28),
                  PreviewChosenMedia(
                    mediaFiles: mediaFiles,
                    onRemoveImageButtonPressed: _onRemoveImageButtonPressed,
                    isLoading: isImageLoading,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
