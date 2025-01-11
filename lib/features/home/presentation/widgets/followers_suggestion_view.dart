import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
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
    return Container(
      color: Colors.amber,
      child: Column(
        children: [
          Text(user.userId),
          Text(user.firstName!),
          Text(user.email),
        ],
      ),
    );
  }
}
