import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_empty_body_widget.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/follow_relationships/domain/entities/user_with_follow_status_entity.dart';
import 'package:twitter_app/features/follow_relationships/domain/repos/follow_repo.dart';
import 'package:twitter_app/features/follow_relationships/presentation/cubits/get_user_connections_cubit/get_user_connections_cubit.dart';
import 'package:twitter_app/features/follow_relationships/presentation/widgets/user_info_card.dart';
import 'package:twitter_app/features/home/presentation/screens/main_app_screen.dart';

class UserFollowersTabBarView extends StatelessWidget {
  const UserFollowersTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetUserConnectionsCubit(
        followRepo: getIt<FollowRepo>(),
      ),
      child: const UserFollowersTabBarBlocConsumerBody(),
    );
  }
}

class UserFollowersTabBarBlocConsumerBody extends StatefulWidget {
  const UserFollowersTabBarBlocConsumerBody({super.key});

  @override
  State<UserFollowersTabBarBlocConsumerBody> createState() =>
      _UserFollowersTabBarBlocConsumerBodyState();
}

class _UserFollowersTabBarBlocConsumerBodyState
    extends State<UserFollowersTabBarBlocConsumerBody> {
  late UserEntity currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
    BlocProvider.of<GetUserConnectionsCubit>(context).getUserConnections(
      currentUserId: currentUser.userId,
      isFetchingFollowers: true,
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
          return UserFollowersTabBarBody(
            userConnections: state.userConnections,
            currentUser: currentUser,
          );
        } else if (state is GetUserConnectionsEmptyState) {
          return CustomEmptyBodyWidget(
            mainLabel: "No Followers Yet!",
            subLabel:
                "It looks like no one is following you right now. Share your profile to gain followers.",
            buttonDescription: "back to home",
            onButtonPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                MainAppScreen.routeId,
                (route) => false,
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

class UserFollowersTabBarBody extends StatelessWidget {
  const UserFollowersTabBarBody({
    super.key,
    required this.userConnections,
    required this.currentUser,
  });

  final List<UserWithFollowStatusEntity> userConnections;
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
          user: userConnections[index].user.toEntity(),
          currentUserId: currentUser.userId,
          showFollowsYouLabel: userConnections[index].followsYou,
          isActiveFollowButton: userConnections[index].isFollowed,
        ),
      ),
    );
  }
}
