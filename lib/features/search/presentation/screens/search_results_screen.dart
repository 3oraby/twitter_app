import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_empty_body_widget.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/follow_relationships/domain/entities/user_with_follow_status_entity.dart';
import 'package:twitter_app/features/follow_relationships/presentation/widgets/user_info_card.dart';
import 'package:twitter_app/features/search/domain/repos/users_search_repo.dart';
import 'package:twitter_app/features/search/presentation/cubits/get_users_search_cubit/get_users_search_cubit.dart';
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
    return BlocProvider(
      create: (context) => GetUsersSearchCubit(
        usersSearchRepo: getIt<UsersSearchRepo>(),
      ),
      child: Scaffold(
        body: SearchResultsBlocConsumerBody(query: query),
      ),
    );
  }
}

class SearchResultsBlocConsumerBody extends StatefulWidget {
  const SearchResultsBlocConsumerBody({
    super.key,
    required this.query,
  });

  final String query;

  @override
  State<SearchResultsBlocConsumerBody> createState() =>
      _SearchResultsBlocConsumerBodyState();
}

class _SearchResultsBlocConsumerBodyState
    extends State<SearchResultsBlocConsumerBody> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.topPadding,
      ),
      child: ListView(
        children: [
          buildCustomAppBar(
            context,
            title: CustomSearchTextField(
              textController: textController,
              hintText: widget.query,
            ),
          ),
          BlocBuilder<GetUsersSearchCubit, GetUsersSearchState>(
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
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (context, index) => const VerticalGap(16),
                  itemBuilder: (context, index) => UserInfoCard(
                    user: users[index].user,
                    currentUserId: currentUser.userId,
                    isActiveFollowButton: users[index].isFollowedByCurrentUser,
                    showFollowsYouLabel: users[index].isFollowingCurrentUser,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
