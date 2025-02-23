import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/features/search/presentation/screens/search_results_screen.dart';
import 'package:twitter_app/features/search/presentation/widgets/custom_search_text_field.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const String routeId = 'kSearchScreen';

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
      ),
    );
  }
}
