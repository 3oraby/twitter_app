import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

class CustomSearchTextField extends StatelessWidget {
  const CustomSearchTextField({
    super.key,
    this.onSubmitted,
    this.hintText = "Search",
  });

  final void Function(String?)? onSubmitted;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.textFieldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        hintText: hintText,
        hintStyle: AppTextStyles.uberMoveMedium20.copyWith(
          color: AppColors.thirdColor,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.thirdColor,
        ),
      ),
      style: AppTextStyles.uberMoveMedium20.copyWith(
        color: AppColors.thirdColor,
      ),
    );
  }
}
