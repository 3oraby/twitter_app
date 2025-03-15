import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  Color? backgroundColor,
}) {
  final theme = Theme.of(context);

  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    showCloseIcon: true,
    duration: const Duration(seconds: 3),
    backgroundColor: backgroundColor ??
        (theme.brightness == Brightness.dark
            ? theme.colorScheme.primaryContainer
            : AppColors.primaryColor),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
