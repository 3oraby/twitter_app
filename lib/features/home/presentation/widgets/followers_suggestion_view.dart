import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/home/presentation/cubits/get_followers_suggestions_cubit/get_followers_suggestions_cubit.dart';

class FollowersSuggestionView extends StatefulWidget {
  const FollowersSuggestionView({super.key});

  @override
  State<FollowersSuggestionView> createState() =>
      _FollowersSuggestionViewState();
}

class _FollowersSuggestionViewState extends State<FollowersSuggestionView> {
  AppBar buildSuggestionsAppBar({
    required BuildContext context,
  }) {
    return buildCustomAppBar(
      context,
      automaticallyImplyLeading: false,
      title: Text(
        "Connect",
        style: AppTextStyles.uberMoveBlack20,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    UserEntity currentUser = getCurrentUserEntity();
    log("get suggestions followers data");
    BlocProvider.of<GetFollowersSuggestionsCubit>(context)
        .getFollowersSuggestions(currentUserId: currentUser.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSuggestionsAppBar(context: context),
        const FollowersSuggestionsBlocConsumerBody()
      ],
    );
  }
}

class FollowersSuggestionsBlocConsumerBody extends StatelessWidget {
  const FollowersSuggestionsBlocConsumerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetFollowersSuggestionsCubit,
        GetFollowersSuggestionsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GetFollowersSuggestionsLoadedState) {
          return FollowersSuggestionsBody(
            suggestionUsers: state.suggestionUsers,
          );
        } else if (state is GetFollowersSuggestionsLoadingState) {
          return const CircularProgressIndicator(
            color: AppColors.primaryColor,
          );
        } else if (state is GetFollowersSuggestionsFailureState) {
          return Text(state.message);
        }
        return const SizedBox();
      },
    );
  }
}

class FollowersSuggestionsBody extends StatelessWidget {
  const FollowersSuggestionsBody({
    super.key,
    required this.suggestionUsers,
  });

  final List<UserEntity> suggestionUsers;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Suggested for you",
                    style: AppTextStyles.uberMoveBlack24,
                  ),
                ],
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: suggestionUsers.length,
                separatorBuilder: (context, index) => const VerticalGap(24),
                itemBuilder: (context, index) => UserInfoCard(
                  user: suggestionUsers[index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.user,
  });

  final UserEntity user;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // go to this user profile screen
      },
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: BuildUserCircleAvatarImage(
              profilePicUrl: user.profilePicUrl,
            ),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                "${user.firstName} ${user.lastName}",
                style: AppTextStyles.uberMoveExtraBold18,
              ),
            ),
            subtitle: Text(
              user.email,
              style: AppTextStyles.uberMoveBold16.copyWith(
                color: AppColors.secondaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: CustomContainerButton(
              internalHorizontalPadding: 32,
              internalVerticalPadding: 8,
              backgroundColor: AppColors.primaryColor,
              onPressed: () {
                // make + remove follow relationship
              },
              child: Text(
                "Follow",
                style:
                    AppTextStyles.uberMoveBold14.copyWith(color: Colors.white),
              ),
            ),
          ),
          if (user.bio != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  user.bio!,
                  style: AppTextStyles.uberMoveMedium18,
                ),
              ],
            )
        ],
      ),
    );
  }
}
