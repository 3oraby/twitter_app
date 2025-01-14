import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_empty_body_widget.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/follow_relationships/domain/repos/follow_repo.dart';
import 'package:twitter_app/features/follow_relationships/presentation/cubits/get_user_connections_cubit/get_user_connections_cubit.dart';
import 'package:twitter_app/features/follow_relationships/presentation/screens/followers_suggestion_screen.dart';
import 'package:twitter_app/features/follow_relationships/presentation/widgets/user_info_card.dart';

class UserFollowingsTabBarView extends StatelessWidget {
  const UserFollowingsTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetUserConnectionsCubit(
        followRepo: getIt<FollowRepo>(),
      ),
      child: const UserFollowingsTabBarBlocConsumerBody(),
    );
  }
}

class UserFollowingsTabBarBlocConsumerBody extends StatefulWidget {
  const UserFollowingsTabBarBlocConsumerBody({super.key});

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
      currentUserId: currentUser.userId,
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
          return UserFollowingsTabBarBody(
            userConnections: state.userConnections,
            currentUser: currentUser,
          );
        } else if (state is GetUserConnectionsEmptyState) {
          return CustomEmptyBodyWidget(
            mainLabel: "No Followings Yet!",
            subLabel:
                "You are not following anyone yet. Explore accounts and start connecting.",
            buttonDescription: "Discover Accounts",
            onButtonPressed: () {
              Navigator.pushNamed(
                context,
                FollowersSuggestionScreen.routeId,
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

class UserFollowingsTabBarBody extends StatelessWidget {
  const UserFollowingsTabBarBody({
    super.key,
    required this.userConnections,
    required this.currentUser,
  });

  final List<UserEntity> userConnections;
  final UserEntity currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: userConnections.length,
        separatorBuilder: (context, index) => const VerticalGap(24),
        itemBuilder: (context, index) => UserInfoCard(
          user: userConnections[index],
          currentUserId: currentUser.userId,
          isActiveFollowButton: true,
        ),
      ),
    );
  }
}
