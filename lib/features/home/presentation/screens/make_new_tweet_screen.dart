import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/custom_modal_progress_hud.dart';
import 'package:twitter_app/core/widgets/custom_text_form_field.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_model.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/make_new_tweet_cubits/make_new_tweet_cubit.dart';
import 'package:twitter_app/features/home/presentation/widgets/custom_floating_action_button.dart';

class MakeNewTweetScreen extends StatefulWidget {
  const MakeNewTweetScreen({super.key});

  static const String routeId = "kMakeNewTweetScreen";

  @override
  State<MakeNewTweetScreen> createState() => _MakeNewTweetScreenState();
}

class _MakeNewTweetScreenState extends State<MakeNewTweetScreen> {
  final TextEditingController textTweetController = TextEditingController();
  // bool _isPickedImageLoading = false;
  late UserEntity userEntity;
  List<File> mediaFiles = [];
  bool _isPostButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    userEntity = getCurrentUserEntity();

    textTweetController.addListener(() {
      setState(() {
        _isPostButtonEnabled = textTweetController.text.trim().isNotEmpty;
      });
    });
  }

  Future<void> _onAddImagePressed() async {
    try {
      // setState(() {
      //   _isPickedImageLoading = true;
      // });
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          mediaFiles.add(File(image.path));
        });
      }
    } catch (e) {
      log("Image picking error: $e");
    } finally {
      // setState(() {
      //   _isPickedImageLoading = false;
      // });
    }
  }

  void _onRemoveImageButtonPressed(int index) {
    setState(() {
      mediaFiles.removeAt(index);
    });
  }

  void _onPostButtonPressed(BuildContext context) async {
    final text = textTweetController.text.trim();

    if (text.isNotEmpty || mediaFiles.isNotEmpty) {
      TweetModel tweetModel = TweetModel(
        userId: userEntity.userId,
        content: text,
        createdAt: Timestamp.now(),
      );
      BlocProvider.of<MakeNewTweetCubit>(context).makeNewTweet(
        data: tweetModel.toJson(),
        mediaFiles: mediaFiles,
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
              "Cancel",
              style: AppTextStyles.uberMoveMedium20,
            ),
          ),
        ],
      ),
      actions: [
        CustomContainerButton(
          internalVerticalPadding: 4,
          backgroundColor: textTweetController.text.trim().isNotEmpty ||
                  mediaFiles.isNotEmpty
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
    return BlocProvider(
      create: (context) => MakeNewTweetCubit(
        tweetRepo: getIt<TweetRepo>(),
      ),
      child: BlocConsumer<MakeNewTweetCubit, MakeNewTweetState>(
        listener: (context, state) {
          if (state is MakeNewTweetLoadedState) {
            Navigator.pop(context);
          } else if (state is MakeNewTweetFailureState) {
            showCustomSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          return CustomModalProgressHUD(
            inAsyncCall: state is MakeNewTweetLoadingState,
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
                    TweetTextFieldPart(
                      userEntity: userEntity,
                      textTweetController: textTweetController,
                    ),
                    const VerticalGap(28),
                    MediaPreviewPart(
                      mediaFiles: mediaFiles,
                      onRemoveImageButtonPressed: _onRemoveImageButtonPressed,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MediaPreviewPart extends StatelessWidget {
  const MediaPreviewPart({
    super.key,
    required this.mediaFiles,
    required this.onRemoveImageButtonPressed,
  });

  final List<File> mediaFiles;
  final void Function(int index) onRemoveImageButtonPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mediaFiles.length,
        separatorBuilder: (context, index) => const HorizontalGap(12),
        itemBuilder: (context, index) => Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              child: Image.file(
                mediaFiles[index],
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => onRemoveImageButtonPressed(index),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.remove_circle,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TweetTextFieldPart extends StatelessWidget {
  const TweetTextFieldPart({
    super.key,
    required this.userEntity,
    required this.textTweetController,
  });

  final UserEntity userEntity;
  final TextEditingController textTweetController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildUserCircleAvatarImage(
          profilePicUrl: userEntity.profilePicUrl,
          circleAvatarRadius: 20,
        ),
        const HorizontalGap(24),
        Expanded(
          child: CustomTextFormFieldWidget(
            controller: textTweetController,
            contentPadding: 0,
            borderWidth: 0,
            borderColor: Colors.white,
            focusedBorderWidth: 0,
            focusedBorderColor: Colors.white,
            fillColor: Colors.white,
            hintText: "What`s happening?",
            hintStyle: AppTextStyles.uberMoveRegular22.copyWith(
              color: AppColors.secondaryColor,
            ),
            maxLines: null,
          ),
        ),
      ],
    );
  }
}
