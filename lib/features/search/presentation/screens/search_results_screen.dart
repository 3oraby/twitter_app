import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/features/search/presentation/widgets/custom_search_text_field.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({
    super.key,
    required this.query,
  });

  static const String routeId = 'kSearchResultsScreen';
  final String query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: AppConstants.topPadding,
        ),
        child: buildCustomAppBar(
          context,
          title: CustomSearchTextField(
            hintText: query,
          ),
        ),
      ),
    );
  }
}
