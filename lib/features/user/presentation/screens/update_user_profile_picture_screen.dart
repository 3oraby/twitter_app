import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/errors/custom_exception.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/pick_image_from_gallery.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/repos/files_repo/files_repo.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_background_icon.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/user/presentation/cubits/set_user_profile_picture_cubit/set_user_profile_picture_cubit.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUserProfilePictureScreen extends StatelessWidget {
  const UpdateUserProfilePictureScreen({
    super.key,
  });

  static const String routeId = 'kUpdateUserProfilePictureScreen';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetUserProfilePictureCubit(
        userRepo: getIt<UserRepo>(),
        filesRepo: getIt<FilesRepo>(),
      ),
      child: const UpdateUserProfilePictureBlocConsumerBody(),
    );
  }
}

class UpdateUserProfilePictureBlocConsumerBody extends StatefulWidget {
  const UpdateUserProfilePictureBlocConsumerBody({super.key});

  @override
  State<UpdateUserProfilePictureBlocConsumerBody> createState() =>
      _UpdateUserProfilePictureBlocConsumerBodyState();
}

class _UpdateUserProfilePictureBlocConsumerBodyState
    extends State<UpdateUserProfilePictureBlocConsumerBody> {
  bool _isImageUploaded = false;
  bool _isPickedImageLoading = false;
  File? fileImage;
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
  }

  void _onSaveAndProceedButtonPressed() {
    if (_isImageUploaded) {
      BlocProvider.of<SetUserProfilePictureCubit>(context)
          .setUserProfilePicture(
        file: fileImage!,
        oldFileUrl: currentUser.profilePicUrl,
        isUpload: false,
      );
    }
  }

  Future<void> _onAddImagePressed() async {
    try {
      setState(() {
        _isPickedImageLoading = true;
      });
      final XFile? image = await pickImageFromGallery();
      if (image != null) {
        fileImage = File(image.path);
        setState(() {
          _isImageUploaded = true;
        });
      }
    } catch (e) {
      log("There is an exception with adding an image in UpdateUserProfilePictureScreen: $e");
      throw CustomException(message: "Failed to upload image".tr());
    } finally {
      setState(() {
        _isPickedImageLoading = false;
      });
    }
  }

  void _onRemoveImagePressed() {
    setState(() {
      fileImage = null;
      _isImageUploaded = false;
    });
    showCustomSnackBar(
      context,
      context.tr("Image removed successfully!"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetUserProfilePictureCubit, SetUserProfilePictureState>(
      listener: (context, state) {
        if (state is SetUserProfilePictureFailureState) {
          showCustomSnackBar(context, state.message);
          Navigator.pop(context);
        } else if (state is SetUserProfilePictureLoadedState) {
          showCustomSnackBar(
              context, context.tr("Your profile picture has been updated! 🎉"));
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: buildCustomAppBar(
            context,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    context.tr("Cancel"),
                    style: AppTextStyles.uberMoveMedium(context, 20),
                  ),
                ),
                Text(
                  context.tr("Edit profile"),
                  style: AppTextStyles.uberMoveBlack(context, 20),
                ),
                CustomContainerButton(
                  internalVerticalPadding: 4,
                  backgroundColor: _isImageUploaded
                      ? AppColors.twitterAccentColor
                      : AppColors.lightTwitterAccentColor,
                  onPressed: _isImageUploaded
                      ? () {
                          _onSaveAndProceedButtonPressed();
                        }
                      : null,
                  child: Text(
                    context.tr("Save"),
                    style: AppTextStyles.uberMoveMedium(context, 18)
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
            ),
            child: Column(
              children: [
                Visibility(
                  visible: state is SetUserProfilePictureLoadingState,
                  child: const LinearProgressIndicator(
                    color: AppColors.twitterAccentColor,
                  ),
                ),
                const VerticalGap(16),
                Text(
                  context.tr("Update your profile picture"),
                  style: AppTextStyles.uberMoveBlack(context, 30),
                ),
                const VerticalGap(48),
                Skeletonizer(
                  enabled: _isPickedImageLoading,
                  child: GestureDetector(
                    onTap: _onAddImagePressed,
                    child: Center(
                      child: Stack(
                        alignment: fileImage == null
                            ? Alignment.center
                            : Alignment.topRight,
                        children: [
                          if (fileImage != null)
                            CircleAvatar(
                              radius: 150,
                              backgroundColor:
                                  AppColors.highlightBackgroundColor,
                              child: ClipOval(
                                child: Image.file(
                                  fileImage!,
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Visibility(
                            visible: fileImage == null,
                            child: BuildUserCircleAvatarImage(
                              circleAvatarRadius: 150,
                              profilePicUrl: currentUser.profilePicUrl,
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Visibility(
                              visible: fileImage != null,
                              child: GestureDetector(
                                onTap: _onRemoveImagePressed,
                                child: const CustomBackgroundIcon(
                                  iconData: FontAwesomeIcons.xmark,
                                  iconColor: Colors.white,
                                  backgroundColor: AppColors.twitterAccentColor,
                                  iconSize: 30,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: fileImage == null,
                            child: const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
