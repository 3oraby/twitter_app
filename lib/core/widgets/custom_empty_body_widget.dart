import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_images.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';

class CustomEmptyBodyWidget extends StatelessWidget {
  const CustomEmptyBodyWidget({
    super.key,
    required this.mainLabel,
    required this.subLabel,
    this.buttonDescription,
    this.imageName = AppImages.imagesNoResult,
    this.onButtonPressed,
    this.showImage = true,
  });

  final String imageName;
  final String mainLabel;
  final String subLabel;
  final String? buttonDescription;
  final VoidCallback? onButtonPressed;
  final bool showImage;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: showImage,
              child: Image.asset(
                imageName,
                height: MediaQuery.sizeOf(context).height * 0.35,
                width: MediaQuery.sizeOf(context).width * 0.7,
              ),
            ),
            const VerticalGap(20),
            Text(
              mainLabel,
              textAlign: TextAlign.center,
              style: AppTextStyles.uberMoveBold(context,26),
            ),
            const VerticalGap(10),
            Text(
              subLabel,
              textAlign: TextAlign.center,
              style: AppTextStyles.uberMoveMedium(context,20)
                  .copyWith(color: AppColors.secondaryColor),
            ),
            const VerticalGap(30),
            if (buttonDescription != null)
              CustomContainerButton(
                borderRadius: AppConstants.borderRadius,
                onPressed: onButtonPressed,
                child: Text(
                  buttonDescription!,
                  style: AppTextStyles.uberMoveBold(context,16)
                      .copyWith(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
