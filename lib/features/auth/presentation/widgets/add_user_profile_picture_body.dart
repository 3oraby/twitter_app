import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/errors/custom_exception.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_background_icon.dart';
import 'package:twitter_app/core/widgets/custom_trigger_button.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/home/presentation/screens/home_screen.dart';

import '../cubits/add_user_profile_picture_cubit/add_user_profile_picture_cubit.dart';

class AddUserProfilePictureBody extends StatefulWidget {
  const AddUserProfilePictureBody({super.key});

  @override
  State<AddUserProfilePictureBody> createState() =>
      _AddUserProfilePictureBodyState();
}

class _AddUserProfilePictureBodyState extends State<AddUserProfilePictureBody> {
  bool _isImageUploaded = false;
  bool _isPickedImageLoading = false;
  File? fileImage;

  void _onSaveAndProceedButtonPressed() {
    if (_isImageUploaded) {
      BlocProvider.of<AddUserProfilePictureCubit>(context)
          .addUserProfilePicture(
        file: fileImage!,
      );
    } else {
      showCustomSnackBar(
        context,
        context.tr("Please upload a profile picture before proceeding."),
      );
    }
  }

  Future<void> _onAddImagePressed() async {
    try {
      setState(() {
        _isPickedImageLoading = true;
      });
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        fileImage = File(image.path);
        setState(() {
          _isImageUploaded = true;
        });
      }
    } catch (e) {
      log("There is an exception with adding an image in AddUserProfileScreen: $e");
      throw CustomException(message: "Failed to upload image".tr());
    } finally {
      setState(() {
        _isPickedImageLoading = false;
      });
    }
  }

  void _onSkipForNowButtonPressed() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      HomeScreen.routeId,
      (route) => false,
    );
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr("Pick a profile picture"),
            style: AppTextStyles.uberMoveBlack30,
          ),
          const VerticalGap(16),
          Text(
            context.tr("Have a favorite selfie? Upload it now."),
            style: AppTextStyles.uberMoveRegular18.copyWith(
              color: AppColors.secondaryColor,
            ),
          ),
          const VerticalGap(48),
          Skeletonizer(
            enabled: _isPickedImageLoading,
            child: GestureDetector(
              onTap: _onAddImagePressed,
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: AppColors.highlightBackgroundColor,
                      child: fileImage == null
                          ? const Icon(
                              Icons.person_2,
                              size: 140,
                              color: Colors.grey,
                            )
                          : ClipOval(
                              child: Image.file(
                                fileImage!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Visibility(
                      visible: fileImage != null,
                      child: Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: _onRemoveImagePressed,
                          child: const CustomBackgroundIcon(
                            iconData: Icons.close,
                            iconColor: Colors.white,
                            backgroundColor: AppColors.twitterAccentColor,
                            iconSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: fileImage == null,
                      child: const Positioned(
                        bottom: 15,
                        right: 15,
                        child: CustomBackgroundIcon(
                          iconData: Icons.add,
                          iconColor: Colors.white,
                          backgroundColor: AppColors.twitterAccentColor,
                          iconSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          CustomTriggerButton(
            onPressed: _onSaveAndProceedButtonPressed,
            buttonDescription: Text(
              context.tr("Save & Proceed"),
              style: AppTextStyles.uberMoveBold18.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: _isImageUploaded
                ? AppColors.primaryColor
                : AppColors.unEnabledButtonColor,
          ),
          const VerticalGap(16),
          Center(
            child: GestureDetector(
              onTap: _onSkipForNowButtonPressed,
              child: Text(
                context.tr("Skip for now"),
                style: AppTextStyles.uberMoveBold20.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primaryColor,
                  decorationThickness: 2,
                ),
              ),
            ),
          ),
          const VerticalGap(AppConstants.bottomPadding),
        ],
      ),
    );
  }
}
