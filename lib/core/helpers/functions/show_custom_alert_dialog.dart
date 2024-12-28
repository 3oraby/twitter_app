
import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

void showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String okButtonDescription,
  String cancelButtonDescription = "Cancel",
  VoidCallback? onCancelButtonPressed,
  VoidCallback? onOkButtonPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: onCancelButtonPressed,
                child: Text(cancelButtonDescription),
              ),
              const Spacer(),
              TextButton(
                onPressed: onOkButtonPressed,
                child: Text(
                  okButtonDescription,
                  style: AppTextStyles.uberMoveMedium18.copyWith(
                    color: AppColors.errorColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
