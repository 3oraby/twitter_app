import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/features/search/presentation/screens/search_results_screen.dart';
import 'package:twitter_app/features/search/presentation/widgets/custom_search_text_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String routeId = 'kSearchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: AppConstants.topPadding,
        ),
        child: Column(
          spacing: 8,
          children: [
            buildCustomAppBar(
              context,
              title: CustomSearchTextField(
                onSubmitted: (query) {
                  if (query != null && query.isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      SearchResultsScreen.routeId,
                      arguments: query,
                    );
                  }
                },
              ),
            ),
            Text(
              context.tr("Try searching for people and tweets"),
              style: AppTextStyles.uberMoveRegular20.copyWith(
                color: AppColors.thirdColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
