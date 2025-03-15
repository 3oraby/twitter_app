import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

class CustomSearchTextField extends StatelessWidget {
  const CustomSearchTextField({
    super.key,
    this.onSubmitted,
    this.hintText = "Search",
    this.textController,
    this.onTap,
  });

  final VoidCallback? onTap;
  final void Function(String?)? onSubmitted;
  final TextEditingController? textController;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onSubmitted: onSubmitted,
      onTap: onTap,
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
        hintStyle: AppTextStyles.uberMoveMedium(context,20).copyWith(
          color: AppColors.thirdColor,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.thirdColor,
        ),
      ),
      style: AppTextStyles.uberMoveMedium(context,20).copyWith(
        color: AppColors.thirdColor,
      ),
    );
  }
}
