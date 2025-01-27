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
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/data/models/comment_model.dart';
import 'package:twitter_app/features/comments/presentation/cubits/make_new_comment_cubit/make_new_comment_cubit.dart';
import 'package:twitter_app/features/comments/presentation/widgets/make_new_comment_body.dart';
import 'package:twitter_app/features/home/presentation/widgets/custom_floating_action_button.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class MakeNewCommentBlocConsumerBody extends StatefulWidget {
  const MakeNewCommentBlocConsumerBody({
    super.key,
    required this.tweetDetailsEntity,
  });

  final TweetDetailsEntity tweetDetailsEntity;

  @override
  State<MakeNewCommentBlocConsumerBody> createState() =>
      _MakeNewCommentBlocConsumerBodyState();
}

class _MakeNewCommentBlocConsumerBodyState
    extends State<MakeNewCommentBlocConsumerBody> {
  final TextEditingController textCommentController = TextEditingController();
  late UserEntity currentUser;
  List<File> mediaFiles = [];
  bool _isPostButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();

    textCommentController.addListener(() {
      setState(() {
        _isPostButtonEnabled = textCommentController.text.trim().isNotEmpty;
      });
    });
  }

  Future<void> _onAddImagePressed() async {
    try {
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
    } finally {}
  }

  void _onRemoveImageButtonPressed(int index) {
    setState(() {
      mediaFiles.removeAt(index);
    });
  }

  void _onPostButtonPressed(BuildContext context) async {
    final text = textCommentController.text.trim();

    if (text.isNotEmpty || mediaFiles.isNotEmpty) {
      CommentModel commentModel = CommentModel(
        tweetId: widget.tweetDetailsEntity.tweetId,
        tweetAuthorData: widget.tweetDetailsEntity.user,
        commentAuthorData: currentUser,
        createdAt: Timestamp.now(),
      );
      BlocProvider.of<MakeNewCommentCubit>(context).makeNewComment(
        data: commentModel.toJson(),
        mediaFiles: mediaFiles,
      );
    }
  }

  @override
  void dispose() {
    textCommentController.dispose();
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
          backgroundColor: textCommentController.text.trim().isNotEmpty ||
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
    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: CustomFloatingActionButton(
        iconData: Icons.add_a_photo,
        onPressed: _onAddImagePressed,
      ),
      body: BlocConsumer<MakeNewCommentCubit, MakeNewCommentState>(
        listener: (context, state) {
          if (state is MakeNewCommentFailureState) {
            showCustomSnackBar(context, state.message);
          } else if (state is MakeNewCommentLoadedState) {
            //! load sound
            showCustomSnackBar(context, "Comment sent 🚀");
            Navigator.pop(context);
            //! load the comment in the first of the list
          }
        },
        builder: (context, state) {
          return MakeNewCommentBody(
            tweetDetailsEntity: widget.tweetDetailsEntity,
            currentUser: currentUser,
            textCommentController: textCommentController,
            mediaFiles: mediaFiles,
            onRemoveImageButtonPressed: _onRemoveImageButtonPressed,
          );
        },
      ),
    );
  }
}
