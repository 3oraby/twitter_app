import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/errors/custom_exception.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/custom_text_form_field.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/home/presentation/widgets/custom_floating_action_button.dart';

class MakeNewTweetScreen extends StatefulWidget {
  const MakeNewTweetScreen({super.key});

  static const String routeId = "kMakeNewTweetScreen";

  @override
  State<MakeNewTweetScreen> createState() => _MakeNewTweetScreenState();
}

class _MakeNewTweetScreenState extends State<MakeNewTweetScreen> {
  TextEditingController textTweetController = TextEditingController();
  bool _isPickedImageLoading = false;

  late UserEntity userEntity;
  List<File> mediaUrl = [];

  Future<void> _onAddImagePressed() async {
    try {
      setState(() {
        _isPickedImageLoading = true;
      });
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File fileImage = File(image.path);
        setState(() {
          mediaUrl.add(fileImage);
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

  _onRemoveImageButtonPressed(index) {
    setState(() {
      mediaUrl.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    userEntity = getCurrentUserEntity();
  }

  @override
  void dispose() {
    super.dispose();
    textTweetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
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
            backgroundColor: textTweetController.text.isEmpty
                ? AppColors.lightTwitterAccentColor
                : AppColors.twitterAccentColor,
            child: Text(
              "Post",
              style:
                  AppTextStyles.uberMoveMedium18.copyWith(color: Colors.white),
            ),
          ),
          const HorizontalGap(AppConstants.horizontalPadding),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        iconData: Icons.add_a_photo,
        onPressed: _onAddImagePressed,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildUserCircleAvatarImage(
                  profilePicUrl: userEntity.profilePicUrl,
                  circleAvatarRadius: 20,
                ),
                const HorizontalGap(8),
                Expanded(
                  child: CustomTextFormFieldWidget(
                    controller: textTweetController,
                    borderWidth: 0,
                    borderColor: Colors.white,
                    focusedBorderWidth: 0,
                    focusedBorderColor: Colors.white,
                    fillColor: Colors.white,
                    hintText: "What`s happening?",
                    hintStyle: AppTextStyles.uberMoveRegular22.copyWith(
                      color: AppColors.secondaryColor,
                    ),
                    maxLines: 8,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: mediaUrl.length,
                separatorBuilder: (context, index) => const HorizontalGap(12),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: Skeletonizer(
                    enabled: _isPickedImageLoading,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppConstants.borderRadius),
                          child: Image(
                            image: FileImage(
                              mediaUrl[index],
                            ),
                            height: 300,
                            width: 300,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                debugPrint('image loading null');
                                return child;
                              }
                              debugPrint('image loading...');
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () => _onRemoveImageButtonPressed(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.black),
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
