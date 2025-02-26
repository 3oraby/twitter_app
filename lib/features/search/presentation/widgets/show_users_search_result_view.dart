import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/search/domain/repos/users_search_repo.dart';
import 'package:twitter_app/features/search/presentation/cubits/get_users_search_cubit/get_users_search_cubit.dart';
import 'package:twitter_app/features/search/presentation/widgets/show_users_search_result_bloc_builder.dart';

class ShowUsersSearchResultView extends StatelessWidget {
  const ShowUsersSearchResultView({
    super.key,
    required this.query,
  });
  final String query;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetUsersSearchCubit(
        usersSearchRepo: getIt<UsersSearchRepo>(),
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
            vertical: AppConstants.topPadding,
          ),
          child: ShowUsersSearchResultBlocBuilder(query: query),
        ),
      ),
    );
  }
}
