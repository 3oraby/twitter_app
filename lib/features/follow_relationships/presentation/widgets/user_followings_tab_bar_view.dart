import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_empty_body_widget.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/follow_relationships/domain/repos/follow_repo.dart';
import 'package:twitter_app/features/follow_relationships/presentation/cubits/get_user_connections_cubit/get_user_connections_cubit.dart';
import 'package:twitter_app/features/follow_relationships/presentation/screens/followers_suggestion_screen.dart';
import 'package:twitter_app/features/follow_relationships/presentation/widgets/custom_show_users_list.dart';

class UserFollowingsTabBarView extends StatelessWidget {
  const UserFollowingsTabBarView({
    super.key,
    required this.targetUserId,
  });

  final String targetUserId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetUserConnectionsCubit(
        followRepo: getIt<FollowRepo>(),
      ),
      child: UserFollowingsTabBarBlocConsumerBody(
        targetUserId: targetUserId,
      ),
    );
  }
}

class UserFollowingsTabBarBlocConsumerBody extends StatefulWidget {
  const UserFollowingsTabBarBlocConsumerBody({
    super.key,
    required this.targetUserId,
  });
  final String targetUserId;

  @override
  State<UserFollowingsTabBarBlocConsumerBody> createState() =>
      _UserFollowingsTabBarBlocConsumerBodyState();
}

class _UserFollowingsTabBarBlocConsumerBodyState
    extends State<UserFollowingsTabBarBlocConsumerBody> {
  late UserEntity currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
    BlocProvider.of<GetUserConnectionsCubit>(context).getUserConnections(
      targetUserId: widget.targetUserId,
      isFetchingFollowers: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetUserConnectionsCubit, GetUserConnectionsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GetUserConnectionsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        } else if (state is GetUserConnectionsFailureState) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is GetUserConnectionsLoadedState) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
            ),
            child: CustomShowUsersList(
              userConnections: state.userConnections,
              currentUser: currentUser,
            ),
          );
        } else if (state is GetUserConnectionsEmptyState) {
          bool isCurrentUser = currentUser.userId == widget.targetUserId;

          return CustomEmptyBodyWidget(
            mainLabel: isCurrentUser
                ? context.tr("No Followings Yet!")
                : context.tr("No Followings Found"),
            subLabel: isCurrentUser
                ? context.tr(
                    "You are not following anyone yet. Explore accounts and start connecting.")
                : context.tr("This user is not following anyone yet."),
            buttonDescription:
                isCurrentUser ? context.tr("Discover Accounts") : null,
            onButtonPressed: isCurrentUser
                ? () {
                    Navigator.pushNamed(
                      context,
                      FollowersSuggestionScreen.routeId,
                    );
                  }
                : null,
          );
        }
        return const SizedBox();
      },
    );
  }
}
