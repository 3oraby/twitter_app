import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';

class SearchView extends StatelessWidget {
  const SearchView({
    super.key,
  });
  AppBar buildSearchAppBar({
    required BuildContext context,
  }) {
    return buildCustomAppBar(
      context,
      title: const Text("Search"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSearchAppBar(context: context),
        Container(
            color: Colors.green, child: const Center(child: Text('Page 2'))),
      ],
    );
  }
}
