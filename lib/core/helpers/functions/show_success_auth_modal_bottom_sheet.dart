import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_animations.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_trigger_button.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';

Future<dynamic> showSuccessAuthModalBottomSheet({
  required BuildContext context,
  required String sheetTitle,
  required String sheetDescription,
  required String buttonDescription,
  required void Function() onNextButtonPressed,
  String imageName = AppAnimations.animationsOperationSuccessfullyDone,
}) {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: Lottie.asset(
                  AppAnimations.animationsOperationSuccessfullyDone,
                  repeat: false,
                ),
              ),
              const VerticalGap(8),
              Text(
                sheetTitle,
                style: AppTextStyles.uberMoveBold22,
              ),
              const VerticalGap(8),
              Text(
                sheetDescription,
                style: AppTextStyles.uberMoveRegular18,
              ),
              const VerticalGap(16),
              CustomTriggerButton(
                onPressed: onNextButtonPressed,
                buttonDescription: Text(
                  buttonDescription,
                  style: AppTextStyles.uberMoveBold18
                      .copyWith(color: Colors.white),
                ),
              ),
              const VerticalGap(16),
            ],
          ),
        ),
      );
    },
  );
}
