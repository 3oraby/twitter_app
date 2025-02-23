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
import 'package:twitter_app/features/follow_relationships/presentation/widgets/custom_show_users_list.dart';
import 'package:twitter_app/features/home/presentation/screens/main_app_screen.dart';

class UserFollowersTabBarView extends StatelessWidget {
  const UserFollowersTabBarView({
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
      child: UserFollowersTabBarBlocConsumerBody(
        targetUserId: targetUserId,
      ),
    );
  }
}

class UserFollowersTabBarBlocConsumerBody extends StatefulWidget {
  const UserFollowersTabBarBlocConsumerBody({
    super.key,
    required this.targetUserId,
  });

  final String targetUserId;
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
      targetUserId: widget.targetUserId,
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
            child: Text(context.tr(state.message)),
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
                ? context.tr("No Followers Yet!")
                : context.tr("No Followers Found"),
            subLabel: isCurrentUser
                ? context.tr(
                    "It looks like no one is following you right now. Share your profile to gain followers.")
                : context.tr("This user has no followers yet."),
            buttonDescription:
                isCurrentUser ? context.tr("Back to Home") : null,
            onButtonPressed: isCurrentUser
                ? () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      MainAppScreen.routeId,
                      (route) => false,
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