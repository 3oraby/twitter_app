import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

class CustomUpdateUserDataTextField extends StatelessWidget {
  const CustomUpdateUserDataTextField({
    super.key,
    required this.textEditingController,
    this.hintText,
    this.validator,
  });

  final TextEditingController textEditingController;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: TextInputType.visiblePassword,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.uberMoveMedium(context,18).copyWith(
          color: AppColors.thirdColor,
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.5,
            color: AppColors.dividerColor,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.5,
            color: AppColors.dividerColor,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}