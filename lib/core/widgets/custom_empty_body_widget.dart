import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_images.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';

class CustomEmptyBodyWidget extends StatefulWidget {
  const CustomEmptyBodyWidget({
    super.key,
    required this.mainLabel,
    required this.subLabel,
    this.buttonDescription,
    this.imageName = AppImages.imagesNoResult,
    this.onButtonPressed,
  });

  final String imageName;
  final String mainLabel;
  final String subLabel;
  final String? buttonDescription;
  final VoidCallback? onButtonPressed;

  @override
  State<CustomEmptyBodyWidget> createState() => _CustomEmptyBodyWidgetState();
}

class _CustomEmptyBodyWidgetState extends State<CustomEmptyBodyWidget> {
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
            Image.asset(
              widget.imageName,
              height: MediaQuery.sizeOf(context).height * 0.35,
              width: MediaQuery.sizeOf(context).width * 0.7,
            ),
            const VerticalGap(20),
            Text(widget.mainLabel, style: AppTextStyles.uberMoveBold26),
            const VerticalGap(10),
            Text(
              widget.subLabel,
              textAlign: TextAlign.center,
              style: AppTextStyles.uberMoveMedium20
                  .copyWith(color: AppColors.secondaryColor),
            ),
            const VerticalGap(30),
            if (widget.buttonDescription != null)
              CustomContainerButton(
                backgroundColor: AppColors.primaryColor,
                borderRadius: AppConstants.borderRadius,
                onPressed: widget.onButtonPressed,
                child: Text(
                  widget.buttonDescription!,
                  style: AppTextStyles.uberMoveBold16
                      .copyWith(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
