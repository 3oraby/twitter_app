import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.filters,
    required this.sheetTitle,
  });

  final String selectedFilter;
  final Function(String) onFilterSelected;
  final List<String> filters;
  final String sheetTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.topPadding,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            AppConstants.bottomSheetBorderRadius,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 60,
            color: AppColors.dividerColor,
          ),
          const VerticalGap(10),
          Text(
            sheetTitle,
            style: AppTextStyles.uberMoveBlack(context,18),
          ),
          const VerticalGap(10),
          ...filters.map((filter) {
            return ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                context.tr(filter),
                style: AppTextStyles.uberMoveBold(context,18),
              ),
              trailing: selectedFilter == filter
                  ? const Icon(
                      Icons.check_circle,
                      color: AppColors.twitterAccentColor,
                      size: 28,
                    )
                  : const Icon(
                      Icons.circle_outlined,
                      size: 28,
                      color: AppColors.dividerColor,
                    ),
              onTap: () => onFilterSelected(filter),
            );
          }),
          const VerticalGap(10),
        ],
      ),
    );
  }
}
