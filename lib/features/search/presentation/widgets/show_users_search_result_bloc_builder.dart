import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_empty_body_widget.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/follow_relationships/domain/entities/user_with_follow_status_entity.dart';
import 'package:twitter_app/features/follow_relationships/presentation/widgets/custom_show_users_list.dart';
import 'package:twitter_app/features/search/presentation/cubits/get_users_search_cubit/get_users_search_cubit.dart';

class ShowUsersSearchResultBlocBuilder extends StatefulWidget {
  const ShowUsersSearchResultBlocBuilder({
    super.key,
    required this.query,
  });
  final String query;

  @override
  State<ShowUsersSearchResultBlocBuilder> createState() =>
      _ShowUsersSearchResultBlocBuilderState();
}

class _ShowUsersSearchResultBlocBuilderState
    extends State<ShowUsersSearchResultBlocBuilder> {
  late UserEntity currentUser;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
    textController.text = widget.query;
    BlocProvider.of<GetUsersSearchCubit>(context).getUsersSearch(
      query: widget.query.trim(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUsersSearchCubit, GetUsersSearchState>(
      builder: (context, state) {
        if (state is GetUsersSearchLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        } else if (state is GetUsersSearchEmptyState) {
          return CustomEmptyBodyWidget(
            mainLabel: context.tr("No Results Found"),
            subLabel: context.tr("Try searching for something else!"),
          );
        } else if (state is GetUsersSearchFailureState) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is GetUsersSearchLoadedState) {
          List<UserWithFollowStatusEntity> users = state.users;
          return CustomShowUsersList(
            userConnections: users,
            currentUser: currentUser,
          );
        }
        return const SizedBox();
      },
    );
  }
}
