import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';

class CustomLoadingBody extends StatelessWidget {
  const CustomLoadingBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.primary
            : AppColors.primaryColor,
      ),
    );
  }
}
